import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String otherUserId;
  final String businessName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String otherUserAvatar;
  final bool hasUnread;
  final String? orderId;

  ChatModel({
    required this.id,
    required this.otherUserId,
    required this.businessName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.otherUserAvatar,
    this.hasUnread = false,
    this.orderId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> chatData, [Map<String, dynamic>? userData]) {
    return ChatModel(
      id: chatData['id'] ?? '',
      otherUserId: chatData['otherUserId'] ?? '',
      businessName: userData?['businessName'] ?? userData?['name'] ?? 'Unknown User',
      lastMessage: chatData['lastMessage'] ?? '',
      lastMessageTime: (chatData['lastMessageTime'] as Timestamp).toDate(),
      otherUserAvatar: userData?['photoUrl'] ?? 'https://placehold.co/50x50',
      hasUnread: chatData['unreadCount'] > 0,
      orderId: chatData['orderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'otherUserId': otherUserId,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': hasUnread ? 1 : 0,
      'orderId': orderId,
    };
  }
}
