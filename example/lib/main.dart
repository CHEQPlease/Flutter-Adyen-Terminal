import 'dart:math';

import 'package:adyen_terminal_payment/adyen_terminal_payment.dart';
import 'package:adyen_terminal_payment/data/AdyenTerminalConfig.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final _formKey = GlobalKey<FormState>();
  final terminalIPController = TextEditingController();
  final terminalSerialNoController = TextEditingController();
  final terminalStoreIDController = TextEditingController();
  final paymentAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: const Text('Adyen Terminal Example'),
          ),
          body: Padding(
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
                  Row(
                    children: [
                      ElevatedButton(
                          child: const Text("Send Terminal Request"),
                          onPressed: () {
                            String terminalIP = terminalIPController.text;
                            String terminalSerialNo = terminalIPController.text;
                            String merchantStoreID = terminalIPController.text;
                            String amount = terminalIPController.text;

                            AdyenTerminalConfig terminalConfig =
                            AdyenTerminalConfig(
                              endpoint: "https://192.168.1.52",
                              terminalModelNo: "e285p",
                              terminalSerialNo: "805336307",
                              terminalId: "bugsoyieugrys",
                              merchantId: null,
                              environment: "test",
                              keyId: "dhaka-pos-cc-test-id",
                              keyPassphrase: "Dh@kaCheq1!",
                              merchantName: "CHEQPOS",
                              keyVersion: "1.0",
                              certPath: "assets/cert/adyen-terminalfleet-test.cer",
                            );

                            FlutterAdyen.init(terminalConfig);
                            String txnId = _get10DigitNumber();
                            FlutterAdyen.authorizeTransaction(amount: 10, transactionId: txnId, currency: "USD",onSuccess: (val){
                              print("Transaction Successful $val");
                              Navigator.of(context).pop();
                            },onFailure: (val){
                              print("Transaction Failure : $val");
                              Navigator.of(context).pop();
                            });
                            _showMaterialDialog(txnId,terminalConfig);
                          }
                          ),
                    ],
                  )
                ],
              ),
            ),
          ));
  }

  void _showMaterialDialog(String txnId,AdyenTerminalConfig terminalConfig) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Status'),
            content: Text('Transaction In Progress'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    FlutterAdyen.cancelTransaction(cancelTxnId: txnId,txnId: _get10DigitNumber(),terminalId: terminalConfig.terminalId);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }

  String _get10DigitNumber() {
    Random random = Random();
    String number = '';
    for (int i = 0; i < 10; i++) {
      number = number + random.nextInt(9).toString();
    }

    return number;
  }
}
