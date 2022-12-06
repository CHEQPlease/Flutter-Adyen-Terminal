class AdyenTerminalConfig {
  AdyenTerminalConfig({
      this.endpoint, 
      this.merchantId, 
      this.terminalModelNo, 
      this.terminalSerialNo, 
      this.terminalId, 
      this.environment, 
      this.keyId, 
      this.keyPassphrase, 
      this.merchantName, 
      this.keyVersion, 
      this.certPath,});

  AdyenTerminalConfig.fromJson(dynamic json) {
    endpoint = json['endpoint'];
    merchantId = json['merchantId'];
    terminalModelNo = json['terminalModelNo'];
    terminalSerialNo = json['terminalSerialNo'];
    terminalId = json['terminalId'];
    environment = json['environment'];
    keyId = json['key_id'];
    keyPassphrase = json['key_passphrase'];
    merchantName = json['merchant_name'];
    keyVersion = json['key_version'];
    certPath = json['certPath'];
  }
  String endpoint;
  String merchantId;
  String terminalModelNo;
  String terminalSerialNo;
  String terminalId;
  String environment;
  String keyId;
  String keyPassphrase;
  String merchantName;
  String keyVersion;
  String certPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endpoint'] = endpoint;
    map['merchantId'] = merchantId;
    map['terminalModelNo'] = terminalModelNo;
    map['terminalSerialNo'] = terminalSerialNo;
    map['terminalId'] = terminalId;
    map['environment'] = environment;
    map['key_id'] = keyId;
    map['key_passphrase'] = keyPassphrase;
    map['merchant_name'] = merchantName;
    map['key_version'] = keyVersion;
    map['certPath'] = certPath;
    return map;
  }

}