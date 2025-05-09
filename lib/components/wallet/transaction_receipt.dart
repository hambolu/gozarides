import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt_model.dart';

class TransactionReceipt extends StatelessWidget {
  final TransactionReceiptModel receipt;
  final VoidCallback onDownload;
  final VoidCallback onBack;

  const TransactionReceipt({
    Key? key,
    required this.receipt,
    required this.onDownload,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // App Bar
          Container(
            width: double.infinity,
            height: 106,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  color: Color(0xFFEAEAEA),
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 60,
                  child: IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
                  ),
                ),
                const Positioned(
                  left: 112,
                  top: 60,
                  child: Text(
                    'Transaction Summary',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Success Icon and Title
          Container(
            width: 292,
            margin: const EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDFF5E3),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF2F855A),
                    size: 32,
                  ),
                ),
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

          // Amount and Transaction Details
          Container(
            width: 398,
            margin: const EdgeInsets.only(top: 48, left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Amount', '₦${receipt.amount.toStringAsFixed(2)}'),
                const SizedBox(height: 11),
                _buildDetailRow('Transaction Type', receipt.transactionType),
                const SizedBox(height: 11),
                _buildDetailRow('Status', receipt.status, isStatus: true),
              ],
            ),
          ),

          // Transaction Details
          Container(
            width: 398,
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Date & Time', 
                  DateFormat('MMMM d, y – hh:mm a').format(receipt.dateTime)
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Transaction Reference', receipt.transactionId),
                if (receipt.paymentMethod != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Payment Method', 
                    '${receipt.paymentMethod} ${receipt.cardLastFourDigits != null ? "(****${receipt.cardLastFourDigits})" : ""}'
                  ),
                ],
                if (receipt.bankOrCardProvider != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Bank / Card Provider', receipt.bankOrCardProvider!),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Download Button
          Container(
            width: 398,
            height: 56,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: OutlinedButton(
              onPressed: onDownload,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE63946)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
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
        const SizedBox(height: 4),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: value == 'Successful' 
                  ? const Color(0xFFDFF5E3)
                  : value == 'Pending'
                      ? const Color(0xFFFFF8E5)
                      : const Color(0xFFFEE2E2),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: value == 'Successful'
                    ? const Color(0xFF2F855A)
                    : value == 'Pending'
                        ? const Color(0xFFB7791F)
                        : const Color(0xFFC53030),
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}