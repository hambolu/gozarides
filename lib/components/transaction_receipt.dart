import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/receipt_model.dart';

class TransactionReceiptWidget extends StatelessWidget {
  final TransactionReceiptModel receipt;
  
  const TransactionReceiptWidget({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFFAFAFA)),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 106,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Color(0xFFEAEAEA),
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Transaction Summary',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Receipt Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      receipt.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      receipt.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount and Status Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Amount', '₦${receipt.amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 11),
                    _buildDetailRow('Transaction Type', receipt.transactionType),
                    const SizedBox(height: 11),
                    _buildStatusRow(receipt.status),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Transaction Details Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Date & Time',
                      DateFormat('MMMM d, yyyy – hh:mm a').format(receipt.dateTime),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Transaction Reference', receipt.transactionId),
                    if (receipt.paymentMethod != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow('Payment Method', 
                        receipt.cardLastFourDigits != null 
                          ? '${receipt.paymentMethod} (****${receipt.cardLastFourDigits})'
                          : receipt.paymentMethod!
                      ),
                    ],
                    if (receipt.bankOrCardProvider != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow('Bank / Card Provider', receipt.bankOrCardProvider!),
                    ],
                  ],
                ),
              ),

              // Download Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () => _shareReceipt(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE63946)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'Download Receipt',
                    style: TextStyle(
                      color: Color(0xFFE63946),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF212121),
            fontSize: value.length > 20 ? 14 : 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'successful':
        backgroundColor = const Color(0xFFDFF5E3);
        textColor = const Color(0xFF2F855A);
        break;
      case 'pending':
        backgroundColor = const Color(0xFFFFF4DE);
        textColor = const Color(0xFFB7791F);
        break;
      case 'failed':
        backgroundColor = const Color(0xFFFFE5E5);
        textColor = const Color(0xFFE53E3E);
        break;
      default:
        backgroundColor = const Color(0xFFDFF5E3);
        textColor = const Color(0xFF2F855A);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _shareReceipt() async {
    final String receiptText = '''
Transaction Receipt
------------------
${receipt.title}
Amount: ₦${receipt.amount.toStringAsFixed(2)}
Date: ${DateFormat('MMMM d, yyyy – hh:mm a').format(receipt.dateTime)}
Transaction ID: ${receipt.transactionId}
Status: ${receipt.status}
${receipt.paymentMethod != null ? '\nPayment Method: ${receipt.paymentMethod}' : ''}
${receipt.bankOrCardProvider != null ? '\nBank/Card Provider: ${receipt.bankOrCardProvider}' : ''}
''';

    await Share.share(receiptText, subject: 'Transaction Receipt');
  }
}