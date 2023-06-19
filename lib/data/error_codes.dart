enum ErrorCode {
  failureGeneric('FAILURE_GENERIC'),
  transactionFailure("TRANSACTION_FAILURE"),
  unableToProcessResult("UNABLE_TO_PROCESS_RESULT"),
  connectionTimeout("CONNECTION_TIMEOUT"),
  deviceUnreachable("DEVICE_UNREACHABLE"),
  transactionFailureOthers("TRANSACTION_FAILURE_OTHERS");
  const ErrorCode(this.code);
  final String code;
}