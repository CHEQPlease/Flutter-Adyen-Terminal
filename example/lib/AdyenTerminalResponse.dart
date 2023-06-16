import 'dart:convert';
AdyenTerminalResponse adyenTerminalResponseFromJson(String str) => AdyenTerminalResponse.fromJson(json.decode(str));
String adyenTerminalResponseToJson(AdyenTerminalResponse data) => json.encode(data.toJson());
class AdyenTerminalResponse {
  AdyenTerminalResponse({
      this.saleToPOIResponse,});

  AdyenTerminalResponse.fromJson(dynamic json) {
    saleToPOIResponse = json['SaleToPOIResponse'] != null ? SaleToPoiResponse.fromJson(json['SaleToPOIResponse']) : null;
  }
  SaleToPoiResponse? saleToPOIResponse;
AdyenTerminalResponse copyWith({  SaleToPoiResponse? saleToPOIResponse,
}) => AdyenTerminalResponse(  saleToPOIResponse: saleToPOIResponse ?? this.saleToPOIResponse,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (saleToPOIResponse != null) {
      map['SaleToPOIResponse'] = saleToPOIResponse?.toJson();
    }
    return map;
  }

}

SaleToPoiResponse saleToPoiResponseFromJson(String str) => SaleToPoiResponse.fromJson(json.decode(str));
String saleToPoiResponseToJson(SaleToPoiResponse data) => json.encode(data.toJson());
class SaleToPoiResponse {
  SaleToPoiResponse({
      this.messageHeader, 
      this.paymentResponse,});

  SaleToPoiResponse.fromJson(dynamic json) {
    messageHeader = json['messageHeader'] != null ? MessageHeader.fromJson(json['messageHeader']) : null;
    paymentResponse = json['paymentResponse'] != null ? PaymentResponse.fromJson(json['paymentResponse']) : null;
  }
  MessageHeader? messageHeader;
  PaymentResponse? paymentResponse;
SaleToPoiResponse copyWith({  MessageHeader? messageHeader,
  PaymentResponse? paymentResponse,
}) => SaleToPoiResponse(  messageHeader: messageHeader ?? this.messageHeader,
  paymentResponse: paymentResponse ?? this.paymentResponse,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (messageHeader != null) {
      map['messageHeader'] = messageHeader?.toJson();
    }
    if (paymentResponse != null) {
      map['paymentResponse'] = paymentResponse?.toJson();
    }
    return map;
  }

}

PaymentResponse paymentResponseFromJson(String str) => PaymentResponse.fromJson(json.decode(str));
String paymentResponseToJson(PaymentResponse data) => json.encode(data.toJson());
class PaymentResponse {
  PaymentResponse({
      this.paymentResult, 
      this.poiData, 
      this.response, 
      this.saleData,});

  PaymentResponse.fromJson(dynamic json) {
    paymentResult = json['paymentResult'] != null ? PaymentResult.fromJson(json['paymentResult']) : null;
    poiData = json['poiData'] != null ? PoiData.fromJson(json['poiData']) : null;
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    saleData = json['saleData'] != null ? SaleData.fromJson(json['saleData']) : null;
  }
  PaymentResult? paymentResult;
  PoiData? poiData;
  Response? response;
  SaleData? saleData;
PaymentResponse copyWith({  PaymentResult? paymentResult,
  PoiData? poiData,
  Response? response,
  SaleData? saleData,
}) => PaymentResponse(  paymentResult: paymentResult ?? this.paymentResult,
  poiData: poiData ?? this.poiData,
  response: response ?? this.response,
  saleData: saleData ?? this.saleData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (paymentResult != null) {
      map['paymentResult'] = paymentResult?.toJson();
    }
    if (poiData != null) {
      map['poiData'] = poiData?.toJson();
    }
    if (response != null) {
      map['response'] = response?.toJson();
    }
    if (saleData != null) {
      map['saleData'] = saleData?.toJson();
    }
    return map;
  }

}

SaleData saleDataFromJson(String str) => SaleData.fromJson(json.decode(str));
String saleDataToJson(SaleData data) => json.encode(data.toJson());
class SaleData {
  SaleData({
      this.saleToAcquirerData, 
      this.saleTransactionID,});

  SaleData.fromJson(dynamic json) {
    saleToAcquirerData = json['saleToAcquirerData'];
    saleTransactionID = json['saleTransactionID'] != null ? SaleTransactionId.fromJson(json['saleTransactionID']) : null;
  }
  String? saleToAcquirerData;
  SaleTransactionId? saleTransactionID;
SaleData copyWith({  String? saleToAcquirerData,
  SaleTransactionId? saleTransactionID,
}) => SaleData(  saleToAcquirerData: saleToAcquirerData ?? this.saleToAcquirerData,
  saleTransactionID: saleTransactionID ?? this.saleTransactionID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['saleToAcquirerData'] = saleToAcquirerData;
    if (saleTransactionID != null) {
      map['saleTransactionID'] = saleTransactionID?.toJson();
    }
    return map;
  }

}

