import 'package:flutter/material.dart';
import 'package:gozarides/models/transaction_enums.dart';
import '../../models/transaction_model.dart';
import '../../components/wallet/wallet_balance_card.dart';
import '../../components/wallet/transaction_item.dart';
import '../../components/wallet/seller_stats_card.dart';
import 'withdraw_screen.dart';

class SellerWalletScreen extends StatelessWidget {
  final List<TransactionModel> transactions = [
    TransactionModel(
      id: '1',
      type: TransactionType.orderPaymentReceived,
      status: TransactionStatus.successful,
      amount: 15000,
      date: DateTime(2025, 10, 10, 15, 45),
      isCredit: true,
    ),
    TransactionModel(
      id: '2',
      type: TransactionType.withdrawal,
      status: TransactionStatus.pending,
      amount: 5000,
      date: DateTime(2025, 10, 9, 19, 5),
      isCredit: false,
    ),
    TransactionModel(
      id: '3',
      type: TransactionType.withdrawal,
      status: TransactionStatus.successful,
      amount: 10000,
      date: DateTime(2025, 10, 9, 10, 5),
      isCredit: false,
    ),
    TransactionModel(
      id: '4',
      type: TransactionType.orderPaymentReceived,
      status: TransactionStatus.successful,
      amount: 50000,
      date: DateTime(2025, 10, 7, 12, 45),
      isCredit: true,
    ),
    TransactionModel(
      id: '5',
      type: TransactionType.withdrawal,
      status: TransactionStatus.failed,
      amount: 25000,
      date: DateTime(2025, 10, 1, 23, 35),
      isCredit: false,
    ),
  ];

  SellerWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEAEAEA),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              WalletBalanceCard(
                balance: 10000,
                actionButtonText: 'Withdraw',
                actionIcon: Icons.account_balance_wallet,
                onActionPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WithdrawScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: SellerStatsCard(
                      title: 'Total Earning',
                      amount: 50000,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: SellerStatsCard(
                      title: 'Pending Payout',
                      amount: 50000,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transaction',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to transaction history
                    },
                    child: Row(
                      children: const [
                        Text(
                          'View all',
                          style: TextStyle(
                            color: Color(0xFFE63946),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xFFE63946),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...transactions.map((transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TransactionItem(transaction: transaction),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}