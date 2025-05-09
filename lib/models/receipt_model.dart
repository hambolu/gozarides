import 'transaction_enums.dart';

class BaseTransactionReceipt {
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime dateTime;
  final String reference;
  final String? paymentMethod;
  final String? bankOrProvider;
  final String? cardLastFour;
  final String? recipientName;
  final String? description;

  BaseTransactionReceipt({
    required this.amount,
    required this.type,
    required this.status,
    required this.dateTime,
    required this.reference,
    this.paymentMethod,
    this.bankOrProvider,
    this.cardLastFour,
    this.recipientName,
    this.description,
  });
}

class TransactionReceiptModel {
  final String transactionId;
  final double amount;
  final DateTime dateTime;
  final String transactionType;
  final String status;
  final String? paymentMethod;
  final String? bankOrCardProvider;
  final String? cardLastFourDigits;
  final String title;
  final String subtitle;

  const TransactionReceiptModel({
    required this.transactionId,
    required this.amount,
    required this.dateTime,
    required this.transactionType,
    required this.status,
    this.paymentMethod,
    this.bankOrCardProvider,
    this.cardLastFourDigits,
    required this.title,
    required this.subtitle,
  });

  factory TransactionReceiptModel.fromTransaction({
    required String transactionId,
    required double amount,
    required DateTime dateTime,
    required TransactionType type,
    required TransactionStatus status,
    String? paymentMethod,
    String? bankOrCardProvider,
    String? cardLastFourDigits,
  }) {
    String title;
    String subtitle;
    String statusText = status == TransactionStatus.successful
        ? 'Successful'
        : status == TransactionStatus.pending
            ? 'Pending'
            : 'Failed';

    switch (type) {
      case TransactionType.walletFunding:
        title = 'Wallet Funding $statusText';
        subtitle = '₦${amount.toStringAsFixed(2)} has been credited to your wallet';
        break;
      case TransactionType.withdrawal:
        title = 'Withdrawal $statusText';
        subtitle = '₦${amount.toStringAsFixed(2)} has been withdrawn from your wallet';
        break;
      case TransactionType.orderPayment:
        title = 'Order Payment $statusText';
        subtitle = '₦${amount.toStringAsFixed(2)} has been deducted from your wallet';
        break;
      case TransactionType.orderPaymentReceived:
        title = 'Order Payment Received';
        subtitle = '₦${amount.toStringAsFixed(2)} has been credited to your wallet';
        break;
      case TransactionType.refund:
        title = 'Refund $statusText';
        subtitle = '₦${amount.toStringAsFixed(2)} has been refunded to your wallet';
        break;
    }

    return TransactionReceiptModel(
      transactionId: transactionId,
      amount: amount,
      dateTime: dateTime,
      transactionType: type.toString().split('.').last,
      status: statusText,
      paymentMethod: paymentMethod,
      bankOrCardProvider: bankOrCardProvider,
      cardLastFourDigits: cardLastFourDigits,
      title: title,
      subtitle: subtitle,
    );
  }
}