SaleTransactionId saleTransactionIdFromJson(String str) => SaleTransactionId.fromJson(json.decode(str));
String saleTransactionIdToJson(SaleTransactionId data) => json.encode(data.toJson());
class SaleTransactionId {
  SaleTransactionId({
      this.timeStamp, 
      this.transactionID,});

  SaleTransactionId.fromJson(dynamic json) {
    timeStamp = json['timeStamp'];
    transactionID = json['transactionID'];
  }
  num? timeStamp;
  String? transactionID;
SaleTransactionId copyWith({  num? timeStamp,
  String? transactionID,
}) => SaleTransactionId(  timeStamp: timeStamp ?? this.timeStamp,
  transactionID: transactionID ?? this.transactionID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timeStamp'] = timeStamp;
    map['transactionID'] = transactionID;
    return map;
  }

}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));
String responseToJson(Response data) => json.encode(data.toJson());
class Response {
  Response({
      this.additionalResponse, 
      this.errorCondition, 
      this.result,});

  Response.fromJson(dynamic json) {
    additionalResponse = json['additionalResponse'] != null ? AdditionalResponse.fromJson(json['additionalResponse']) : null;
    errorCondition = json['errorCondition'];
    result = json['result'];
  }
  AdditionalResponse? additionalResponse;
  String? errorCondition;
  String? result;
Response copyWith({  AdditionalResponse? additionalResponse,
  String? errorCondition,
  String? result,
}) => Response(  additionalResponse: additionalResponse ?? this.additionalResponse,
  errorCondition: errorCondition ?? this.errorCondition,
  result: result ?? this.result,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (additionalResponse != null) {
      map['additionalResponse'] = additionalResponse?.toJson();
    }
    map['errorCondition'] = errorCondition;
    map['result'] = result;
    return map;
  }

}

AdditionalResponse additionalResponseFromJson(String str) => AdditionalResponse.fromJson(json.decode(str));
String additionalResponseToJson(AdditionalResponse data) => json.encode(data.toJson());
class AdditionalResponse {
  AdditionalResponse({
      this.additionalData, 
      this.message, 
      this.refusalReason, 
      this.store,});

  AdditionalResponse.fromJson(dynamic json) {
    additionalData = json['additionalData'] != null ? AdditionalData.fromJson(json['additionalData']) : null;
    message = json['message'];
    refusalReason = json['refusalReason'];
    store = json['store'];
  }
  AdditionalData? additionalData;
  String? message;
  String? refusalReason;
  String? store;
AdditionalResponse copyWith({  AdditionalData? additionalData,
  String? message,
  String? refusalReason,
  String? store,
}) => AdditionalResponse(  additionalData: additionalData ?? this.additionalData,
  message: message ?? this.message,
  refusalReason: refusalReason ?? this.refusalReason,
  store: store ?? this.store,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (additionalData != null) {
      map['additionalData'] = additionalData?.toJson();
    }
    map['message'] = message;
    map['refusalReason'] = refusalReason;
    map['store'] = store;
    return map;
  }

}

AdditionalData additionalDataFromJson(String str) => AdditionalData.fromJson(json.decode(str));
String additionalDataToJson(AdditionalData data) => json.encode(data.toJson());
class AdditionalData {
  AdditionalData({
      this.aid, 
      this.paymentAccountReference, 
      this.acquirerAccountCode, 
      this.acquirerCode, 
      this.acquirerResponseCode, 
      this.adjustAuthorisationData, 
      this.applicationLabel, 
      this.applicationPreferredName, 
      this.authCode, 
      this.authorisationMid, 
      this.authorisedAmountCurrency, 
      this.authorisedAmountValue, 
      this.avsResult, 
      this.backendGiftcardIndicator, 
      this.batteryLevel, 
      this.cardBin, 
      this.cardHolderName, 
      this.cardHolderVerificationMethodResults, 
      this.cardIssueNumber, 
      this.cardIssuerCountryId, 
      this.cardScheme, 
      this.cardSummary, 
      this.cardType, 
      this.cvcResult, 
      this.expiryDate, 
      this.expiryMonth, 
      this.expiryYear, 
      this.fundingSource, 
      this.giftcardIndicator, 
      this.isCardCommercial, 
      this.iso8601TxDate, 
      this.issuerCountry, 
      this.merchantReference, 
      this.mid, 
      this.offline, 
      this.paymentMethod, 
      this.paymentMethodVariant, 
      this.posAmountCashbackValue, 
      this.posAmountGratuityValue, 
      this.posAuthAmountCurrency, 
      this.posAuthAmountValue, 
      this.posEntryMode, 
      this.posOriginalAmountValue, 
      this.posadditionalamountsoriginalAmountCurrency, 
      this.posadditionalamountsoriginalAmountValue, 
      this.pspReference, 
      this.refusalReasonRaw, 
      this.retryattempt1acquirer, 
      this.retryattempt1acquirerAccount, 
      this.retryattempt1rawResponse, 
      this.retryattempt1responseCode, 
      this.retryattempt1shopperInteraction, 
      this.shopperCountry, 
      this.startMonth, 
      this.startYear, 
      this.tc, 
      this.tid, 
      this.transactionReferenceNumber, 
      this.transactionType, 
      this.txdate, 
      this.txtime, 
      this.unconfirmedBatchCount,});

