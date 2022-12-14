import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adyen_terminal_payment/adyen_terminal_payment.dart';

void main() {
  const MethodChannel channel = MethodChannel('adyen_terminal_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterAdyen.platformVersion, '42');
  });
}
