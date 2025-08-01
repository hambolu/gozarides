import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../theme/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = 'All';

  void _onFilterTap(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required String type,
    bool isRead = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForType(type),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
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

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.payment_outlined;
      case 'message':
        return Icons.chat_bubble_outline;
      case 'promo':
        return Icons.local_offer_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Stream<QuerySnapshot> _getNotificationsStream() {
    final user = context.read<AuthProvider>().firebaseUser;
    if (user == null) return const Stream.empty();

    var query = FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    if (selectedFilter != 'All') {
      query = query.where('type', isEqualTo: selectedFilter.toLowerCase());
    }

    return query.snapshots();
  }

  void _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      if (token != null) {
        final user = context.read<AuthProvider>().firebaseUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'fcmToken': token});
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _onFilterTap('All'),
                  child: _buildFilterTab('All', selectedFilter == 'All'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _onFilterTap('Orders'),
                  child: _buildFilterTab('Orders', selectedFilter == 'Orders'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _onFilterTap('Messages'),
                  child: _buildFilterTab('Messages', selectedFilter == 'Messages'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _onFilterTap('Promo'),
                  child: _buildFilterTab('Promo', selectedFilter == 'Promo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Notification list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getNotificationsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading notifications: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }

                final notifications = snapshot.data?.docs ?? [];
                
                if (notifications.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index].data() as Map<String, dynamic>;
                    final timestamp = notification['createdAt'] as Timestamp;
                    final now = DateTime.now();
                    final difference = now.difference(timestamp.toDate());
                    
                    String timeAgo;
                    if (difference.inMinutes < 60) {
                      timeAgo = '${difference.inMinutes}m ago';
                    } else if (difference.inHours < 24) {
                      timeAgo = '${difference.inHours}h ago';
                    } else if (difference.inDays < 7) {
                      timeAgo = '${difference.inDays}d ago';
                    } else {
                      timeAgo = timestamp.toDate().toString().substring(0, 10);
                    }

                    return _buildNotificationItem(
                      title: notification['title'] as String,
                      message: notification['message'] as String,
                      time: timeAgo,
                      type: notification['type'] as String,
                      isRead: notification['isRead'] as bool? ?? false,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
