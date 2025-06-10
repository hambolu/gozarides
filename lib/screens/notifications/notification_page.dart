import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'All';

  void _onFilterTap(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF212121),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Filter tabs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _onFilterTap('All'),
                      child: _buildFilterTab('All', selectedFilter == 'All'),
                    ),
                    GestureDetector(
                      onTap: () => _onFilterTap('Orders'),
                      child: _buildFilterTab('Orders', selectedFilter == 'Orders'),
                    ),
                    GestureDetector(
                      onTap: () => _onFilterTap('Messages'),
                      child: _buildFilterTab('Messages', selectedFilter == 'Messages'),
                    ),
                    GestureDetector(
                      onTap: () => _onFilterTap('Promotions'),
                      child: _buildFilterTab('Promotions', selectedFilter == 'Promotions'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Notification items
              _buildNotificationItem(
                'New feature unlocked!',
                'You can now track your order',
                '20mins ago',
              ),
              _buildNotificationItem(
                'New message from TechGuru',
                'Hey, your order is ready!',
                '1h ago',
              ),
              _buildNotificationItem(
                'Order picked up',
                'Order #1234567 has been picked up',
                '2h ago',
              ),
              _buildNotificationItem(
                'Order Delivered',
                'Your order has been delivered successfully',
                '2days ago',
              ),
              _buildNotificationItem(
                'Customer Appreciation',
                'We appreciate you! Stay tuned for exciting updates',
                '2days ago',
              ),
              _buildNotificationItem(
                'New message from Alice',
                'Your order has been dispatched',
                '3days ago',
              ),
              _buildNotificationItem(
                'Refund request',
                'Your refund request for order #125796 has been processed',
                '5days ago',
              ),
              _buildNotificationItem(
                '1000 Deliveries and still counting',
                'Thanks to customers like you, reached a major...',
                '6days ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return Container(
      width: 90,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFFE63946) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? const Color(0xFFE63946) : const Color(0xFF777777),
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

  Widget _buildNotificationItem(String title, String message, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 13, right: 13),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 14,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.notifications_outlined, color: Color(0xFF212121)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
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
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}