  AdditionalData.fromJson(dynamic json) {
    aid = json['AID'];
    paymentAccountReference = json['PaymentAccountReference'];
    acquirerAccountCode = json['acquirerAccountCode'];
    acquirerCode = json['acquirerCode'];
    acquirerResponseCode = json['acquirerResponseCode'];
    adjustAuthorisationData = json['adjustAuthorisationData'];
    applicationLabel = json['applicationLabel'];
    applicationPreferredName = json['applicationPreferredName'];
    authCode = json['authCode'];
    authorisationMid = json['authorisationMid'];
    authorisedAmountCurrency = json['authorisedAmountCurrency'];
    authorisedAmountValue = json['authorisedAmountValue'];
    avsResult = json['avsResult'];
    backendGiftcardIndicator = json['backendGiftcardIndicator'];
    batteryLevel = json['batteryLevel'];
    cardBin = json['cardBin'];
    cardHolderName = json['cardHolderName'];
    cardHolderVerificationMethodResults = json['cardHolderVerificationMethodResults'];
    cardIssueNumber = json['cardIssueNumber'];
    cardIssuerCountryId = json['cardIssuerCountryId'];
    cardScheme = json['cardScheme'];
    cardSummary = json['cardSummary'];
    cardType = json['cardType'];
    cvcResult = json['cvcResult'];
    expiryDate = json['expiryDate'];
    expiryMonth = json['expiryMonth'];
    expiryYear = json['expiryYear'];
    fundingSource = json['fundingSource'];
    giftcardIndicator = json['giftcardIndicator'];
    isCardCommercial = json['isCardCommercial'];
    iso8601TxDate = json['iso8601TxDate'];
    issuerCountry = json['issuerCountry'];
    merchantReference = json['merchantReference'];
    mid = json['mid'];
    offline = json['offline'];
    paymentMethod = json['paymentMethod'];
    paymentMethodVariant = json['paymentMethodVariant'];
    posAmountCashbackValue = json['posAmountCashbackValue'];
    posAmountGratuityValue = json['posAmountGratuityValue'];
    posAuthAmountCurrency = json['posAuthAmountCurrency'];
    posAuthAmountValue = json['posAuthAmountValue'];
    posEntryMode = json['posEntryMode'];
    posOriginalAmountValue = json['posOriginalAmountValue'];
    posadditionalamountsoriginalAmountCurrency = json['posadditionalamounts.originalAmountCurrency'];
    posadditionalamountsoriginalAmountValue = json['posadditionalamounts.originalAmountValue'];
    pspReference = json['pspReference'];
    refusalReasonRaw = json['refusalReasonRaw'];
    retryattempt1acquirer = json['retry.attempt1.acquirer'];
    retryattempt1acquirerAccount = json['retry.attempt1.acquirerAccount'];
    retryattempt1rawResponse = json['retry.attempt1.rawResponse'];
    retryattempt1responseCode = json['retry.attempt1.responseCode'];
    retryattempt1shopperInteraction = json['retry.attempt1.shopperInteraction'];
    shopperCountry = json['shopperCountry'];
    startMonth = json['startMonth'];
    startYear = json['startYear'];
    tc = json['tc'];
    tid = json['tid'];
    transactionReferenceNumber = json['transactionReferenceNumber'];
    transactionType = json['transactionType'];
    txdate = json['txdate'];
    txtime = json['txtime'];
    unconfirmedBatchCount = json['unconfirmedBatchCount'];
  }
  String? aid;
  String? paymentAccountReference;
  String? acquirerAccountCode;
  String? acquirerCode;
  String? acquirerResponseCode;
  String? adjustAuthorisationData;
  String? applicationLabel;
  String? applicationPreferredName;
  String? authCode;
  String? authorisationMid;
  String? authorisedAmountCurrency;
  String? authorisedAmountValue;
  String? avsResult;
  String? backendGiftcardIndicator;
  String? batteryLevel;
  String? cardBin;
  String? cardHolderName;
  String? cardHolderVerificationMethodResults;
  String? cardIssueNumber;
  String? cardIssuerCountryId;
  String? cardScheme;
  String? cardSummary;
  String? cardType;
  String? cvcResult;
  String? expiryDate;
  String? expiryMonth;
  String? expiryYear;
  String? fundingSource;
  String? giftcardIndicator;
  String? isCardCommercial;
  String? iso8601TxDate;
  String? issuerCountry;
  String? merchantReference;
  String? mid;
  String? offline;
  String? paymentMethod;
  String? paymentMethodVariant;
  String? posAmountCashbackValue;
  String? posAmountGratuityValue;
  String? posAuthAmountCurrency;
  String? posAuthAmountValue;
  String? posEntryMode;
  String? posOriginalAmountValue;
  String? posadditionalamountsoriginalAmountCurrency;
  String? posadditionalamountsoriginalAmountValue;
  String? pspReference;
  String? refusalReasonRaw;
  String? retryattempt1acquirer;
  String? retryattempt1acquirerAccount;
  String? retryattempt1rawResponse;
  String? retryattempt1responseCode;
  String? retryattempt1shopperInteraction;
  String? shopperCountry;
  String? startMonth;
  String? startYear;
  String? tc;
  String? tid;
  String? transactionReferenceNumber;
  String? transactionType;
  String? txdate;
  String? txtime;
  String? unconfirmedBatchCount;
AdditionalData copyWith({  String? aid,
  String? paymentAccountReference,
  String? acquirerAccountCode,
  String? acquirerCode,
  String? acquirerResponseCode,
  String? adjustAuthorisationData,
  String? applicationLabel,
  String? applicationPreferredName,
  String? authCode,
  String? authorisationMid,
  String? authorisedAmountCurrency,
  String? authorisedAmountValue,
  String? avsResult,
  String? backendGiftcardIndicator,
  String? batteryLevel,
  String? cardBin,
  String? cardHolderName,
  String? cardHolderVerificationMethodResults,
  String? cardIssueNumber,
  String? cardIssuerCountryId,
  String? cardScheme,
  String? cardSummary,
  String? cardType,
  String? cvcResult,
  String? expiryDate,
  String? expiryMonth,
  String? expiryYear,
  String? fundingSource,
  String? giftcardIndicator,
  String? isCardCommercial,
  String? iso8601TxDate,
  String? issuerCountry,
  String? merchantReference,
  String? mid,
  String? offline,
  String? paymentMethod,
  String? paymentMethodVariant,
  String? posAmountCashbackValue,
  String? posAmountGratuityValue,
  String? posAuthAmountCurrency,
  String? posAuthAmountValue,
  String? posEntryMode,
  String? posOriginalAmountValue,
  String? posadditionalamountsoriginalAmountCurrency,
  String? posadditionalamountsoriginalAmountValue,
  String? pspReference,
  String? refusalReasonRaw,
  String? retryattempt1acquirer,
  String? retryattempt1acquirerAccount,
  String? retryattempt1rawResponse,
  String? retryattempt1responseCode,
  String? retryattempt1shopperInteraction,
  String? shopperCountry,
  String? startMonth,
  String? startYear,
  String? tc,
  String? tid,
  String? transactionReferenceNumber,
  String? transactionType,
  String? txdate,
  String? txtime,
  String? unconfirmedBatchCount,
}) => AdditionalData(  aid: aid ?? this.aid,
  paymentAccountReference: paymentAccountReference ?? this.paymentAccountReference,
  acquirerAccountCode: acquirerAccountCode ?? this.acquirerAccountCode,
  acquirerCode: acquirerCode ?? this.acquirerCode,
  acquirerResponseCode: acquirerResponseCode ?? this.acquirerResponseCode,
  adjustAuthorisationData: adjustAuthorisationData ?? this.adjustAuthorisationData,
  applicationLabel: applicationLabel ?? this.applicationLabel,
  applicationPreferredName: applicationPreferredName ?? this.applicationPreferredName,
  authCode: authCode ?? this.authCode,
  authorisationMid: authorisationMid ?? this.authorisationMid,
  authorisedAmountCurrency: authorisedAmountCurrency ?? this.authorisedAmountCurrency,
  authorisedAmountValue: authorisedAmountValue ?? this.authorisedAmountValue,
  avsResult: avsResult ?? this.avsResult,
  backendGiftcardIndicator: backendGiftcardIndicator ?? this.backendGiftcardIndicator,
  batteryLevel: batteryLevel ?? this.batteryLevel,
  cardBin: cardBin ?? this.cardBin,
  cardHolderName: cardHolderName ?? this.cardHolderName,
  cardHolderVerificationMethodResults: cardHolderVerificationMethodResults ?? this.cardHolderVerificationMethodResults,
  cardIssueNumber: cardIssueNumber ?? this.cardIssueNumber,
  cardIssuerCountryId: cardIssuerCountryId ?? this.cardIssuerCountryId,
  cardScheme: cardScheme ?? this.cardScheme,
  cardSummary: cardSummary ?? this.cardSummary,
  cardType: cardType ?? this.cardType,
  cvcResult: cvcResult ?? this.cvcResult,
  expiryDate: expiryDate ?? this.expiryDate,
  expiryMonth: expiryMonth ?? this.expiryMonth,
  expiryYear: expiryYear ?? this.expiryYear,
  fundingSource: fundingSource ?? this.fundingSource,
  giftcardIndicator: giftcardIndicator ?? this.giftcardIndicator,
  isCardCommercial: isCardCommercial ?? this.isCardCommercial,
  iso8601TxDate: iso8601TxDate ?? this.iso8601TxDate,
  issuerCountry: issuerCountry ?? this.issuerCountry,
  merchantReference: merchantReference ?? this.merchantReference,
  mid: mid ?? this.mid,
  offline: offline ?? this.offline,
  paymentMethod: paymentMethod ?? this.paymentMethod,
  paymentMethodVariant: paymentMethodVariant ?? this.paymentMethodVariant,
  posAmountCashbackValue: posAmountCashbackValue ?? this.posAmountCashbackValue,
  posAmountGratuityValue: posAmountGratuityValue ?? this.posAmountGratuityValue,
  posAuthAmountCurrency: posAuthAmountCurrency ?? this.posAuthAmountCurrency,
  posAuthAmountValue: posAuthAmountValue ?? this.posAuthAmountValue,
  posEntryMode: posEntryMode ?? this.posEntryMode,
  posOriginalAmountValue: posOriginalAmountValue ?? this.posOriginalAmountValue,
  posadditionalamountsoriginalAmountCurrency: posadditionalamountsoriginalAmountCurrency ?? this.posadditionalamountsoriginalAmountCurrency,
  posadditionalamountsoriginalAmountValue: posadditionalamountsoriginalAmountValue ?? this.posadditionalamountsoriginalAmountValue,
  pspReference: pspReference ?? this.pspReference,
  refusalReasonRaw: refusalReasonRaw ?? this.refusalReasonRaw,
  retryattempt1acquirer: retryattempt1acquirer ?? this.retryattempt1acquirer,
  retryattempt1acquirerAccount: retryattempt1acquirerAccount ?? this.retryattempt1acquirerAccount,
  retryattempt1rawResponse: retryattempt1rawResponse ?? this.retryattempt1rawResponse,
  retryattempt1responseCode: retryattempt1responseCode ?? this.retryattempt1responseCode,
  retryattempt1shopperInteraction: retryattempt1shopperInteraction ?? this.retryattempt1shopperInteraction,
  shopperCountry: shopperCountry ?? this.shopperCountry,
  startMonth: startMonth ?? this.startMonth,
  startYear: startYear ?? this.startYear,
  tc: tc ?? this.tc,
  tid: tid ?? this.tid,
  transactionReferenceNumber: transactionReferenceNumber ?? this.transactionReferenceNumber,
  transactionType: transactionType ?? this.transactionType,
  txdate: txdate ?? this.txdate,
  txtime: txtime ?? this.txtime,
  unconfirmedBatchCount: unconfirmedBatchCount ?? this.unconfirmedBatchCount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AID'] = aid;
    map['PaymentAccountReference'] = paymentAccountReference;
    map['acquirerAccountCode'] = acquirerAccountCode;
    map['acquirerCode'] = acquirerCode;
    map['acquirerResponseCode'] = acquirerResponseCode;
    map['adjustAuthorisationData'] = adjustAuthorisationData;
    map['applicationLabel'] = applicationLabel;
    map['applicationPreferredName'] = applicationPreferredName;
    map['authCode'] = authCode;
    map['authorisationMid'] = authorisationMid;
    map['authorisedAmountCurrency'] = authorisedAmountCurrency;
    map['authorisedAmountValue'] = authorisedAmountValue;
    map['avsResult'] = avsResult;
    map['backendGiftcardIndicator'] = backendGiftcardIndicator;
    map['batteryLevel'] = batteryLevel;
    map['cardBin'] = cardBin;
    map['cardHolderName'] = cardHolderName;
    map['cardHolderVerificationMethodResults'] = cardHolderVerificationMethodResults;
    map['cardIssueNumber'] = cardIssueNumber;
    map['cardIssuerCountryId'] = cardIssuerCountryId;
    map['cardScheme'] = cardScheme;
    map['cardSummary'] = cardSummary;
    map['cardType'] = cardType;
    map['cvcResult'] = cvcResult;
    map['expiryDate'] = expiryDate;
    map['expiryMonth'] = expiryMonth;
    map['expiryYear'] = expiryYear;
    map['fundingSource'] = fundingSource;
    map['giftcardIndicator'] = giftcardIndicator;
    map['isCardCommercial'] = isCardCommercial;
    map['iso8601TxDate'] = iso8601TxDate;
    map['issuerCountry'] = issuerCountry;
    map['merchantReference'] = merchantReference;
    map['mid'] = mid;
    map['offline'] = offline;
    map['paymentMethod'] = paymentMethod;
    map['paymentMethodVariant'] = paymentMethodVariant;
    map['posAmountCashbackValue'] = posAmountCashbackValue;
    map['posAmountGratuityValue'] = posAmountGratuityValue;
    map['posAuthAmountCurrency'] = posAuthAmountCurrency;
    map['posAuthAmountValue'] = posAuthAmountValue;
    map['posEntryMode'] = posEntryMode;
    map['posOriginalAmountValue'] = posOriginalAmountValue;
    map['posadditionalamounts.originalAmountCurrency'] = posadditionalamountsoriginalAmountCurrency;
    map['posadditionalamounts.originalAmountValue'] = posadditionalamountsoriginalAmountValue;
    map['pspReference'] = pspReference;
    map['refusalReasonRaw'] = refusalReasonRaw;
    map['retry.attempt1.acquirer'] = retryattempt1acquirer;
    map['retry.attempt1.acquirerAccount'] = retryattempt1acquirerAccount;
    map['retry.attempt1.rawResponse'] = retryattempt1rawResponse;
    map['retry.attempt1.responseCode'] = retryattempt1responseCode;
    map['retry.attempt1.shopperInteraction'] = retryattempt1shopperInteraction;
    map['shopperCountry'] = shopperCountry;
    map['startMonth'] = startMonth;
    map['startYear'] = startYear;
    map['tc'] = tc;
    map['tid'] = tid;
    map['transactionReferenceNumber'] = transactionReferenceNumber;
    map['transactionType'] = transactionType;
    map['txdate'] = txdate;
    map['txtime'] = txtime;
    map['unconfirmedBatchCount'] = unconfirmedBatchCount;
    return map;
  }

}

