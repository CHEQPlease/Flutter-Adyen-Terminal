
import 'dart:async';

import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/services.dart';

import 'data/enums.dart';

class FlutterAdyen {
  static const MethodChannel _channel = MethodChannel('com.itsniaz.adyenterminal/channel');
  static const String methodInit = "init";
  static const String methodAuthorizePayment = "authorize_payment";

  static late AdyenTerminalConfig _terminalConfig;


  static void init(AdyenTerminalConfig terminalConfig){
    _terminalConfig = terminalConfig;
    _channel.invokeMethod(methodInit,terminalConfig.toJson());
  }

  static Future<dynamic> authorizePayment(double amount,{CaptureType captureType =  CaptureType.immediate}) async {

    var result = await _channel.invokeMethod(methodInit,{
      "amount" : amount,
      "captureType" : captureType.name
    });
    return result;
  }
}
