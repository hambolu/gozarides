import 'package:flutter/material.dart';
import 'transaction_enums.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final DateTime date;
  final bool isCredit;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  String get statusText {
    switch (status) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  Color get statusColor {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFF2F855A);
      case TransactionStatus.pending:
        return const Color(0xFFB7791F);
      case TransactionStatus.failed:
        return const Color(0xFFC53030);
    }
  }

  Color get statusBackgroundColor {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFFDFF5E3);
      case TransactionStatus.pending:
        return const Color(0xFFFFF8E5);
      case TransactionStatus.failed:
        return const Color(0xFFFEE2E2);
    }
  }

  String get title {
    switch (type) {
      case TransactionType.withdrawal:
        return 'Withdrawal to Bank';
      case TransactionType.orderPayment:
        return 'Order Payment';
      case TransactionType.walletFunding:
        return 'Wallet Funding';
      case TransactionType.orderPaymentReceived:
        return 'Order Payment Received';
      case TransactionType.refund:
        return 'Order Payment Refund';
    }
  }

  String get formattedAmount => '${isCredit ? '+' : '-'}₦${amount.toStringAsFixed(2)}';

  String get formattedDate => '${_formatDate(date)} • ${_formatTime(date)}';

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute$period';
  }
}