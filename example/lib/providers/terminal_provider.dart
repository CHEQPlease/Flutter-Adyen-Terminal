import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adyen_terminal/adyen_terminal_payment.dart';
import 'package:flutter_adyen_terminal/data/adyen_terminal_config.dart';
import 'package:flutter_adyen_terminal/data/enums.dart';
import 'package:flutter_adyen_terminal/exceptions/txn_failure_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_log.dart';
import '../models/app_config.dart';

class TerminalProvider extends ChangeNotifier {
  // Configuration
  AppEnvironment _environment = AppEnvironment.test;
  AdyenTerminalConfig? _config;
  bool _initialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Transaction state
  final List<TransactionLog> _transactionLogs = [];
  String? _lastTransactionId;
  TransactionLog? _currentTransaction;
  
  // Settings
  CaptureType _captureType = CaptureType.delayed;
  final Set<ForceEntryModeType> _forcedEntryModes = {};
  
  // Getters
  AppEnvironment get environment => _environment;
  AdyenTerminalConfig? get config => _config;
  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TransactionLog> get transactionLogs => List.unmodifiable(_transactionLogs);
  String? get lastTransactionId => _lastTransactionId;
  TransactionLog? get currentTransaction => _currentTransaction;
  CaptureType get captureType => _captureType;
  Set<ForceEntryModeType> get forcedEntryModes => Set.unmodifiable(_forcedEntryModes);
  
  final _uuid = const Uuid();
  
