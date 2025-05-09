import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab(
                    text: 'All',
                    isSelected: true,
                  ),
                  const SizedBox(width: 11),
                  _buildFilterTab(
                    text: 'Order Payment',
                    isSelected: false,
                  ),
                  const SizedBox(width: 11),
                  _buildFilterTab(
                    text: 'Withdrawals',
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTransactionItem(
                  type: 'Order Payment Received',
                  date: 'Oct 10, 2025  •  3:45PM',
                  amount: '+₦15,000.00',
                  status: TransactionStatus.successful,
                ),
                const SizedBox(height: 12),
                _buildTransactionItem(
                  type: 'Withdrawal to Bank',
                  date: 'Oct 9, 2025  •  7:05PM',
                  amount: '-₦5,000.00',
                  status: TransactionStatus.pending,
                ),
                const SizedBox(height: 12),
                _buildTransactionItem(
                  type: 'Withdrawal to Bank',
                  date: 'Oct 9, 2025  •  10:05AM',
                  amount: '-₦10,000.00',
                  status: TransactionStatus.successful,
                ),
                const SizedBox(height: 12),
                _buildTransactionItem(
                  type: 'Order Payment Received',
                  date: 'Oct 7, 2025  •  12:45PM',
                  amount: '+₦50,000.00',
                  status: TransactionStatus.successful,
                ),
                const SizedBox(height: 12),
                _buildTransactionItem(
                  type: 'Withdrawal to Bank',
                  date: 'Oct 1, 2025  •  11:35PM',
                  amount: '-₦25,000.00',
                  status: TransactionStatus.failed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({required String text, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFFE63946) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 1,
            color: isSelected ? const Color(0xFFE63946) : const Color(0xFF777777),
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF777777),
          fontSize: 14,
          fontFamily: 'Lato',
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

enum TransactionStatus {
  successful,
  pending,
  failed,
}

Widget _buildTransactionItem({
  required String type,
  required String date,
  required String amount,
  required TransactionStatus status,
}) {
  Color getStatusColor() {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFF2F855A);
      case TransactionStatus.pending:
        return const Color(0xFFB7791F);
      case TransactionStatus.failed:
        return const Color(0xFFC53030);
    }
  }

  Color getStatusBgColor() {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFFDFF5E3);
      case TransactionStatus.pending:
        return const Color(0xFFFFF8E5);
      case TransactionStatus.failed:
        return const Color(0xFFFEE2E2);
    }
  }

  String getStatusText() {
    switch (status) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          transform: type.contains('Withdrawal') 
              ? Matrix4.rotationZ(3.14)
              : Matrix4.identity(),
          decoration: const BoxDecoration(
            // Add transaction type icon here
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 12,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 65,
              height: 18,
              decoration: ShapeDecoration(
                color: getStatusBgColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                getStatusText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: getStatusColor(),
                  fontSize: 10,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}