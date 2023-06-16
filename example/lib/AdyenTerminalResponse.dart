class AdyenTerminalResponse {
  AdyenTerminalResponse({
    required this.saleToPoiResponse,
  });

  final SaleToPoiResponse? saleToPoiResponse;

  AdyenTerminalResponse copyWith({
    SaleToPoiResponse? saleToPoiResponse,
  }) {
    return AdyenTerminalResponse(
      saleToPoiResponse: saleToPoiResponse ?? this.saleToPoiResponse,
    );
  }

  factory AdyenTerminalResponse.fromJson(Map<String, dynamic> json){
    return AdyenTerminalResponse(
      saleToPoiResponse: json["SaleToPOIResponse"] == null ? null : SaleToPoiResponse.fromJson(json["SaleToPOIResponse"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "SaleToPOIResponse": saleToPoiResponse?.toJson(),
  };

  @override
  String toString(){
    return "$saleToPoiResponse, ";
  }

}

class SaleToPoiResponse {
  SaleToPoiResponse({
    required this.messageHeader,
    required this.paymentResponse,
  });

  final MessageHeader? messageHeader;
  final PaymentResponse? paymentResponse;

  SaleToPoiResponse copyWith({
    MessageHeader? messageHeader,
    PaymentResponse? paymentResponse,
  }) {
    return SaleToPoiResponse(
      messageHeader: messageHeader ?? this.messageHeader,
      paymentResponse: paymentResponse ?? this.paymentResponse,
    );
  }

  factory SaleToPoiResponse.fromJson(Map<String, dynamic> json){
    return SaleToPoiResponse(
      messageHeader: json["messageHeader"] == null ? null : MessageHeader.fromJson(json["messageHeader"]),
      paymentResponse: json["paymentResponse"] == null ? null : PaymentResponse.fromJson(json["paymentResponse"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "messageHeader": messageHeader?.toJson(),
    "paymentResponse": paymentResponse?.toJson(),
  };

  @override
  String toString(){
    return "$messageHeader, $paymentResponse, ";
  }

}

class MessageHeader {
  MessageHeader({
    required this.messageCategory,
    required this.messageClass,
    required this.messageType,
    required this.poiid,
    required this.protocolVersion,
    required this.saleId,
    required this.serviceId,
  });

  final String messageCategory;
  final String messageClass;
  final String messageType;
  final String poiid;
  final String protocolVersion;
  final String saleId;
  final String serviceId;

  MessageHeader copyWith({
    String? messageCategory,
    String? messageClass,
    String? messageType,
    String? poiid,
    String? protocolVersion,
    String? saleId,
    String? serviceId,
  }) {
    return MessageHeader(
      messageCategory: messageCategory ?? this.messageCategory,
      messageClass: messageClass ?? this.messageClass,
      messageType: messageType ?? this.messageType,
      poiid: poiid ?? this.poiid,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      saleId: saleId ?? this.saleId,
      serviceId: serviceId ?? this.serviceId,
    );
  }

  factory MessageHeader.fromJson(Map<String, dynamic> json){
    return MessageHeader(
      messageCategory: json["messageCategory"] ?? "",
      messageClass: json["messageClass"] ?? "",
      messageType: json["messageType"] ?? "",
      poiid: json["poiid"] ?? "",
      protocolVersion: json["protocolVersion"] ?? "",
      saleId: json["saleID"] ?? "",
      serviceId: json["serviceID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "messageCategory": messageCategory,
    "messageClass": messageClass,
    "messageType": messageType,
    "poiid": poiid,
    "protocolVersion": protocolVersion,
    "saleID": saleId,
    "serviceID": serviceId,
  };

  @override
  String toString(){
    return "$messageCategory, $messageClass, $messageType, $poiid, $protocolVersion, $saleId, $serviceId, ";
  }

}

class PaymentResponse {
  PaymentResponse({
    required this.paymentResult,
    required this.poiData,
    required this.response,
    required this.saleData,
  });

  final PaymentResult? paymentResult;
  final PoiData? poiData;
  final Response? response;
  final SaleData? saleData;

  PaymentResponse copyWith({
    PaymentResult? paymentResult,
    PoiData? poiData,
    Response? response,
    SaleData? saleData,
  }) {
    return PaymentResponse(
      paymentResult: paymentResult ?? this.paymentResult,
      poiData: poiData ?? this.poiData,
      response: response ?? this.response,
      saleData: saleData ?? this.saleData,
    );
  }

  factory PaymentResponse.fromJson(Map<String, dynamic> json){
    return PaymentResponse(
      paymentResult: json["paymentResult"] == null ? null : PaymentResult.fromJson(json["paymentResult"]),
      poiData: json["poiData"] == null ? null : PoiData.fromJson(json["poiData"]),
      response: json["response"] == null ? null : Response.fromJson(json["response"]),
      saleData: json["saleData"] == null ? null : SaleData.fromJson(json["saleData"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "paymentResult": paymentResult?.toJson(),
    "poiData": poiData?.toJson(),
    "response": response?.toJson(),
    "saleData": saleData?.toJson(),
  };

  @override
  String toString(){
    return "$paymentResult, $poiData, $response, $saleData, ";
  }

}

class PaymentResult {
  PaymentResult({
    required this.amountsResp,
    required this.onlineFlag,
    required this.paymentAcquirerData,
    required this.paymentInstrumentData,
  });

  final AmountsResp? amountsResp;
  final bool onlineFlag;
  final PaymentAcquirerData? paymentAcquirerData;
  final PaymentInstrumentData? paymentInstrumentData;

  PaymentResult copyWith({
    AmountsResp? amountsResp,
    bool? onlineFlag,
    PaymentAcquirerData? paymentAcquirerData,
    PaymentInstrumentData? paymentInstrumentData,
  }) {
    return PaymentResult(
      amountsResp: amountsResp ?? this.amountsResp,
      onlineFlag: onlineFlag ?? this.onlineFlag,
      paymentAcquirerData: paymentAcquirerData ?? this.paymentAcquirerData,
      paymentInstrumentData: paymentInstrumentData ?? this.paymentInstrumentData,
    );
  }

  factory PaymentResult.fromJson(Map<String, dynamic> json){
    return PaymentResult(
      amountsResp: json["amountsResp"] == null ? null : AmountsResp.fromJson(json["amountsResp"]),
      onlineFlag: json["onlineFlag"] ?? false,
      paymentAcquirerData: json["paymentAcquirerData"] == null ? null : PaymentAcquirerData.fromJson(json["paymentAcquirerData"]),
      paymentInstrumentData: json["paymentInstrumentData"] == null ? null : PaymentInstrumentData.fromJson(json["paymentInstrumentData"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "amountsResp": amountsResp?.toJson(),
    "onlineFlag": onlineFlag,
    "paymentAcquirerData": paymentAcquirerData?.toJson(),
    "paymentInstrumentData": paymentInstrumentData?.toJson(),
  };

  @override
  String toString(){
    return "$amountsResp, $onlineFlag, $paymentAcquirerData, $paymentInstrumentData, ";
  }

}

class AmountsResp {
  AmountsResp({
    required this.authorizedAmount,
    required this.currency,
  });

  final num authorizedAmount;
  final String currency;

  AmountsResp copyWith({
    num? authorizedAmount,
    String? currency,
  }) {
    return AmountsResp(
      authorizedAmount: authorizedAmount ?? this.authorizedAmount,
      currency: currency ?? this.currency,
    );
  }

  factory AmountsResp.fromJson(Map<String, dynamic> json){
    return AmountsResp(
      authorizedAmount: json["authorizedAmount"] ?? 0,
      currency: json["currency"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "authorizedAmount": authorizedAmount,
    "currency": currency,
  };

  @override
  String toString(){
    return "$authorizedAmount, $currency, ";
  }

}

class PaymentAcquirerData {
  PaymentAcquirerData({
    required this.acquirerPoiid,
    required this.acquirerTransactionId,
    required this.approvalCode,
    required this.merchantId,
  });

  final String acquirerPoiid;
  final TransactionId? acquirerTransactionId;
  final String approvalCode;
  final String merchantId;

  PaymentAcquirerData copyWith({
    String? acquirerPoiid,
    TransactionId? acquirerTransactionId,
    String? approvalCode,
    String? merchantId,
  }) {
    return PaymentAcquirerData(
      acquirerPoiid: acquirerPoiid ?? this.acquirerPoiid,
      acquirerTransactionId: acquirerTransactionId ?? this.acquirerTransactionId,
      approvalCode: approvalCode ?? this.approvalCode,
      merchantId: merchantId ?? this.merchantId,
    );
  }

  factory PaymentAcquirerData.fromJson(Map<String, dynamic> json){
    return PaymentAcquirerData(
      acquirerPoiid: json["acquirerPOIID"] ?? "",
      acquirerTransactionId: json["acquirerTransactionID"] == null ? null : TransactionId.fromJson(json["acquirerTransactionID"]),
      approvalCode: json["approvalCode"] ?? "",
      merchantId: json["merchantID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "acquirerPOIID": acquirerPoiid,
    "acquirerTransactionID": acquirerTransactionId?.toJson(),
    "approvalCode": approvalCode,
    "merchantID": merchantId,
  };

  @override
  String toString(){
    return "$acquirerPoiid, $acquirerTransactionId, $approvalCode, $merchantId, ";
  }

}

class TransactionId {
  TransactionId({
    required this.timeStamp,
    required this.transactionId,
  });

  final num timeStamp;
  final String transactionId;

  TransactionId copyWith({
    num? timeStamp,
    String? transactionId,
  }) {
    return TransactionId(
      timeStamp: timeStamp ?? this.timeStamp,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  factory TransactionId.fromJson(Map<String, dynamic> json){
    return TransactionId(
      timeStamp: json["timeStamp"] ?? 0,
      transactionId: json["transactionID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "timeStamp": timeStamp,
    "transactionID": transactionId,
  };

  @override
  String toString(){
    return "$timeStamp, $transactionId, ";
  }

}

class PaymentInstrumentData {
  PaymentInstrumentData({
    required this.cardData,
    required this.paymentInstrumentType,
  });

  final CardData? cardData;
  final String paymentInstrumentType;

  PaymentInstrumentData copyWith({
    CardData? cardData,
    String? paymentInstrumentType,
  }) {
    return PaymentInstrumentData(
      cardData: cardData ?? this.cardData,
      paymentInstrumentType: paymentInstrumentType ?? this.paymentInstrumentType,
    );
  }

  factory PaymentInstrumentData.fromJson(Map<String, dynamic> json){
    return PaymentInstrumentData(
      cardData: json["cardData"] == null ? null : CardData.fromJson(json["cardData"]),
      paymentInstrumentType: json["paymentInstrumentType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "cardData": cardData?.toJson(),
    "paymentInstrumentType": paymentInstrumentType,
  };

  @override
  String toString(){
    return "$cardData, $paymentInstrumentType, ";
  }

}

class CardData {
  CardData({
    required this.cardCountryCode,
    required this.entryMode,
    required this.maskedPan,
    required this.paymentBrand,
    required this.sensitiveCardData,
  });

  final String cardCountryCode;
  final List<String> entryMode;
  final String maskedPan;
  final String paymentBrand;
  final SensitiveCardData? sensitiveCardData;

  CardData copyWith({
    String? cardCountryCode,
    List<String>? entryMode,
    String? maskedPan,
    String? paymentBrand,
    SensitiveCardData? sensitiveCardData,
  }) {
    return CardData(
      cardCountryCode: cardCountryCode ?? this.cardCountryCode,
      entryMode: entryMode ?? this.entryMode,
      maskedPan: maskedPan ?? this.maskedPan,
      paymentBrand: paymentBrand ?? this.paymentBrand,
      sensitiveCardData: sensitiveCardData ?? this.sensitiveCardData,
    );
  }

  factory CardData.fromJson(Map<String, dynamic> json){
    return CardData(
      cardCountryCode: json["cardCountryCode"] ?? "",
      entryMode: json["entryMode"] == null ? [] : List<String>.from(json["entryMode"]!.map((x) => x)),
      maskedPan: json["maskedPAN"] ?? "",
      paymentBrand: json["paymentBrand"] ?? "",
      sensitiveCardData: json["sensitiveCardData"] == null ? null : SensitiveCardData.fromJson(json["sensitiveCardData"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "cardCountryCode": cardCountryCode,
    "entryMode": entryMode.map((x) => x).toList(),
    "maskedPAN": maskedPan,
    "paymentBrand": paymentBrand,
    "sensitiveCardData": sensitiveCardData?.toJson(),
  };

  @override
  String toString(){
    return "$cardCountryCode, $entryMode, $maskedPan, $paymentBrand, $sensitiveCardData, ";
  }

}

class SensitiveCardData {
  SensitiveCardData({
    required this.cardSeqNumb,
    required this.expiryDate,
  });

  final String cardSeqNumb;
  final String expiryDate;

  SensitiveCardData copyWith({
    String? cardSeqNumb,
    String? expiryDate,
  }) {
    return SensitiveCardData(
      cardSeqNumb: cardSeqNumb ?? this.cardSeqNumb,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  factory SensitiveCardData.fromJson(Map<String, dynamic> json){
    return SensitiveCardData(
      cardSeqNumb: json["cardSeqNumb"] ?? "",
      expiryDate: json["expiryDate"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "cardSeqNumb": cardSeqNumb,
    "expiryDate": expiryDate,
  };

  @override
  String toString(){
    return "$cardSeqNumb, $expiryDate, ";
  }

}

class PoiData {
  PoiData({
    required this.poiReconciliationId,
    required this.poiTransactionId,
  });

  final String poiReconciliationId;
  final TransactionId? poiTransactionId;

  PoiData copyWith({
    String? poiReconciliationId,
    TransactionId? poiTransactionId,
  }) {
    return PoiData(
      poiReconciliationId: poiReconciliationId ?? this.poiReconciliationId,
      poiTransactionId: poiTransactionId ?? this.poiTransactionId,
    );
  }

  factory PoiData.fromJson(Map<String, dynamic> json){
    return PoiData(
      poiReconciliationId: json["poiReconciliationID"] ?? "",
      poiTransactionId: json["poiTransactionID"] == null ? null : TransactionId.fromJson(json["poiTransactionID"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "poiReconciliationID": poiReconciliationId,
    "poiTransactionID": poiTransactionId?.toJson(),
  };

  @override
  String toString(){
    return "$poiReconciliationId, $poiTransactionId, ";
  }

}

class Response {
  Response({
    required this.additionalResponse,
    required this.errorCondition,
    required this.result,
  });

  final AdditionalResponse? additionalResponse;
  final String errorCondition;
  final String result;

  Response copyWith({
    AdditionalResponse? additionalResponse,
    String? errorCondition,
    String? result,
  }) {
    return Response(
      additionalResponse: additionalResponse ?? this.additionalResponse,
      errorCondition: errorCondition ?? this.errorCondition,
      result: result ?? this.result,
    );
  }

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      additionalResponse: json["additionalResponse"] == null ? null : AdditionalResponse.fromJson(json["additionalResponse"]),
      errorCondition: json["errorCondition"] ?? "",
      result: json["result"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "additionalResponse": additionalResponse?.toJson(),
    "errorCondition": errorCondition,
    "result": result,
  };

  @override
  String toString(){
    return "$additionalResponse, $errorCondition, $result, ";
  }

}

class AdditionalResponse {
  AdditionalResponse({
    required this.additionalData,
    required this.message,
    required this.refusalReason,
    required this.store,
  });

  final Map<String, String> additionalData;
  final String message;
  final String refusalReason;
  final String store;

  AdditionalResponse copyWith({
    Map<String, String>? additionalData,
    String? message,
    String? refusalReason,
    String? store,
  }) {
    return AdditionalResponse(
      additionalData: additionalData ?? this.additionalData,
      message: message ?? this.message,
      refusalReason: refusalReason ?? this.refusalReason,
      store: store ?? this.store,
    );
  }

  factory AdditionalResponse.fromJson(Map<String, dynamic> json){
    return AdditionalResponse(
      additionalData: Map.from(json["additionalData"]).map((k, v) => MapEntry<String, String>(k, v)),
      message: json["message"] ?? "",
      refusalReason: json["refusalReason"] ?? "",
      store: json["store"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "additionalData": Map.from(additionalData).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "message": message,
    "refusalReason": refusalReason,
    "store": store,
  };

  @override
  String toString(){
    return "$additionalData, $message, $refusalReason, $store, ";
  }

}

class SaleData {
  SaleData({
    required this.saleToAcquirerData,
    required this.saleTransactionId,
  });

  final String saleToAcquirerData;
  final TransactionId? saleTransactionId;

  SaleData copyWith({
    String? saleToAcquirerData,
    TransactionId? saleTransactionId,
  }) {
    return SaleData(
      saleToAcquirerData: saleToAcquirerData ?? this.saleToAcquirerData,
      saleTransactionId: saleTransactionId ?? this.saleTransactionId,
    );
  }

  factory SaleData.fromJson(Map<String, dynamic> json){
    return SaleData(
      saleToAcquirerData: json["saleToAcquirerData"] ?? "",
      saleTransactionId: json["saleTransactionID"] == null ? null : TransactionId.fromJson(json["saleTransactionID"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "saleToAcquirerData": saleToAcquirerData,
    "saleTransactionID": saleTransactionId?.toJson(),
  };

  @override
  String toString(){
    return "$saleToAcquirerData, $saleTransactionId, ";
  }

}

/*
{
	"SaleToPOIResponse": {
		"messageHeader": {
			"messageCategory": "PAYMENT",
			"messageClass": "SERVICE",
			"messageType": "RESPONSE",
			"poiid": "e285p-805336269",
			"protocolVersion": "3.0",
			"saleID": "805336269",
			"serviceID": "Z1rTkSr5BO"
		},
		"paymentResponse": {
			"paymentResult": {
				"amountsResp": {
					"authorizedAmount": 6.09,
					"currency": "USD"
				},
				"onlineFlag": true,
				"paymentAcquirerData": {
					"acquirerPOIID": "e285p-805336269",
					"acquirerTransactionID": {
						"timeStamp": 41234123468768,
						"transactionID": "LMLVGSTLMV5X8N82"
					},
					"approvalCode": "123456",
					"merchantID": "CHEQ_POS_AFP"
				},
				"paymentInstrumentData": {
					"cardData": {
						"cardCountryCode": "826",
						"entryMode": [
							"CONTACTLESS"
						],
						"maskedPAN": "541333 **** 9999",
						"paymentBrand": "mc",
						"sensitiveCardData": {
							"cardSeqNumb": "33",
							"expiryDate": "0228"
						}
					},
					"paymentInstrumentType": "CARD"
				}
			},
			"poiData": {
				"poiReconciliationID": "1000",
				"poiTransactionID": {
					"timeStamp": 232342534523423460000,
					"transactionID": "VRyh001686910364001.LMLVGSTLMV5X8N82"
				}
			},
			"response": {
				"additionalResponse": {
					"additionalData": {
						"AID": "A000000004101001",
						"PaymentAccountReference": "u1bXGuubFPoOKVVV3GbuAeux5jYFO",
						"acquirerAccountCode": "TestPmmAcquirerAccount",
						"acquirerCode": "TestPmmAcquirer",
						"acquirerResponseCode": "APPROVED",
						"adjustAuthorisationData": "BQABAQBvioLrFcGoPscFYXCOTs0zx5xVV5wXeEz3ExsnjJjF4P6eQjjjLZe86vza1NbCnjhwnSKbd9okyP0NSAaHeg8NYzQlqAD3C02GJlVpcreXGX8oxJwNCIuvpbM9y5OFQmcudBUO1bu2UsHkiYogq10S0WxgPiJYuk+dMNHZmXhjYlt1Qa/KBcygIS+HRC8BzhXfC7755Thn/HJuvo9sq4PuW6RYgBN2Lub6VcaXjfNsMmYHB0BD+QahheWGVTLzVU+OI1SPop+x9FlowiUV6dDPxh4/HgZyUrC3rdsjBurF9nNMFnSPkpCRYl6g++oRUTJkJA5Yy3h0FDu7E4THet0KDDbPq0UhhGE1S4dI+wAAEO5rpKnVijH6yihbu9ZRemG1l+aGQ27L1bItvSSpuACSi8vuiyTZEEUpd0KGTC01Cf7RoaD8zL4ZqhqHOHKersPxQxexVxciWylqdkjtMjSm+NX3ST6evbeXIGlghW/l0u8tQpShdVTtp38P2S/0wG1hKdoJNKT4gdGxBh89yvQRkscibfePaq0hqRqDI2K3VSSiifK1Xbd9/z02PYSsFdvFqM6PuR9pYP6egBEYZz9P1stgbAB0kkNClRb/Jd48uxxjgzHurIQGDkWqu/7HGj9fYeSMaErOQL84g0q4eV7XV9uis41oaDWaBEWl3gEpxKMIIIA0eJrivmX3bZWn5tu7qlKWTTPvoFaAPMH/xt4Nc16/WnNS/0V8DdAtjkxeJ/qp97zW7/Omo8QP4+yhfqmIDi8j+t3Rl18A0MxWpqsr0FxWQT3KnqtzNBLoeynnpUjxqZALfoVtxpAA67N39SmbOCgt/Q==",
						"applicationLabel": "MCENGBRGBP",
						"applicationPreferredName": "mc en gbr gbp",
						"authCode": "123456",
						"authorisationMid": "50",
						"authorisedAmountCurrency": "USD",
						"authorisedAmountValue": "609",
						"avsResult": "0 Unknown",
						"backendGiftcardIndicator": "false",
						"batteryLevel": "100%",
						"cardBin": "541333",
						"cardHolderName": " /",
						"cardHolderVerificationMethodResults": "1F0302",
						"cardIssueNumber": "33",
						"cardIssuerCountryId": "826",
						"cardScheme": "mc",
						"cardSummary": "9999",
						"cardType": "mc",
						"cvcResult": "0 Unknown",
						"expiryDate": "2/2028",
						"expiryMonth": "02",
						"expiryYear": "2028",
						"fundingSource": "CREDIT",
						"giftcardIndicator": "false",
						"isCardCommercial": "unknown",
						"iso8601TxDate": "2023-06-16T10:12:44.853Z",
						"issuerCountry": "GB",
						"merchantReference": "Z1rTkSr5BO",
						"mid": "50",
						"offline": "false",
						"paymentMethod": "mc",
						"paymentMethodVariant": "mc",
						"posAmountCashbackValue": "0",
						"posAmountGratuityValue": "0",
						"posAuthAmountCurrency": "USD",
						"posAuthAmountValue": "609",
						"posEntryMode": "CLESS_CHIP",
						"posOriginalAmountValue": "609",
						"posadditionalamounts.originalAmountCurrency": "USD",
						"posadditionalamounts.originalAmountValue": "609",
						"pspReference": "LMLVGSTLMV5X8N82",
						"refusalReasonRaw": "APPROVED",
						"retry.attempt1.acquirer": "TestPmmAcquirer",
						"retry.attempt1.acquirerAccount": "TestPmmAcquirerAccount",
						"retry.attempt1.rawResponse": "APPROVED",
						"retry.attempt1.responseCode": "Approved",
						"retry.attempt1.shopperInteraction": "POS",
						"shopperCountry": "US",
						"startMonth": "01",
						"startYear": "2017",
						"tc": "B27BC3141A64B463",
						"tid": "66601063",
						"transactionReferenceNumber": "LMLVGSTLMV5X8N82",
						"transactionType": "GOODS_SERVICES",
						"txdate": "16-06-2023",
						"txtime": "03:12:44",
						"unconfirmedBatchCount": "1"
					},
					"message": "108 Shopper cancelled tx",
					"refusalReason": "108 Shopper cancelled tx",
					"store": "3802a06d-182f-468d-ada3-7d3791e15d19"
				},
				"errorCondition": "CANCEL",
				"result": "SUCCESS"
			},
			"saleData": {
				"saleToAcquirerData": "ewogICJhcHBsaWNhdGlvbkluZm8iOiB7CiAgICAiYWR5ZW5MaWJyYXJ5IjogewogICAgICAibmFtZSI6ICJhZHllbi1qYXZhLWFwaS1saWJyYXJ5IiwKICAgICAgInZlcnNpb24iOiAiMTguMS4zIgogICAgfQogIH0KfQ==",
				"saleTransactionID": {
					"timeStamp": 4123412341,
					"transactionID": "Z1rTkSr5BO"
				}
			}
		}
	}
}*/