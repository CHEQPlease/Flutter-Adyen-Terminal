import '../data/adyen_terminal_response.dart';


class TxnFailureBaseException implements Exception {
  String? errorCode;
  String? errorMessage;

  TxnFailureBaseException({
    this.errorCode,
    this.errorMessage,
  });
}

class TxnFailedOnTerminalException extends TxnFailureBaseException {
  final AdyenTerminalResponse adyenTerminalResponse;

  TxnFailedOnTerminalException({
    String? errorCode,
    String? errorMessage,
    required this.adyenTerminalResponse,
  }) : super(
    errorCode: errorCode,
    errorMessage: errorMessage,
  );
}

class TxnTimeoutException extends TxnFailureBaseException {
  TxnTimeoutException({
    String? errorCode,
    String? errorMessage
  }) : super(
    errorCode: errorCode,
    errorMessage: errorMessage,
  );
}

class FailedToCommunicateTerminalException extends TxnFailureBaseException{
    FailedToCommunicateTerminalException({
      String? errorCode,
      String? errorMessage,
    }):super(
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
}


class FailedToCancelTransaction extends TxnFailureBaseException {
  final AdyenTerminalResponse adyenTerminalResponse;

  FailedToCancelTransaction({
    String? errorCode,
    String? errorMessage,
    required this.adyenTerminalResponse,
  }) : super(
    errorCode: errorCode,
    errorMessage: errorMessage,
  );
}