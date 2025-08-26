import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return NotificationItem(notification: notification);
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationItem({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withOpacity(0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification['read'] 
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getNotificationIcon(notification['type']),
              color: notification['read']
                  ? AppColors.primary
                  : AppColors.surface,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification['time'],
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.local_shipping_outlined;
      case 'payment':
        return Icons.payment_outlined;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }
}

// Mock data for notifications
final List<Map<String, dynamic>> mockNotifications = [
  {
    'type': 'order',
    'title': 'Order Completed',
    'message': 'Your order #1234 has been delivered successfully.',
    'time': '2 minutes ago',
    'read': false,
  },
  {
    'type': 'payment',
    'title': 'Payment Successful',
    'message': 'Payment of \$50.00 has been processed successfully.',
    'time': '1 hour ago',
    'read': true,
  },
  {
    'type': 'promotion',
    'title': 'Special Offer',
    'message': 'Get 20% off on your next ride! Use code RIDE20.',
    'time': '3 hours ago',
    'read': true,
  },
  {
    'type': 'system',
    'title': 'System Update',
    'message': 'App updated to version 2.0. Check out new features!',
    'time': '1 day ago',
    'read': true,
  },
];