PoiData poiDataFromJson(String str) => PoiData.fromJson(json.decode(str));
String poiDataToJson(PoiData data) => json.encode(data.toJson());
class PoiData {
  PoiData({
      this.poiReconciliationID, 
      this.poiTransactionID,});

  PoiData.fromJson(dynamic json) {
    poiReconciliationID = json['poiReconciliationID'];
    poiTransactionID = json['poiTransactionID'] != null ? PoiTransactionId.fromJson(json['poiTransactionID']) : null;
  }
  String? poiReconciliationID;
  PoiTransactionId? poiTransactionID;
PoiData copyWith({  String? poiReconciliationID,
  PoiTransactionId? poiTransactionID,
}) => PoiData(  poiReconciliationID: poiReconciliationID ?? this.poiReconciliationID,
  poiTransactionID: poiTransactionID ?? this.poiTransactionID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poiReconciliationID'] = poiReconciliationID;
    if (poiTransactionID != null) {
      map['poiTransactionID'] = poiTransactionID?.toJson();
    }
    return map;
  }

}

PoiTransactionId poiTransactionIdFromJson(String str) => PoiTransactionId.fromJson(json.decode(str));
String poiTransactionIdToJson(PoiTransactionId data) => json.encode(data.toJson());
class PoiTransactionId {
  PoiTransactionId({
      this.timeStamp, 
      this.transactionID,});

