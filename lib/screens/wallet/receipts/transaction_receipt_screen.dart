import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';
import '../../../models/receipt_model.dart';
import '../../../components/wallet/transaction_receipt.dart';

class WalletFundingReceipt extends StatelessWidget {
  final TransactionModel transaction;

  const WalletFundingReceipt({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receipt = TransactionReceiptModel.fromTransaction(
      transactionId: transaction.id,
      amount: transaction.amount,
      dateTime: transaction.date,
      type: transaction.type,
      status: transaction.status,
      paymentMethod: 'Debit Card',
      bankOrCardProvider: 'Zenith / Mastercard',
      cardLastFourDigits: '1234',
    );

    return TransactionReceipt(
      receipt: receipt,
      onDownload: () async {
        // TODO: Implement receipt download using share_plus
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt download coming soon')),
        );
      },
      onBack: () => Navigator.pop(context),
    );
  }
}

class WithdrawalReceipt extends StatelessWidget {
  final TransactionModel transaction;

  const WithdrawalReceipt({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receipt = TransactionReceiptModel.fromTransaction(
      transactionId: transaction.id,
      amount: transaction.amount,
      dateTime: transaction.date,
      type: transaction.type,
      status: transaction.status,
      bankOrCardProvider: 'Zenith Bank',
    );

    return TransactionReceipt(
      receipt: receipt,
      onDownload: () async {
        // TODO: Implement receipt download using share_plus
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt download coming soon')),
        );
      },
      onBack: () => Navigator.pop(context),
    );
  }
}

class OrderPaymentReceipt extends StatelessWidget {
  final TransactionModel transaction;

  const OrderPaymentReceipt({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receipt = TransactionReceiptModel.fromTransaction(
      transactionId: transaction.id,
      amount: transaction.amount,
      dateTime: transaction.date,
      type: transaction.type,
      status: transaction.status,
      paymentMethod: 'Wallet Balance',
    );

    return TransactionReceipt(
      receipt: receipt,
      onDownload: () async {
        // TODO: Implement receipt download using share_plus
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt download coming soon')),
        );
      },
      onBack: () => Navigator.pop(context),
    );
  }
}

class RefundReceipt extends StatelessWidget {
  final TransactionModel transaction;

  const RefundReceipt({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receipt = TransactionReceiptModel.fromTransaction(
      transactionId: transaction.id,
      amount: transaction.amount,
      dateTime: transaction.date,
      type: transaction.type,
      status: transaction.status,
      paymentMethod: 'Wallet Balance',
    );

    return TransactionReceipt(
      receipt: receipt,
      onDownload: () async {
        // TODO: Implement receipt download using share_plus
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt download coming soon')),
        );
      },
      onBack: () => Navigator.pop(context),
    );
  }
}