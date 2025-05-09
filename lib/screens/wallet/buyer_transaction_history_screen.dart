import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TransactionStatus {
  successful,
  pending,
  failed,
}

class BuyerTransactionHistoryScreen extends StatelessWidget {
  const BuyerTransactionHistoryScreen({Key? key}) : super(key: key);

  Widget _buildFilterTab({
    required String text,
    required bool isSelected,
  }) {
    return Container(
      width: 93.15,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? AppColors.primary : const Color(0xFF777777),
          ),
          borderRadius: BorderRadius.circular(8),
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

  Widget _buildTransactionItem({
    required String type,
    required String date,
    required String amount,
    required TransactionStatus status,
    required bool isDebit,
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
      width: 398,
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
            transform: isDebit ? Matrix4.rotationZ(3.14) : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Color(0xFF212121),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterTab(text: 'All', isSelected: true),
                    const SizedBox(width: 11),
                    _buildFilterTab(text: 'Payment', isSelected: false),
                    const SizedBox(width: 11),
                    _buildFilterTab(text: 'Funding', isSelected: false),
                    const SizedBox(width: 11),
                    _buildFilterTab(text: 'Refund', isSelected: false),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTransactionItem(
                    type: 'Wallet Funding',
                    date: 'Oct 10, 2025  •  3:45PM',
                    amount: '+₦15,000.00',
                    status: TransactionStatus.successful,
                    isDebit: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionItem(
                    type: 'Order Payment',
                    date: 'Oct 9, 2025  •  7:05PM',
                    amount: '-₦5,000.00',
                    status: TransactionStatus.successful,
                    isDebit: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionItem(
                    type: 'Wallet Funding',
                    date: 'Oct 9, 2025  •  10:05AM',
                    amount: '+₦10,000.00',
                    status: TransactionStatus.pending,
                    isDebit: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionItem(
                    type: 'Order Payment Refund',
                    date: 'Oct 7, 2025  •  12:45PM',
                    amount: '+₦50,000.00',
                    status: TransactionStatus.successful,
                    isDebit: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionItem(
                    type: 'Order Payment',
                    date: 'Oct 1, 2025  •  11:35PM',
                    amount: '-₦25,000.00',
                    status: TransactionStatus.failed,
                    isDebit: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}