import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final String actionButtonText;
  final VoidCallback onActionPressed;
  final IconData actionIcon;
  
  const WalletBalanceCard({
    Key? key,
    required this.balance,
    required this.actionButtonText,
    required this.onActionPressed,
    required this.actionIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20), // Reduced padding
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFE63946),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Text(
                    '₦${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Slightly reduced font size
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onActionPressed,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjusted padding
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(actionIcon, color: const Color(0xFFE63946), size: 20), // Reduced icon size
                      const SizedBox(height: 2), // Reduced spacing
                      Text(
                        actionButtonText,
                        style: const TextStyle(
                          color: Color(0xFFE63946),
                          fontSize: 11, // Slightly reduced font size
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}