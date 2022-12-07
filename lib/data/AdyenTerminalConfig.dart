class AdyenTerminalConfig {

  AdyenTerminalConfig({
      required this.endpoint,
      required this.merchantId,
      required this.terminalModelNo,
      required this.terminalSerialNo,
      required this.terminalId,
      required this.environment,
      required this.keyId,
      required this.keyPassphrase,
      required this.merchantName,
      required this.keyVersion,
      required this.certPath,
  });

  AdyenTerminalConfig.fromJson(dynamic json) {
    endpoint = json['endpoint'];
    merchantId = json['merchant_id'];
    terminalModelNo = json['terminal_model_no'];
    terminalSerialNo = json['terminal_serial_no'];
    terminalId = json['terminal_id'];
    environment = json['environment'];
    keyId = json['key_id'];
    keyPassphrase = json['key_passphrase'];
    merchantName = json['merchant_name'];
    keyVersion = json['key_version'];
    certPath = json['cert_path'];
  }

  String? endpoint;
  String? merchantId;
  String? terminalModelNo;
  String? terminalSerialNo;
  String? terminalId;
  String? environment;
  String? keyId;
  String? keyPassphrase;
  String? merchantName;
  String? keyVersion;
  String? certPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endpoint'] = endpoint;
    map['merchant_id'] = merchantId;
    map['terminal_model_no'] = terminalModelNo;
    map['terminal_serial_no'] = terminalSerialNo;
    map['terminal_id'] = terminalId;
    map['environment'] = environment;
    map['key_id'] = keyId;
    map['key_passphrase'] = keyPassphrase;
    map['merchant_name'] = merchantName;
    map['key_version'] = keyVersion;
    map['cert_path'] = certPath;
    return map;
  }

}