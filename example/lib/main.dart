import 'dart:math';
import 'dart:typed_data';

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

                  // Image.asset("assets/t1.png"),

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
                          onPressed: () async {
                            
                            
                            AdyenTerminalConfig terminalConfig =
                            AdyenTerminalConfig(
                              endpoint: "https://192.168.31.158",
                              terminalModelNo: "S1F2",
                              terminalSerialNo: "000158222016383",
                              terminalId: "bugsoyieugrys",
                              merchantId: null,
                              environment: "test",
                              keyId: "dhaka-pos-cc-test-id",
                              keyPassphrase: "Dh@kaCheq1!",
                              merchantName: "CHEQPOS",
                              keyVersion: "1.0",
                              certPath: "assets/cert/adyen-terminalfleet-test.cer",
                            );
                            //


                            FlutterAdyen.init(terminalConfig);
                            String receiptDTOJSON =
                            """
                           
{
  "brandName": "CHEQ Diner1",
  "orderType": "Self-Order",
  "orderSubtitle": "Kiosk-Order",
  "totalItems": "2",
  "orderNo": "K10",
  "tableNo": "234",
  "receiptType": "kiosk",
  "timeOfOrder": "Placed at : 01/12/2023 03:57 AM AKST",
  "items": [
    {
      "itemName": "Salmon Fry",
      "description": "  -- Olive\n  -- Deep Fried Salmon\n  -- ADD Addition 1\n  -- no Nuts\n  -- no Olive Oil\n  -- Substitution 1 SUB\n  -- allergy 1 ALLERGY\n",
      "quantity": "1",
      "price": "\$10.0",
      "strikethrough": false
    },
    {
      "itemName": "Water + Apple Pay",
      "description": "  -- Onions\n",
      "quantity": "1",
      "price": "\$1.0",
      "strikethrough": true
    }
  ],
  "breakdown": [
    {
      "key": "Payment Type",
      "value": "Card",
      "important": null
    },
    {
      "key": "Card Type",
      "value": "mc",
      "important": null
    },
    {
      "key": "Card #:",
      "value": "541333 **** 9999",
      "important": null
    },
    {
      "key": "Card Entry",
      "value": "CONTACTLESS",
      "important": null
    },
    {
      "key": "",
      "value": "",
      "important": null
    },
    {
      "key": "Sub Total",
      "value": "\$21.01",
      "important": null
    },
    {
      "key": "Area Tax",
      "value": "\$1.00",
      "important": null
    },
    {
      "key": "VAT",
      "value": "\$2.10",
      "important": null
    },
    {
      "key": "Customer Fee",
      "value": "\$0.63",
      "important": null
    },
    {
      "key": "Service Fee",
      "value": "\$0.91",
      "important": null
    },
    {
      "key": "Tax",
      "value": "\$0.01",
      "important": null
    },
    {
      "key": "GRAND TOTAL",
      "value": "\$25.66",
      "important": true
    }
  ]
}
                            
                            """
                            ;
                            FlutterAdyen.printReceipt(_get10DigitNumber(),receiptDTOJSON, onSuccess: (String val){
                              print("Print Sucessful");
                            }, onFailure: (String errorMsg){
                               print("Print failure : $errorMsg");
                            });

                            // String txnId = _get10DigitNumber();
                            // FlutterAdyen.authorizeTransaction(
                            //   amount: 10,
                            //   transactionId: txnId,
                            //   currency: "USD",
                            //   onSuccess: (val) {
                            //     print("Transaction Successful $val");
                            //     Navigator.of(context).pop();
                            //   },
                            //   onFailure: (val) {
                            //     print("Transaction Failure : $val");
                            //     Navigator.of(context).pop();
                            //   });
                          // _showMaterialDialog(txnId, terminalConfig);
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
                    FlutterAdyen.cancelTransaction(
                        cancelTxnId: txnId,
                        txnId: _get10DigitNumber(),
                        terminalId: terminalConfig.terminalId);
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
