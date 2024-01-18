import 'dart:convert';

class AdyenTerminalResponse {
  SaleToPoiResponse? saleToPoiResponse;

  AdyenTerminalResponse({
    this.saleToPoiResponse,
  });

  AdyenTerminalResponse copyWith({
    SaleToPoiResponse? saleToPoiResponse,
  }) =>
      AdyenTerminalResponse(
        saleToPoiResponse: saleToPoiResponse ?? this.saleToPoiResponse,
      );

  factory AdyenTerminalResponse.fromRawJson(String str) =>
      AdyenTerminalResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdyenTerminalResponse.fromJson(Map<String, dynamic> json) =>
      AdyenTerminalResponse(
        saleToPoiResponse: json["SaleToPOIResponse"] == null
            ? null
            : SaleToPoiResponse.fromJson(json["SaleToPOIResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "SaleToPOIResponse": saleToPoiResponse?.toJson(),
      };
}

class SaleToPoiResponse {
  MessageHeader? messageHeader;
  PaymentResponse? paymentResponse;

  SaleToPoiResponse({
    this.messageHeader,
    this.paymentResponse,
  });

  SaleToPoiResponse copyWith({
    MessageHeader? messageHeader,
    PaymentResponse? paymentResponse,
  }) =>
      SaleToPoiResponse(
        messageHeader: messageHeader ?? this.messageHeader,
        paymentResponse: paymentResponse ?? this.paymentResponse,
      );

  factory SaleToPoiResponse.fromRawJson(String str) =>
      SaleToPoiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleToPoiResponse.fromJson(Map<String, dynamic> json) =>
      SaleToPoiResponse(
        messageHeader: json["messageHeader"] == null
            ? null
            : MessageHeader.fromJson(json["messageHeader"]),
        paymentResponse: json["paymentResponse"] == null
            ? null
            : PaymentResponse.fromJson(json["paymentResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "messageHeader": messageHeader?.toJson(),
        "paymentResponse": paymentResponse?.toJson(),
      };
}

class MessageHeader {
  String? messageCategory;
  String? messageClass;
  String? messageType;
  String? poiid;
  String? protocolVersion;
  String? saleId;
  String? serviceId;

  MessageHeader({
    this.messageCategory,
    this.messageClass,
    this.messageType,
    this.poiid,
    this.protocolVersion,
    this.saleId,
    this.serviceId,
  });

  MessageHeader copyWith({
    String? messageCategory,
    String? messageClass,
    String? messageType,
    String? poiid,
    String? protocolVersion,
    String? saleId,
    String? serviceId,
  }) =>
      MessageHeader(
        messageCategory: messageCategory ?? this.messageCategory,
        messageClass: messageClass ?? this.messageClass,
        messageType: messageType ?? this.messageType,
        poiid: poiid ?? this.poiid,
        protocolVersion: protocolVersion ?? this.protocolVersion,
        saleId: saleId ?? this.saleId,
        serviceId: serviceId ?? this.serviceId,
      );

  factory MessageHeader.fromRawJson(String str) =>
      MessageHeader.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageHeader.fromJson(Map<String, dynamic> json) => MessageHeader(
        messageCategory: json["messageCategory"],
        messageClass: json["messageClass"],
        messageType: json["messageType"],
        poiid: json["poiid"],
        protocolVersion: json["protocolVersion"],
        saleId: json["saleID"],
        serviceId: json["serviceID"],
      );

  Map<String, dynamic> toJson() => {
        "messageCategory": messageCategory,
        "messageClass": messageClass,
        "messageType": messageType,
        "poiid": poiid,
        "protocolVersion": protocolVersion,
        "saleID": saleId,
        "serviceID": serviceId,
      };
}

class PaymentResponse {
  PaymentResult? paymentResult;
  PoiData? poiData;
  Response? response;
  SaleData? saleData;

  PaymentResponse({
    this.paymentResult,
    this.poiData,
    this.response,
    this.saleData,
  });

  PaymentResponse copyWith({
    PaymentResult? paymentResult,
    PoiData? poiData,
    Response? response,
    SaleData? saleData,
  }) =>
      PaymentResponse(
        paymentResult: paymentResult ?? this.paymentResult,
        poiData: poiData ?? this.poiData,
        response: response ?? this.response,
        saleData: saleData ?? this.saleData,
      );

  factory PaymentResponse.fromRawJson(String str) =>
      PaymentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        paymentResult: json["paymentResult"] == null
            ? null
            : PaymentResult.fromJson(json["paymentResult"]),
        poiData:
            json["poiData"] == null ? null : PoiData.fromJson(json["poiData"]),
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
        saleData: json["saleData"] == null
            ? null
            : SaleData.fromJson(json["saleData"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentResult": paymentResult?.toJson(),
        "poiData": poiData?.toJson(),
        "response": response?.toJson(),
        "saleData": saleData?.toJson(),
      };
}

class PaymentResult {
  AmountsResp? amountsResp;
  bool? onlineFlag;
  PaymentAcquirerData? paymentAcquirerData;
  PaymentInstrumentData? paymentInstrumentData;

  PaymentResult({
    this.amountsResp,
    this.onlineFlag,
    this.paymentAcquirerData,
    this.paymentInstrumentData,
  });

  PaymentResult copyWith({
    AmountsResp? amountsResp,
    bool? onlineFlag,
    PaymentAcquirerData? paymentAcquirerData,
    PaymentInstrumentData? paymentInstrumentData,
  }) =>
      PaymentResult(
        amountsResp: amountsResp ?? this.amountsResp,
        onlineFlag: onlineFlag ?? this.onlineFlag,
        paymentAcquirerData: paymentAcquirerData ?? this.paymentAcquirerData,
        paymentInstrumentData:
            paymentInstrumentData ?? this.paymentInstrumentData,
      );

  factory PaymentResult.fromRawJson(String str) =>
      PaymentResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentResult.fromJson(Map<String, dynamic> json) => PaymentResult(
        amountsResp: json["amountsResp"] == null
            ? null
            : AmountsResp.fromJson(json["amountsResp"]),
        onlineFlag: json["onlineFlag"],
        paymentAcquirerData: json["paymentAcquirerData"] == null
            ? null
            : PaymentAcquirerData.fromJson(json["paymentAcquirerData"]),
        paymentInstrumentData: json["paymentInstrumentData"] == null
            ? null
            : PaymentInstrumentData.fromJson(json["paymentInstrumentData"]),
      );

  Map<String, dynamic> toJson() => {
        "amountsResp": amountsResp?.toJson(),
        "onlineFlag": onlineFlag,
        "paymentAcquirerData": paymentAcquirerData?.toJson(),
        "paymentInstrumentData": paymentInstrumentData?.toJson(),
      };
}

class AmountsResp {
  double? authorizedAmount;
  String? currency;

  AmountsResp({
    this.authorizedAmount,
    this.currency,
  });

  AmountsResp copyWith({
    double? authorizedAmount,
    String? currency,
  }) =>
      AmountsResp(
        authorizedAmount: authorizedAmount ?? this.authorizedAmount,
        currency: currency ?? this.currency,
      );

  factory AmountsResp.fromRawJson(String str) =>
      AmountsResp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmountsResp.fromJson(Map<String, dynamic> json) => AmountsResp(
        authorizedAmount: json["authorizedAmount"]?.toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "authorizedAmount": authorizedAmount,
        "currency": currency,
      };
}

class PaymentAcquirerData {
  String? acquirerPoiid;
  TransactionId? acquirerTransactionId;
  String? approvalCode;
  String? merchantId;

  PaymentAcquirerData({
    this.acquirerPoiid,
    this.acquirerTransactionId,
    this.approvalCode,
    this.merchantId,
  });

  PaymentAcquirerData copyWith({
    String? acquirerPoiid,
    TransactionId? acquirerTransactionId,
    String? approvalCode,
    String? merchantId,
  }) =>
      PaymentAcquirerData(
        acquirerPoiid: acquirerPoiid ?? this.acquirerPoiid,
        acquirerTransactionId:
            acquirerTransactionId ?? this.acquirerTransactionId,
        approvalCode: approvalCode ?? this.approvalCode,
        merchantId: merchantId ?? this.merchantId,
      );

  factory PaymentAcquirerData.fromRawJson(String str) =>
      PaymentAcquirerData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentAcquirerData.fromJson(Map<String, dynamic> json) =>
      PaymentAcquirerData(
        acquirerPoiid: json["acquirerPOIID"],
        acquirerTransactionId: json["acquirerTransactionID"] == null
            ? null
            : TransactionId.fromJson(json["acquirerTransactionID"]),
        approvalCode: json["approvalCode"],
        merchantId: json["merchantID"],
      );

  Map<String, dynamic> toJson() => {
        "acquirerPOIID": acquirerPoiid,
        "acquirerTransactionID": acquirerTransactionId?.toJson(),
        "approvalCode": approvalCode,
        "merchantID": merchantId,
      };
}

class TransactionId {
  Map<String, double>? timeStamp;
  String? transactionId;

  TransactionId({
    this.timeStamp,
    this.transactionId,
  });

  TransactionId copyWith({
    Map<String, double>? timeStamp,
    String? transactionId,
  }) =>
      TransactionId(
        timeStamp: timeStamp ?? this.timeStamp,
        transactionId: transactionId ?? this.transactionId,
      );

  factory TransactionId.fromRawJson(String str) =>
      TransactionId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionId.fromJson(Map<String, dynamic> json) => TransactionId(
        timeStamp: Map.from(json["timeStamp"]!)
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        transactionId: json["transactionID"],
      );

  Map<String, dynamic> toJson() => {
        "timeStamp":
            Map.from(timeStamp!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "transactionID": transactionId,
      };
}

class PaymentInstrumentData {
  CardData? cardData;
  String? paymentInstrumentType;

  PaymentInstrumentData({
    this.cardData,
    this.paymentInstrumentType,
  });

  PaymentInstrumentData copyWith({
    CardData? cardData,
    String? paymentInstrumentType,
  }) =>
      PaymentInstrumentData(
        cardData: cardData ?? this.cardData,
        paymentInstrumentType:
            paymentInstrumentType ?? this.paymentInstrumentType,
      );

  factory PaymentInstrumentData.fromRawJson(String str) =>
      PaymentInstrumentData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentInstrumentData.fromJson(Map<String, dynamic> json) =>
      PaymentInstrumentData(
        cardData: json["cardData"] == null
            ? null
            : CardData.fromJson(json["cardData"]),
        paymentInstrumentType: json["paymentInstrumentType"],
      );

  Map<String, dynamic> toJson() => {
        "cardData": cardData?.toJson(),
        "paymentInstrumentType": paymentInstrumentType,
      };
}

class CardData {
  String? cardCountryCode;
  List<String>? entryMode;
  String? maskedPan;
  String? paymentBrand;
  SensitiveCardData? sensitiveCardData;

  CardData({
    this.cardCountryCode,
    this.entryMode,
    this.maskedPan,
    this.paymentBrand,
    this.sensitiveCardData,
  });

  CardData copyWith({
    String? cardCountryCode,
    List<String>? entryMode,
    String? maskedPan,
    String? paymentBrand,
    SensitiveCardData? sensitiveCardData,
  }) =>
      CardData(
        cardCountryCode: cardCountryCode ?? this.cardCountryCode,
        entryMode: entryMode ?? this.entryMode,
        maskedPan: maskedPan ?? this.maskedPan,
        paymentBrand: paymentBrand ?? this.paymentBrand,
        sensitiveCardData: sensitiveCardData ?? this.sensitiveCardData,
      );

  factory CardData.fromRawJson(String str) =>
      CardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
        cardCountryCode: json["cardCountryCode"],
        entryMode: json["entryMode"] == null
            ? []
            : List<String>.from(json["entryMode"]!.map((x) => x)),
        maskedPan: json["maskedPAN"],
        paymentBrand: json["paymentBrand"],
        sensitiveCardData: json["sensitiveCardData"] == null
            ? null
            : SensitiveCardData.fromJson(json["sensitiveCardData"]),
      );

  Map<String, dynamic> toJson() => {
        "cardCountryCode": cardCountryCode,
        "entryMode": entryMode == null
            ? []
            : List<dynamic>.from(entryMode!.map((x) => x)),
        "maskedPAN": maskedPan,
        "paymentBrand": paymentBrand,
        "sensitiveCardData": sensitiveCardData?.toJson(),
      };
}

class SensitiveCardData {
  String? cardSeqNumb;
  String? expiryDate;

  SensitiveCardData({
    this.cardSeqNumb,
    this.expiryDate,
  });

  SensitiveCardData copyWith({
    String? cardSeqNumb,
    String? expiryDate,
  }) =>
      SensitiveCardData(
        cardSeqNumb: cardSeqNumb ?? this.cardSeqNumb,
        expiryDate: expiryDate ?? this.expiryDate,
      );

  factory SensitiveCardData.fromRawJson(String str) =>
      SensitiveCardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SensitiveCardData.fromJson(Map<String, dynamic> json) =>
      SensitiveCardData(
        cardSeqNumb: json["cardSeqNumb"],
        expiryDate: json["expiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "cardSeqNumb": cardSeqNumb,
        "expiryDate": expiryDate,
      };
}

class PoiData {
  String? poiReconciliationId;
  TransactionId? poiTransactionId;

  PoiData({
    this.poiReconciliationId,
    this.poiTransactionId,
  });

  PoiData copyWith({
    String? poiReconciliationId,
    TransactionId? poiTransactionId,
  }) =>
      PoiData(
        poiReconciliationId: poiReconciliationId ?? this.poiReconciliationId,
        poiTransactionId: poiTransactionId ?? this.poiTransactionId,
      );

  factory PoiData.fromRawJson(String str) => PoiData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PoiData.fromJson(Map<String, dynamic> json) => PoiData(
        poiReconciliationId: json["poiReconciliationID"],
        poiTransactionId: json["poiTransactionID"] == null
            ? null
            : TransactionId.fromJson(json["poiTransactionID"]),
      );

  Map<String, dynamic> toJson() => {
        "poiReconciliationID": poiReconciliationId,
        "poiTransactionID": poiTransactionId?.toJson(),
      };
}

class Response {
  AdditionalResponse? additionalResponse;
  String? errorCondition;
  String? result;

  Response({
    this.additionalResponse,
    this.errorCondition,
    this.result,
  });

  Response copyWith({
    AdditionalResponse? additionalResponse,
    String? errorCondition,
    String? result,
  }) =>
      Response(
        additionalResponse: additionalResponse ?? this.additionalResponse,
        errorCondition: errorCondition ?? this.errorCondition,
        result: result ?? this.result,
      );

  factory Response.fromRawJson(String str) =>
      Response.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Response.fromJson(Map<String, dynamic> json) {
    String? additionalResponse = json["additionalResponse"];
    String? additionalResponseDecoded;
    if (additionalResponse != null) {
      try {
        additionalResponseDecoded =
            utf8.decode(base64Decode(additionalResponse));
      } catch (ignored) {
        additionalResponseDecoded = null;
      }
    }

    return Response(
      additionalResponse: additionalResponseDecoded == null
          ? null
          : AdditionalResponse.fromRawJson(additionalResponseDecoded),
      errorCondition: json["errorCondition"],
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
        "additionalResponse": additionalResponse?.toJson(),
        "errorCondition": errorCondition,
        "result": result,
      };
}

class AdditionalResponse {
  Map<String, dynamic>? additionalData;
  String? message;
  String? refusalReason;
  String? store;

  AdditionalResponse({
    this.additionalData,
    this.message,
    this.refusalReason,
    this.store,
  });

  AdditionalResponse copyWith({
    Map<String, dynamic>? additionalData,
    String? message,
    String? refusalReason,
    String? store,
  }) =>
      AdditionalResponse(
        additionalData: additionalData ?? this.additionalData,
        message: message ?? this.message,
        refusalReason: refusalReason ?? this.refusalReason,
        store: store ?? this.store,
      );

  factory AdditionalResponse.fromRawJson(String str) =>
      AdditionalResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdditionalResponse.fromJson(Map<String, dynamic> json) =>
      AdditionalResponse(
        additionalData: json.containsKey("additionalData")
            ? Map.from(json["additionalData"]!)
                .map((k, v) => MapEntry<String, String>(k, v))
            : null,
        message: json["message"],
        refusalReason:
            json.containsKey("refusalReason") ? json["refusalReason"] : null,
        store: json["store"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      "message": message,
      "store": store,
    };

    if (additionalData != null && additionalData!.isNotEmpty) {
      jsonMap["additionalData"] = Map.from(additionalData!)
          .map((k, v) => MapEntry<String, dynamic>(k, v));
    }

    if (refusalReason != null) {
      jsonMap["refusalReason"] = refusalReason;
    }

    return jsonMap;
  }
}

class SaleData {
  String? saleToAcquirerData;
  TransactionId? saleTransactionId;

  SaleData({
    this.saleToAcquirerData,
    this.saleTransactionId,
  });

  SaleData copyWith({
    String? saleToAcquirerData,
    TransactionId? saleTransactionId,
  }) =>
      SaleData(
        saleToAcquirerData: saleToAcquirerData ?? this.saleToAcquirerData,
        saleTransactionId: saleTransactionId ?? this.saleTransactionId,
      );

  factory SaleData.fromRawJson(String str) =>
      SaleData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleData.fromJson(Map<String, dynamic> json) => SaleData(
        saleToAcquirerData: json["saleToAcquirerData"],
        saleTransactionId: json["saleTransactionID"] == null
            ? null
            : TransactionId.fromJson(json["saleTransactionID"]),
      );

  Map<String, dynamic> toJson() => {
        "saleToAcquirerData": saleToAcquirerData,
        "saleTransactionID": saleTransactionId?.toJson(),
      };
}
