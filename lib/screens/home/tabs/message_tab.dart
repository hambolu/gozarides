import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../models/chat_model.dart';
import '../../../services/chat_service.dart';
import '../../../theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../chat/chat_detail_screen.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().firebaseUser;
    if (currentUser == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatService().getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!;
          if (chats.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return FutureBuilder<List<ChatModel>>(
            future: _getChatModels(chats),
            builder: (context, chatModelsSnapshot) {
              if (chatModelsSnapshot.hasError) {
                return Center(child: Text('Error: ${chatModelsSnapshot.error}'));
              }

              if (!chatModelsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chatModels = chatModelsSnapshot.data!;
              return ListView.builder(
                itemCount: chatModels.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final chat = chatModels[index];
                  return _ChatListItem(chat: chat);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<ChatModel>> _getChatModels(List<Map<String, dynamic>> chats) async {
    final firestore = FirebaseFirestore.instance;
    List<ChatModel> chatModels = [];

    for (var chat in chats) {
      try {
        final userDoc = await firestore.collection('users').doc(chat['otherUserId']).get();
        if (userDoc.exists) {
          chatModels.add(ChatModel.fromMap(chat, userDoc.data()!));
        }
      } catch (e) {
        print('Error fetching user data for chat: ${e.toString()}');
      }
    }

    chatModels.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return chatModels;
  }
}

class ChatModel {
  final String sellerId;
  final String sellerName;
  final String businessName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String sellerAvatar;
  final bool hasUnread;

  ChatModel({
    required this.sellerId,
    required this.sellerName,
    required this.businessName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.sellerAvatar,
    this.hasUnread = false,
  });
}

// Mock data
final mockChats = [
  ChatModel(
    sellerId: '1',
    sellerName: 'John Doe',
    businessName: 'John\'s Electronics',
    lastMessage: 'Your order has been shipped',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    sellerAvatar: 'https://placehold.co/50x50',
    hasUnread: true,
  ),
  ChatModel(
    sellerId: '2',
    sellerName: 'Jane Smith',
    businessName: 'Fashion Hub',
    lastMessage: 'Thank you for your order',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
    sellerAvatar: 'https://placehold.co/50x50',
  ),
];

class _ChatListItem extends StatelessWidget {
  final ChatModel chat;

  const _ChatListItem({Key? key, required this.chat}) : super(key: key);

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              chatId: chat.chatId,
              otherUserId: chat.otherUserId,
              businessName: chat.businessName,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFEAEAEA),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(chat.sellerAvatar),
                ),
                if (chat.hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const ShapeDecoration(
                        color: AppColors.primary,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
              ],
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
                        chat.businessName,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTime(chat.lastMessageTime),
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
                    chat.lastMessage,
                    style: TextStyle(
                      color: chat.hasUnread ? AppColors.text : AppColors.textSecondary,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: chat.hasUnread ? FontWeight.w500 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}