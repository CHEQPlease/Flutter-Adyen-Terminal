import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:adyen_terminal_payment/adyen_terminal_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _formKey = GlobalKey<FormState>();
  final terminalIPController = TextEditingController();
  final terminalSerialNoController = TextEditingController();
  final terminalStoreIDController = TextEditingController();
  final paymentAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterAdyen.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Adyen Terminal Example'),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: terminalIPController,
                      decoration: const InputDecoration(
                          hintText: 'Ex 127.0.0.1',
                          labelText: 'Terminal IP',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: terminalSerialNoController,
                      decoration: const InputDecoration(
                          labelText: 'Serial No', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: terminalStoreIDController,
                      decoration: const InputDecoration(
                          labelText: 'Store ID', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: terminalStoreIDController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Amount', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        child: const Text("Send Terminal Request"),
                        onPressed: () {
                          String terminalIP = terminalIPController.text;
                          String terminalSerialNo = terminalIPController.text;
                          String merchantStoreID = terminalIPController.text;
                          String amount = terminalIPController.text;

                          AdyenTerminalConfig terminalConfig =
                              AdyenTerminalConfig(
                            endpoint: "https://$terminalIP",
                            merchantId: "",
                            environment: "",
                            keyId: "",
                            keyPassphrase: "",
                            merchantName: "",
                            keyVersion: "",
                          );

                          FlutterAdyen.init(terminalConfig);
                          FlutterAdyen.authorizePayment(20);
                        })
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
