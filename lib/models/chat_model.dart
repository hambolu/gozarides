class ChatModel {
  final String chatId;
  final String otherUserId;
  final String businessName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String sellerAvatar;
  final bool hasUnread;

  ChatModel({
    required this.chatId,
    required this.otherUserId,
    required this.businessName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.sellerAvatar,
    required this.hasUnread,
  });

  factory ChatModel.fromMap(Map<String, dynamic> chatData, Map<String, dynamic> userData) {
    return ChatModel(
      chatId: chatData['chatId'] as String,
      otherUserId: chatData['otherUserId'] as String,
      businessName: userData['businessName'] ?? userData['name'] ?? 'Unknown User',
      lastMessage: chatData['lastMessage'] as String,
      lastMessageTime: DateTime.parse(chatData['lastMessageTime']),
      sellerAvatar: userData['photoUrl'] ?? 'https://placehold.co/50x50',
      hasUnread: chatData['unreadCount'] > 0,
    );
  }
}
