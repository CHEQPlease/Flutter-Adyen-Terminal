import 'dart:convert';

class AdyenTerminalConfig {
  AdyenTerminalConfig({
    required this.endpoint,
    this.backendApiKey,
    required this.terminalModelNo,
    required this.terminalSerialNo,
    required this.terminalId,
    required this.environment,
    required this.keyId,
    required this.keyPassphrase,
    required this.keyVersion,
    required this.merchantId,
    required this.merchantName,
    required this.certPath,
    this.connectionTimeoutMillis = 30000,
    this.readTimeoutMillis = 30000,
    this.showLogs = false,
  });

  final String endpoint;
  final String? backendApiKey;
  final String terminalModelNo;
  final String terminalSerialNo;
  final String terminalId;
  final String environment;
  final String keyId;
  final String keyPassphrase;
  final String keyVersion;
  final String merchantId;
  final String merchantName;
  final String certPath;
  num? connectionTimeoutMillis = 30000;
  num? readTimeoutMillis = 30000;
  bool showLogs = false;

  AdyenTerminalConfig copyWith({
    String? endpoint,
    String? backendApiKey,
    String? terminalModelNo,
    String? terminalSerialNo,
    String? terminalId,
    String? environment,
    String? keyId,
    String? keyPassphrase,
    String? keyVersion,
    String? merchantId,
    String? merchantName,
    String? certPath,
    num? connectionTimeoutMillis,
    num? readTimeoutMillis,
    bool? showLogs,
  }) {
    return AdyenTerminalConfig(
      endpoint: endpoint ?? this.endpoint,
      backendApiKey: backendApiKey ?? this.backendApiKey,
      terminalModelNo: terminalModelNo ?? this.terminalModelNo,
      terminalSerialNo: terminalSerialNo ?? this.terminalSerialNo,
      terminalId: terminalId ?? this.terminalId,
      environment: environment ?? this.environment,
      keyId: keyId ?? this.keyId,
      keyPassphrase: keyPassphrase ?? this.keyPassphrase,
      keyVersion: keyVersion ?? this.keyVersion,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      certPath: certPath ?? this.certPath,
      connectionTimeoutMillis: connectionTimeoutMillis ?? this.connectionTimeoutMillis,
      readTimeoutMillis: readTimeoutMillis ?? this.readTimeoutMillis,
      showLogs: showLogs ?? this.showLogs,
    );
  }

  factory AdyenTerminalConfig.fromJson(Map<String, dynamic> json){
    return AdyenTerminalConfig(
      endpoint: json["endpoint"] ?? "",
      backendApiKey: json["backendApiKey"] ?? "",
      terminalModelNo: json["terminalModelNo"] ?? "",
      terminalSerialNo: json["terminalSerialNo"] ?? "",
      terminalId: json["terminalId"] ?? "",
      environment: json["environment"] ?? "",
      keyId: json["keyId"] ?? "",
      keyPassphrase: json["keyPassphrase"] ?? "",
      keyVersion: json["keyVersion"] ?? "",
      merchantId: json["merchantId"] ?? "",
      merchantName: json["merchantName"] ?? "",
      certPath: json["certPath"] ?? "",
      connectionTimeoutMillis: json["connectionTimeoutMillis"] ?? 0,
      readTimeoutMillis: json["readTimeoutMillis"] ?? 0,
      showLogs: json["showLogs"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "endpoint": endpoint,
    "backendApiKey": backendApiKey,
    "terminalModelNo": terminalModelNo,
    "terminalSerialNo": terminalSerialNo,
    "terminalId": terminalId,
    "environment": environment,
    "keyId": keyId,
    "keyPassphrase": keyPassphrase,
    "keyVersion": keyVersion,
    "merchantId": merchantId,
    "merchantName": merchantName,
    "certPath": certPath,
    "connectionTimeoutMillis": connectionTimeoutMillis,
    "readTimeoutMillis": readTimeoutMillis,
    "showLogs": showLogs,
  };

  String toRawJson() => json.encode(toJson());

  @override
  toString() => toRawJson();

}
