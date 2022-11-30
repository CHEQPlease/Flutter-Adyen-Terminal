
import 'dart:async';

import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/services.dart';

class FlutterAdyen {
  static const MethodChannel _channel = MethodChannel('adyen_terminal_payment');

  static late AdyenTerminalConfig _terminalConfig;


  static void init(AdyenTerminalConfig terminalConfig){
    _terminalConfig = terminalConfig;
  }

  static Future<dynamic> makePayment(double amount){

    return Future.value("");
  }
}