  PoiTransactionId.fromJson(dynamic json) {
    timeStamp = json['timeStamp'];
    transactionID = json['transactionID'];
  }
  num? timeStamp;
  String? transactionID;
PoiTransactionId copyWith({  num? timeStamp,
  String? transactionID,
}) => PoiTransactionId(  timeStamp: timeStamp ?? this.timeStamp,
  transactionID: transactionID ?? this.transactionID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timeStamp'] = timeStamp;
    map['transactionID'] = transactionID;
    return map;
  }

}

PaymentResult paymentResultFromJson(String str) => PaymentResult.fromJson(json.decode(str));
String paymentResultToJson(PaymentResult data) => json.encode(data.toJson());
class PaymentResult {
  PaymentResult({
      this.amountsResp, 
      this.onlineFlag, 
      this.paymentAcquirerData, 
      this.paymentInstrumentData,});

  PaymentResult.fromJson(dynamic json) {
    amountsResp = json['amountsResp'] != null ? AmountsResp.fromJson(json['amountsResp']) : null;
    onlineFlag = json['onlineFlag'];
    paymentAcquirerData = json['paymentAcquirerData'] != null ? PaymentAcquirerData.fromJson(json['paymentAcquirerData']) : null;
    paymentInstrumentData = json['paymentInstrumentData'] != null ? PaymentInstrumentData.fromJson(json['paymentInstrumentData']) : null;
  }
  AmountsResp? amountsResp;
  bool? onlineFlag;
  PaymentAcquirerData? paymentAcquirerData;
  PaymentInstrumentData? paymentInstrumentData;
PaymentResult copyWith({  AmountsResp? amountsResp,
  bool? onlineFlag,
  PaymentAcquirerData? paymentAcquirerData,
  PaymentInstrumentData? paymentInstrumentData,
}) => PaymentResult(  amountsResp: amountsResp ?? this.amountsResp,
  onlineFlag: onlineFlag ?? this.onlineFlag,
  paymentAcquirerData: paymentAcquirerData ?? this.paymentAcquirerData,
  paymentInstrumentData: paymentInstrumentData ?? this.paymentInstrumentData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (amountsResp != null) {
      map['amountsResp'] = amountsResp?.toJson();
    }
    map['onlineFlag'] = onlineFlag;
    if (paymentAcquirerData != null) {
      map['paymentAcquirerData'] = paymentAcquirerData?.toJson();
    }
    if (paymentInstrumentData != null) {
      map['paymentInstrumentData'] = paymentInstrumentData?.toJson();
    }
    return map;
  }

}

