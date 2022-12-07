
import 'dart:async';

import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/services.dart';

import 'data/enums.dart';

typedef OnSuccess<T> = Function(T response);
typedef OnFailure<T> = Function(T response);


class FlutterAdyen {
  static const MethodChannel _channel = MethodChannel('com.itsniaz.adyenterminal/channel');
  static const String methodInit = "init";
  static const String methodAuthorizeTransaction = "authorize_transaction";
  static const String methodCancelTransaction = "cancel_transaction";

  static late AdyenTerminalConfig _terminalConfig;

  static void init(AdyenTerminalConfig terminalConfig){
    _terminalConfig = terminalConfig;
    _channel.invokeMethod(methodInit,_terminalConfig.toJson());
  }

  static Future<void> authorizeTransaction(
      {
      required double amount,
      required String transactionId,
      required String currency, CaptureType captureType =  CaptureType.delayed,
      OnSuccess<String>? onSuccess,
      OnFailure<String>? onFailure,
      }) async {

    _channel.invokeMethod(methodAuthorizeTransaction,{
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

    var result = await _channel.invokeMethod(methodCancelTransaction,{
      "transactionId" : txnId,
      "cancelTxnId" : cancelTxnId
    });

    return result;
  }

}
