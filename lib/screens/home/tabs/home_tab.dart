import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/colors.dart';
import '../../../screens/home/tabs/search_tab.dart';
import '../../../screens/home/tabs/message_tab.dart';
import '../../../screens/home/tabs/order_tab.dart';
import '../../../screens/notifications/notification_page.dart';
import '../../../screens/wallet/add_funds_screen.dart';
import '../../../services/auth_bloc.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 43) / 2; // Account for padding and spacing

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Welcome section with notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<AuthBloc>(
                      builder: (context, authBloc, _) => Text(
                        'Hello ${authBloc.currentUser?.name ?? ""}!',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationPage(),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: ShapeDecoration(
                              color: AppColors.error,
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Account setup notification
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 28),
                      Icon(
                        Icons.info_outline,
                        color: AppColors.text,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Finish setting up your account!',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.text,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Wallet section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: ShapeDecoration(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet Balance',
                            style: TextStyle(
                              color: AppColors.buttonText,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Consumer<AuthBloc>(
                            builder: (context, authBloc, _) {
                              final balance = authBloc.currentUser?.wallet?['balance'] ?? 0;
                              return Text(
                                '₦${balance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: AppColors.buttonText,
                                  fontSize: 26,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddFundsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 98,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: ShapeDecoration(
                            color: AppColors.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add Funds',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Action buttons grid
                Wrap(
                  spacing: 11,
                  runSpacing: 16,
                  children: [
                    _buildActionCard('Search Seller ID', const Color(0xFFEAF4FF), Icons.search, cardWidth, context),
                    _buildActionCard('Check Messages', const Color(0xFFFFF8E2), Icons.message, cardWidth, context),
                    _buildActionCard('View My Orders', const Color(0xFFE8FBF6), Icons.receipt_long, cardWidth, context),
                    _buildActionCard('Order my Ride', const Color(0xFFE8FBF6), Icons.local_taxi, cardWidth, context),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, Color backgroundColor, IconData icon, double width, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Order my Ride':
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const CreateOrderSheet(),
            );
            break;
          case 'Search Seller ID':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SearchTab(),
            ));
            break;
          case 'Check Messages':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MessageTab(),
            ));
            break;
          case 'View My Orders':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OrderTab(),
            ));
            break;
          case 'Add Funds':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddFundsScreen(),
            ));
            break;
        }
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Icon(
                icon,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}