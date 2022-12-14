## **ADYEN FLUTTER PLUGIN FOR PAYMENT TERMINALS**

**Init the plugin with required params**

    AdyenTerminalConfig terminalConfig =  AdyenTerminalConfig(  
      // ex:https://192.168.1.68  
      endpoint: "", 
      
      // ex: V400cPlus
      terminalModelNo: "",
      
      // ex 498494  
      terminalSerialNo: "",
      
      /User-definedd unique identifier for payment terminal
      terminalId: "", 
      
      merchantId: null,
      //test/live 
      environment: "test", 
       
      // Security Key id. Ex : dhaka-pos-cc-test-id  
      keyId: "", 
      
      // Security KeyPassphrase
      keyPassphrase: "",  
      
      merchantName: "CHEQPOS",  
      
      keyVersion: "1.0",
    
      //Path to your HTTPS certificate   
      certPath: "assets/cert/adyen-terminalfleet-test.cer",  
    );  
    
    FlutterAdyen.init(terminalConfig);



**Perform a transaction**

      FlutterAdyen.authorizeTransaction(  
      amount: 10,  
      transactionId: "",  // your 10 digit unique alphanum id for this transaction
      currency: "USD",  
      onSuccess: (val) {  
       // Handle Successful Transaction Here 
      },  
      onFailure: (val) {  
       // Handle Failed Transaction Here
      });


**Cancel A In Progress Transaction**

    FlutterAdyen.cancelTransaction(  
        cancelTxnId: "", // Transaction id of in-progress transaction 
        txnId: "",  // Unique id of this cancel request trabsaction
        terminalId: // Unique identifer of the terminal that produced the transaction
        );

