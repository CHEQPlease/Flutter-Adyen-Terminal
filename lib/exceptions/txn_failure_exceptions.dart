import '../data/adyen_terminal_response.dart';


class BaseException implements Exception {
  String? errorCode;
  String? errorMessage;

  BaseException({
    this.errorCode,
    this.errorMessage,
  });
}

class TxnFailedOnTerminalException extends BaseException {
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

class FailedToCommunicateTerminalException extends BaseException{
    FailedToCommunicateTerminalException({
      String? errorCode,
      String? errorMessage,
    }):super(
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
}