enum ErrorCode {
  failureGeneric('FAILURE_GENERIC'),
  transactionFailure("TRANSACTION_FAILURE"),
  customerSignatureCollectionFailure("UNABLE_TO_GET_SIGNATURE"),
  tokenizationFailure("TOKENIZATION_FAILURE"),
  transactionTimeout("TRANSACTION_TIMEOUT"),
  unableToProcessResult("UNABLE_TO_PROCESS_RESULT"),
  connectionTimeout("CONNECTION_TIMEOUT"),
  deviceUnreachable("DEVICE_UNREACHABLE"),
  transactionFailureOthers("TRANSACTION_FAILURE_OTHERS");
  const ErrorCode(this.code);
  final String code;
}