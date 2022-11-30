import 'dart:convert';

AdyenTerminalConfig adyenTerminalConfigFromJson(String str) => AdyenTerminalConfig.fromJson(json.decode(str));
String adyenTerminalConfigToJson(AdyenTerminalConfig data) => json.encode(data.toJson());
class AdyenTerminalConfig {
  AdyenTerminalConfig({
      required this.endpoint,
      required this.merchantId,
      required this.environment,
      required this.keyId,
      required this.keyPassphrase,
      required this.merchantName,
      required this.keyVersion,});

  AdyenTerminalConfig.fromJson(dynamic json) {
    endpoint = json['endpoint'];
    merchantId = json['merchantId'];
    environment = json['environment'];
    keyId = json['key_id'];
    keyPassphrase = json['key_passphrase'];
    merchantName = json['merchant_name'];
    keyVersion = json['key_version'];
  }
  String? endpoint;
  String? merchantId;
  String? environment;
  String? keyId;
  String? keyPassphrase;
  String? merchantName;
  String? keyVersion;
AdyenTerminalConfig copyWith({  String? endpoint,
  String? merchantId,
  String? environment,
  String? keyId,
  String? keyPassphrase,
  String? merchantName,
  String? keyVersion,
}) => AdyenTerminalConfig(  endpoint: endpoint ?? this.endpoint,
  merchantId: merchantId ?? this.merchantId,
  environment: environment ?? this.environment,
  keyId: keyId ?? this.keyId,
  keyPassphrase: keyPassphrase ?? this.keyPassphrase,
  merchantName: merchantName ?? this.merchantName,
  keyVersion: keyVersion ?? this.keyVersion,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endpoint'] = endpoint;
    map['merchantId'] = merchantId;
    map['environment'] = environment;
    map['key_id'] = keyId;
    map['key_passphrase'] = keyPassphrase;
    map['merchant_name'] = merchantName;
    map['key_version'] = keyVersion;
    return map;
  }

}