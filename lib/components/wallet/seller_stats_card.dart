import 'package:flutter/material.dart';

class SellerStatsCard extends StatelessWidget {
  final String title;
  final double amount;
  
  const SellerStatsCard({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 193,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 17),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 5),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₦${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 20,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}