  TerminalProvider() {
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final envString = prefs.getString('environment') ?? 'test';
    _environment = envString == 'prod' ? AppEnvironment.production : AppEnvironment.test;
    
    final captureString = prefs.getString('captureType') ?? 'delayed';
    _captureType = captureString == 'immediate' ? CaptureType.immediate : CaptureType.delayed;
    
    notifyListeners();
    await loadAndInitConfig();
  }
  
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('environment', _environment == AppEnvironment.production ? 'prod' : 'test');
    await prefs.setString('captureType', _captureType == CaptureType.immediate ? 'immediate' : 'delayed');
  }
  
  void setEnvironment(AppEnvironment env) {
    if (_environment != env) {
      _environment = env;
      _initialized = false;
      _config = null;
      notifyListeners();
      _savePreferences();
      loadAndInitConfig();
    }
  }
  
  void setCaptureType(CaptureType type) {
    _captureType = type;
    notifyListeners();
    _savePreferences();
  }
  
  void toggleForcedEntryMode(ForceEntryModeType mode) {
    if (_forcedEntryModes.contains(mode)) {
      _forcedEntryModes.remove(mode);
    } else {
      _forcedEntryModes.add(mode);
    }
    notifyListeners();
  }
  
  void clearForcedEntryModes() {
    _forcedEntryModes.clear();
    notifyListeners();
  }
  
  Future<void> loadAndInitConfig() async {
    _setLoading(true);
    _clearError();
    
    try {
      final envName = _environment == AppEnvironment.production ? 'prod' : 'test';
      final String path = 'assets/config/config_$envName.json';
      final String jsonStr = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      final AdyenTerminalConfig cfg = AdyenTerminalConfig.fromJson(jsonMap);
      
      FlutterAdyen.init(cfg);
      
      _config = cfg;
      _initialized = true;
      _addLog(
        TransactionLog(
          id: _uuid.v4(),
          timestamp: DateTime.now(),
          type: TransactionType.system,
          status: TransactionStatus.success,
          message: 'Configuration loaded and SDK initialized for ${_environment.name}',
        ),
      );
    } catch (e) {
      _config = null;
      _initialized = false;
      _setError('Failed to load configuration: $e');
      _addLog(
        TransactionLog(
          id: _uuid.v4(),
          timestamp: DateTime.now(),
          type: TransactionType.system,
          status: TransactionStatus.failed,
          message: 'Failed to load config: $e',
        ),
      );
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> authorizeTransaction({
    required double amount,
    required String currency,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final transactionId = _generateTransactionId();
    _lastTransactionId = transactionId;
    
    _currentTransaction = TransactionLog(
      id: transactionId,
      timestamp: DateTime.now(),
      type: TransactionType.payment,
      status: TransactionStatus.pending,
      amount: amount,
      currency: currency,
      message: 'Processing payment...',
    );
    notifyListeners();
    
    try {
      final response = await FlutterAdyen.authorizeTransaction(
        amount: amount,
        transactionId: transactionId,
        currency: currency,
        additionalData: additionalData != null ? HashMap.from(additionalData) : null,
        captureType: _captureType,
        forcedEntryModes: _forcedEntryModes.toList(),
      );
      
      _currentTransaction = _currentTransaction!.copyWith(
        status: TransactionStatus.success,
        message: 'Payment authorized successfully',
        response: response.toRawJson(),
      );
      _addLog(_currentTransaction!);
      
    } on TxnFailedOnTerminalException catch (e) {
      _handleTransactionError(e, 'Payment failed on terminal');
    } on TxnTimeoutException catch (e) {
      _handleTransactionError(e, 'Payment timeout');
    } on FailedToCommunicateTerminalException catch (e) {
      _handleTransactionError(e, 'Communication failure');
    } on TxnFailureBaseException catch (e) {
      _handleTransactionError(e, 'Payment failed');
    } catch (e) {
      _handleTransactionError(e, 'Unexpected error');
    } finally {
      _currentTransaction = null;
      _setLoading(false);
    }
  }
  
  Future<void> tokenizeCard({
    required double amount,
    required String currency,
    required String shopperReference,
    String? shopperEmail,
  }) async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final transactionId = _generateTransactionId();
    _lastTransactionId = transactionId;
    
    _currentTransaction = TransactionLog(
      id: transactionId,
      timestamp: DateTime.now(),
      type: TransactionType.tokenization,
      status: TransactionStatus.pending,
      amount: amount,
      currency: currency,
      message: 'Tokenizing card...',
    );
    notifyListeners();
    
    try {
      final response = await FlutterAdyen.tokenizeCard(
        transactionId: transactionId,
        amount: amount,
        currency: currency,
        shopperReference: shopperReference,
        shopperEmail: shopperEmail ?? '',
        forcedEntryModes: _forcedEntryModes.toList(),
      );
      
      _currentTransaction = _currentTransaction!.copyWith(
        status: TransactionStatus.success,
        message: 'Card tokenized successfully',
        response: response.toRawJson(),
      );
      _addLog(_currentTransaction!);
      
    } on TxnFailedOnTokenizedException catch (e) {
      _handleTransactionError(e, 'Tokenization failed');
    } on TxnFailedOnTerminalException catch (e) {
      _handleTransactionError(e, 'Terminal error during tokenization');
    } on TxnTimeoutException catch (e) {
      _handleTransactionError(e, 'Tokenization timeout');
    } on FailedToCommunicateTerminalException catch (e) {
      _handleTransactionError(e, 'Communication failure');
    } on TxnFailureBaseException catch (e) {
      _handleTransactionError(e, 'Tokenization failed');
    } catch (e) {
      _handleTransactionError(e, 'Unexpected error');
    } finally {
      _currentTransaction = null;
      _setLoading(false);
    }
  }
  
  Future<void> cancelTransaction(String? transactionId) async {
    if (!_ensureInitialized()) return;
    
    final txnId = transactionId ?? _lastTransactionId;
    if (txnId == null) {
      _setError('No transaction to cancel');
      return;
    }
    
    _setLoading(true);
    _clearError();
    
    final cancelTxnId = _generateTransactionId();
    
    try {
      await FlutterAdyen.cancelTransaction(
        txnId: txnId,
        cancelTxnId: cancelTxnId,
        terminalId: _config?.terminalId ?? '',
      );
      
      _addLog(TransactionLog(
        id: cancelTxnId,
        timestamp: DateTime.now(),
        type: TransactionType.cancellation,
        status: TransactionStatus.success,
        message: 'Cancel request sent for transaction: $txnId',
      ));
    } catch (e) {
      _setError('Cancel failed: $e');
      _addLog(TransactionLog(
        id: cancelTxnId,
        timestamp: DateTime.now(),
        type: TransactionType.cancellation,
        status: TransactionStatus.failed,
        message: 'Cancel failed: $e',
      ));
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getTerminalInfo() async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final txnId = _generateTransactionId();
    final endpoint = _config?.endpoint ?? '';
    
    String terminalIp = endpoint;
    try {
      final uri = Uri.tryParse(endpoint);
      if (uri != null && uri.host.isNotEmpty) {
        terminalIp = uri.host;
      } else {
        terminalIp = endpoint.replaceFirst(RegExp(r'^https?://'), '');
      }
    } catch (_) {
      terminalIp = endpoint;
    }
    
    try {
      await FlutterAdyen.getTerminalInfo(
        terminalIp,
        txnId,
        onSuccess: (val) {
          _addLog(TransactionLog(
            id: txnId,
            timestamp: DateTime.now(),
            type: TransactionType.utility,
            status: TransactionStatus.success,
            message: 'Terminal Info',
            response: val,
          ));
        },
        onFailure: (msg, _) {
          _setError('Terminal info failed: $msg');
        },
      );
    } catch (e) {
      _setError('Terminal info exception: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> scanBarcode() async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final txnId = _generateTransactionId();
    
    try {
      await FlutterAdyen.scanBarcode(txnId);
      _addLog(TransactionLog(
        id: txnId,
        timestamp: DateTime.now(),
        type: TransactionType.utility,
        status: TransactionStatus.pending,
        message: 'Barcode scan requested',
      ));
    } catch (e) {
      _setError('Scan barcode failed: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getSignature() async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final txnId = _lastTransactionId ?? _generateTransactionId();
    
    try {
      final result = await FlutterAdyen.getSignature(txnId);
      _addLog(TransactionLog(
        id: txnId,
        timestamp: DateTime.now(),
        type: TransactionType.utility,
        status: TransactionStatus.success,
        message: 'Signature retrieved',
        response: jsonEncode(result),
      ));
    } catch (e) {
      _setError('Get signature failed: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> printReceipt(String receiptJson) async {
    if (!_ensureInitialized()) return;
    
    _setLoading(true);
    _clearError();
    
    final txnId = _generateTransactionId();
    
    FlutterAdyen.printReceipt(
      txnId,
      receiptJson,
      onSuccess: (val) {
        _addLog(TransactionLog(
          id: txnId,
          timestamp: DateTime.now(),
          type: TransactionType.utility,
          status: TransactionStatus.success,
          message: 'Receipt printed successfully',
        ));
        _setLoading(false);
      },
      onFailure: (msg, _) {
        _setError('Print failed: $msg');
        _setLoading(false);
      },
    );
  }
  
  void clearLogs() {
    _transactionLogs.clear();
    notifyListeners();
  }
  
  // Private helper methods
  bool _ensureInitialized() {
    if (!_initialized || _config == null) {
      _setError('Terminal not initialized. Please check configuration.');
      return false;
    }
    return true;
  }
  
  String _generateTransactionId() {
    return _uuid.v4().replaceAll('-', '').substring(0, 10);
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  void _addLog(TransactionLog log) {
    _transactionLogs.insert(0, log);
    // Keep only last 100 logs
    if (_transactionLogs.length > 100) {
      _transactionLogs.removeLast();
    }
    notifyListeners();
  }
  
  void _handleTransactionError(dynamic error, String message) {
    String errorMessage = message;
    String? errorCode;
    
    if (error is TxnFailureBaseException) {
      errorCode = error.errorCode;
      errorMessage = '$message: ${error.errorMessage}';
    } else {
      errorMessage = '$message: $error';
    }
    
    _setError(errorMessage);
    
    if (_currentTransaction != null) {
      _currentTransaction = _currentTransaction!.copyWith(
        status: TransactionStatus.failed,
        message: errorMessage,
        errorCode: errorCode,
      );
      _addLog(_currentTransaction!);
    }
  }
}
