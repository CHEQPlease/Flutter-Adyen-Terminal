
import 'dart:async';

import 'package:flutter/services.dart';

class AdyenTerminalPayment {
  static const MethodChannel _channel = MethodChannel('adyen_terminal_payment');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
