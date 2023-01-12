
import 'dart:async';
import 'dart:typed_data';

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
      onSuccess!(value);
    }).catchError((value){
      onFailure!(value.details);
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
      onSuccess!("Print Successful");
    }).catchError((value){
      onFailure!(value.details);
    });
  }

  static Future<void> scanBarcode(String txnId) async {

    _channel.invokeMethod(_methodScanBarcode,{
      "transactionId" : txnId
    }).then((value){

    }).catchError((value){

    });
  }

}
