import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool pushEnabled = true;
  bool emailEnabled = true;
  bool orderUpdates = true;
  bool promotions = false;
  bool messages = true;
  bool paymentAlerts = true;

  Widget _buildPreferenceSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
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
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Notification Preferences',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreferenceSwitch(
                title: 'Push Notifications',
                subtitle: 'Receive push notifications on your device',
                value: pushEnabled,
                onChanged: (value) {
                  setState(() {
                    pushEnabled = value;
                  });
                },
              ),
              const Divider(),
              _buildPreferenceSwitch(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: emailEnabled,
                onChanged: (value) {
                  setState(() {
                    emailEnabled = value;
                  });
                },
              ),
              const Divider(),
              _buildPreferenceSwitch(
                title: 'Order Updates',
                subtitle: 'Get notified about your order status',
                value: orderUpdates,
                onChanged: (value) {
                  setState(() {
                    orderUpdates = value;
                  });
                },
              ),
              const Divider(),
              _buildPreferenceSwitch(
                title: 'Messages',
                subtitle: 'Get notified when you receive new messages',
                value: messages,
                onChanged: (value) {
                  setState(() {
                    messages = value;
                  });
                },
              ),
              const Divider(),
              _buildPreferenceSwitch(
                title: 'Payment Alerts',
                subtitle: 'Get notified about payment activities',
                value: paymentAlerts,
                onChanged: (value) {
                  setState(() {
                    paymentAlerts = value;
                  });
                },
              ),
              const Divider(),
              _buildPreferenceSwitch(
                title: 'Promotions',
                subtitle: 'Receive updates about promotions and offers',
                value: promotions,
                onChanged: (value) {
                  setState(() {
                    promotions = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}