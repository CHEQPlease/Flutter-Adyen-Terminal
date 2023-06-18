enum ErrorCode {
  failureGeneric,
  transactionFailure,
  unableToProcessResult,
  connectionTimeout,
  deviceUnreachable,
  transactionFailureOthers,
}

extension ErrorCodeValue on ErrorCode {
  String get value {
    switch (this) {
      case ErrorCode.failureGeneric:
        return '1000';
      case ErrorCode.transactionFailure:
        return '1001';
      case ErrorCode.unableToProcessResult:
        return '1002';
      case ErrorCode.connectionTimeout:
        return '1003';
      case ErrorCode.deviceUnreachable:
        return '1004';
      case ErrorCode.transactionFailureOthers:
        return '1005';
      default:
        throw Exception('Invalid ErrorCode');
    }
  }
}
