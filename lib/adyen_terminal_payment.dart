



import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_adyen_terminal/data/adyen_terminal_response.dart';
import 'package:flutter_adyen_terminal/data/error_codes.dart';


import 'data/adyen_terminal_config.dart';
import 'data/enums.dart';
import 'exceptions/txn_failure_exceptions.dart';

typedef Success<T> = Function(T succesResponse);
typedef Failure<String,T> = Function(String errorMessage,T? failureResponse);
typedef TimeoutOrUnreachable = Function(Function ifTimeout,Function ifUnreachable);


class FlutterAdyen {
  static const MethodChannel _channel = MethodChannel('com.cheqplease.adyen_terminal/channel');
  static const String _methodInit = "init";
  static const String _methodAuthorizeTransaction = "authorize_transaction";
  static const String _methodCancelTransaction = "cancel_transaction";
  static const String _methodPrintReceipt = "print_receipt";
  static const String _methodScanBarcode = "scan_barcode";
  static const String _methodGetDeviceInfo = "get_terminal_info";

  static late AdyenTerminalConfig _terminalConfig;

  static void init(AdyenTerminalConfig terminalConfig){
    _terminalConfig = terminalConfig;
    _channel.invokeMethod(_methodInit,_terminalConfig.toJson());
  }

  static Future<AdyenTerminalResponse> authorizeTransaction({
    required double amount,
    required String transactionId,
    required String currency,
    CaptureType captureType = CaptureType.delayed,
  }) async {
    try {
      final value = await _channel.invokeMethod(_methodAuthorizeTransaction, {
        "amount": amount,
        "transactionId": transactionId,
        "currency": currency,
        "captureType": captureType.name,
      });
      return AdyenTerminalResponse.fromJson(jsonDecode(value));
    } on PlatformException catch (ex) {
      final errorCode = ex.code;
      final errorMessage = ex.message;
      if (errorCode == ErrorCode.transactionFailure.code) {
        throw TxnFailedOnTerminalException(
          errorCode: errorCode,
          errorMessage: errorMessage,
          adyenTerminalResponse: AdyenTerminalResponse.fromJson(ex.details),
        );
      }
      else if (errorCode == ErrorCode.connectionTimeout.code || errorCode == ErrorCode.deviceUnreachable.code) {
        throw FailedToCommunicateTerminalException(
          errorCode: errorCode,
          errorMessage: errorMessage
        );
      } else {
        throw TxnFailureBaseException(
          errorCode: errorCode,
          errorMessage: errorMessage,
        );
      }
    }
  }



  static Future<dynamic> cancelTransaction({required txnId,required cancelTxnId, required terminalId}) async {

    var result = await _channel.invokeMethod(_methodCancelTransaction,{
      "transactionId" : txnId,
      "cancelTxnId" : cancelTxnId
    });

    return result;
  }

  static Future<void> printReceipt(String txnId,String receiptDTOJSON,{Success<String>? onSuccess,
      Failure<String,String?>? onFailure}) async {

    _channel.invokeMethod(_methodPrintReceipt,{
      "receiptDTOJSON" : receiptDTOJSON,
      "transactionId" : txnId
    }).then((value){
      if (onSuccess != null) {
        onSuccess("Print Successful");
      }
    }).catchError((value){
      if (onFailure != null) {
        onFailure(value.details,null);
      }
    });
  }

  static Future<void> scanBarcode(String txnId) async {

    _channel.invokeMethod(_methodScanBarcode,{
      "transactionId" : txnId
    }).then((value){
      /* TODO: Parse the barcode */
    }).catchError((value){
      /* TODO: Parse the barcode */
    });
  }

  static Future<void> getTerminalInfo(String terminalIP, String txnId,{Success<String>? onSuccess,
    Failure<String,dynamic>? onFailure}) async{
    _channel.invokeMethod(_methodGetDeviceInfo, {
      "transactionId" : txnId,
      "terminalIP" : terminalIP
    }).then((value){
      if (onSuccess != null) {
        onSuccess(value);
      }
    }).catchError((value){
      if (onFailure != null) {
        onFailure("Unable to retrieve terminal info",null);
      }
    });
  }

}