PaymentInstrumentData paymentInstrumentDataFromJson(String str) => PaymentInstrumentData.fromJson(json.decode(str));
String paymentInstrumentDataToJson(PaymentInstrumentData data) => json.encode(data.toJson());
class PaymentInstrumentData {
  PaymentInstrumentData({
      this.cardData, 
      this.paymentInstrumentType,});

  PaymentInstrumentData.fromJson(dynamic json) {
    cardData = json['cardData'] != null ? CardData.fromJson(json['cardData']) : null;
    paymentInstrumentType = json['paymentInstrumentType'];
  }
  CardData? cardData;
  String? paymentInstrumentType;
PaymentInstrumentData copyWith({  CardData? cardData,
  String? paymentInstrumentType,
}) => PaymentInstrumentData(  cardData: cardData ?? this.cardData,
  paymentInstrumentType: paymentInstrumentType ?? this.paymentInstrumentType,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cardData != null) {
      map['cardData'] = cardData?.toJson();
    }
    map['paymentInstrumentType'] = paymentInstrumentType;
    return map;
  }

}

CardData cardDataFromJson(String str) => CardData.fromJson(json.decode(str));
String cardDataToJson(CardData data) => json.encode(data.toJson());
class CardData {
  CardData({
      this.cardCountryCode, 
      this.entryMode, 
      this.maskedPAN, 
      this.paymentBrand, 
      this.sensitiveCardData,});

