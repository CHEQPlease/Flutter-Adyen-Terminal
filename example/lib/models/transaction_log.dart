import 'package:flutter/material.dart';

enum TransactionType {
  payment,
  tokenization,
  cancellation,
  utility,
  system,
}

enum TransactionStatus {
  pending,
  success,
  failed,
}

class TransactionLog {
  final String id;
  final DateTime timestamp;
  final TransactionType type;
  final TransactionStatus status;
  final double? amount;
  final String? currency;
  final String message;
  final String? response;
  final String? errorCode;

  TransactionLog({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.status,
    this.amount,
    this.currency,
    required this.message,
    this.response,
    this.errorCode,
  });

  TransactionLog copyWith({
    String? id,
    DateTime? timestamp,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    String? currency,
    String? message,
    String? response,
    String? errorCode,
  }) {
    return TransactionLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      message: message ?? this.message,
      response: response ?? this.response,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  Color get statusColor {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.pending:
        return Colors.orange;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.tokenization:
        return Icons.credit_card;
      case TransactionType.cancellation:
        return Icons.cancel;
      case TransactionType.utility:
        return Icons.build;
      case TransactionType.system:
        return Icons.settings;
    }
  }

  String get typeLabel {
    switch (type) {
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.tokenization:
        return 'Tokenization';
      case TransactionType.cancellation:
        return 'Cancellation';
      case TransactionType.utility:
        return 'Utility';
      case TransactionType.system:
        return 'System';
    }
  }

  String get statusLabel {
    switch (status) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.pending:
        return 'Pending';
    }
  }
}
