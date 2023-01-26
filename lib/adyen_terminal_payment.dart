

import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/services.dart';

import 'data/enums.dart';

typedef OnSuccess<T> = Function(T response);
typedef OnFailure<T> = Function(T response);


class FlutterAdyen {
  static const MethodChannel _channel = MethodChannel('com.itsniaz.adyenterminal/channel');
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

  static Future<void> authorizeTransaction(
      {
      required double amount,
      required String transactionId,
      required String currency, CaptureType captureType =  CaptureType.delayed,
      OnSuccess<String>? onSuccess,
      OnFailure<String>? onFailure,
      }) async {

    _channel.invokeMethod(_methodAuthorizeTransaction,{
      "amount" : amount,
      "transactionId" : transactionId,
      "currency" : currency,
      "captureType" : captureType.name
    }).then((value){
      if (onSuccess != null) {
        onSuccess(value);
      }
    }).catchError((value){
      if (onFailure != null) {
        onFailure(value.details);
      }
    });

  }

  static Future<dynamic> cancelTransaction({required txnId,required cancelTxnId, required terminalId}) async {

    var result = await _channel.invokeMethod(_methodCancelTransaction,{
      "transactionId" : txnId,
      "cancelTxnId" : cancelTxnId
    });

    return result;
  }

  static Future<void> printReceipt(String txnId,String receiptDTOJSON,{OnSuccess<String>? onSuccess,
      OnFailure<String>? onFailure}) async {

    _channel.invokeMethod(_methodPrintReceipt,{
      "receiptDTOJSON" : receiptDTOJSON,
      "transactionId" : txnId
    }).then((value){
      if (onSuccess != null) {
        onSuccess("Print Successful");
      }
    }).catchError((value){
      if (onFailure != null) {
        onFailure(value.details);
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

  static Future<void> getTerminalInfo(String terminalIP, String txnId,{OnSuccess<String>? onSuccess,
    OnFailure<String>? onFailure}) async{
    _channel.invokeMethod(_methodGetDeviceInfo, {
      "transactionId" : txnId,
      "terminalIP" : terminalIP
    }).then((value){
      if (onSuccess != null) {
        onSuccess(value);
      }
    }).catchError((value){
      if (onFailure != null) {
        onFailure("Unable to retrieve terminal info");
      }
    });
  }

}