  CardData.fromJson(dynamic json) {
    cardCountryCode = json['cardCountryCode'];
    entryMode = json['entryMode'] != null ? json['entryMode'].cast<String>() : [];
    maskedPAN = json['maskedPAN'];
    paymentBrand = json['paymentBrand'];
    sensitiveCardData = json['sensitiveCardData'] != null ? SensitiveCardData.fromJson(json['sensitiveCardData']) : null;
  }
  String? cardCountryCode;
  List<String>? entryMode;
  String? maskedPAN;
  String? paymentBrand;
  SensitiveCardData? sensitiveCardData;
CardData copyWith({  String? cardCountryCode,
  List<String>? entryMode,
  String? maskedPAN,
  String? paymentBrand,
  SensitiveCardData? sensitiveCardData,
}) => CardData(  cardCountryCode: cardCountryCode ?? this.cardCountryCode,
  entryMode: entryMode ?? this.entryMode,
  maskedPAN: maskedPAN ?? this.maskedPAN,
  paymentBrand: paymentBrand ?? this.paymentBrand,
  sensitiveCardData: sensitiveCardData ?? this.sensitiveCardData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cardCountryCode'] = cardCountryCode;
    map['entryMode'] = entryMode;
    map['maskedPAN'] = maskedPAN;
    map['paymentBrand'] = paymentBrand;
    if (sensitiveCardData != null) {
      map['sensitiveCardData'] = sensitiveCardData?.toJson();
    }
    return map;
  }

}

SensitiveCardData sensitiveCardDataFromJson(String str) => SensitiveCardData.fromJson(json.decode(str));
String sensitiveCardDataToJson(SensitiveCardData data) => json.encode(data.toJson());
class SensitiveCardData {
  SensitiveCardData({
      this.cardSeqNumb, 
      this.expiryDate,});

  SensitiveCardData.fromJson(dynamic json) {
    cardSeqNumb = json['cardSeqNumb'];
    expiryDate = json['expiryDate'];
  }
  String? cardSeqNumb;
  String? expiryDate;
SensitiveCardData copyWith({  String? cardSeqNumb,
  String? expiryDate,
}) => SensitiveCardData(  cardSeqNumb: cardSeqNumb ?? this.cardSeqNumb,
  expiryDate: expiryDate ?? this.expiryDate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cardSeqNumb'] = cardSeqNumb;
    map['expiryDate'] = expiryDate;
    return map;
  }

}

PaymentAcquirerData paymentAcquirerDataFromJson(String str) => PaymentAcquirerData.fromJson(json.decode(str));
String paymentAcquirerDataToJson(PaymentAcquirerData data) => json.encode(data.toJson());
class PaymentAcquirerData {
  PaymentAcquirerData({
      this.acquirerPOIID, 
      this.acquirerTransactionID, 
      this.approvalCode, 
      this.merchantID,});

  PaymentAcquirerData.fromJson(dynamic json) {
    acquirerPOIID = json['acquirerPOIID'];
    acquirerTransactionID = json['acquirerTransactionID'] != null ? AcquirerTransactionId.fromJson(json['acquirerTransactionID']) : null;
    approvalCode = json['approvalCode'];
    merchantID = json['merchantID'];
  }
  String? acquirerPOIID;
  AcquirerTransactionId? acquirerTransactionID;
  String? approvalCode;
  String? merchantID;
PaymentAcquirerData copyWith({  String? acquirerPOIID,
  AcquirerTransactionId? acquirerTransactionID,
  String? approvalCode,
  String? merchantID,
}) => PaymentAcquirerData(  acquirerPOIID: acquirerPOIID ?? this.acquirerPOIID,
  acquirerTransactionID: acquirerTransactionID ?? this.acquirerTransactionID,
  approvalCode: approvalCode ?? this.approvalCode,
  merchantID: merchantID ?? this.merchantID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acquirerPOIID'] = acquirerPOIID;
    if (acquirerTransactionID != null) {
      map['acquirerTransactionID'] = acquirerTransactionID?.toJson();
    }
    map['approvalCode'] = approvalCode;
    map['merchantID'] = merchantID;
    return map;
  }

}

AcquirerTransactionId acquirerTransactionIdFromJson(String str) => AcquirerTransactionId.fromJson(json.decode(str));
String acquirerTransactionIdToJson(AcquirerTransactionId data) => json.encode(data.toJson());
class AcquirerTransactionId {
  AcquirerTransactionId({
      this.timeStamp, 
      this.transactionID,});

  AcquirerTransactionId.fromJson(dynamic json) {
    timeStamp = json['timeStamp'];
    transactionID = json['transactionID'];
  }
  num? timeStamp;
  String? transactionID;
AcquirerTransactionId copyWith({  num? timeStamp,
  String? transactionID,
}) => AcquirerTransactionId(  timeStamp: timeStamp ?? this.timeStamp,
  transactionID: transactionID ?? this.transactionID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timeStamp'] = timeStamp;
    map['transactionID'] = transactionID;
    return map;
  }

}

AmountsResp amountsRespFromJson(String str) => AmountsResp.fromJson(json.decode(str));
String amountsRespToJson(AmountsResp data) => json.encode(data.toJson());
class AmountsResp {
  AmountsResp({
      this.authorizedAmount, 
      this.currency,});

  AmountsResp.fromJson(dynamic json) {
    authorizedAmount = json['authorizedAmount'];
    currency = json['currency'];
  }
  num? authorizedAmount;
  String? currency;
AmountsResp copyWith({  num? authorizedAmount,
  String? currency,
}) => AmountsResp(  authorizedAmount: authorizedAmount ?? this.authorizedAmount,
  currency: currency ?? this.currency,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authorizedAmount'] = authorizedAmount;
    map['currency'] = currency;
    return map;
  }

}

MessageHeader messageHeaderFromJson(String str) => MessageHeader.fromJson(json.decode(str));
String messageHeaderToJson(MessageHeader data) => json.encode(data.toJson());
class MessageHeader {
  MessageHeader({
      this.messageCategory, 
      this.messageClass, 
      this.messageType, 
      this.poiid, 
      this.protocolVersion, 
      this.saleID, 
      this.serviceID,});

  MessageHeader.fromJson(dynamic json) {
    messageCategory = json['messageCategory'];
    messageClass = json['messageClass'];
    messageType = json['messageType'];
    poiid = json['poiid'];
    protocolVersion = json['protocolVersion'];
    saleID = json['saleID'];
    serviceID = json['serviceID'];
  }
  String? messageCategory;
  String? messageClass;
  String? messageType;
  String? poiid;
  String? protocolVersion;
  String? saleID;
  String? serviceID;
MessageHeader copyWith({  String? messageCategory,
  String? messageClass,
  String? messageType,
  String? poiid,
  String? protocolVersion,
  String? saleID,
  String? serviceID,
}) => MessageHeader(  messageCategory: messageCategory ?? this.messageCategory,
  messageClass: messageClass ?? this.messageClass,
  messageType: messageType ?? this.messageType,
  poiid: poiid ?? this.poiid,
  protocolVersion: protocolVersion ?? this.protocolVersion,
  saleID: saleID ?? this.saleID,
  serviceID: serviceID ?? this.serviceID,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messageCategory'] = messageCategory;
    map['messageClass'] = messageClass;
    map['messageType'] = messageType;
    map['poiid'] = poiid;
    map['protocolVersion'] = protocolVersion;
    map['saleID'] = saleID;
    map['serviceID'] = serviceID;
    return map;
  }

}