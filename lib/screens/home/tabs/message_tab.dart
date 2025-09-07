import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/chat_model.dart';
import '../../chat/chat_detail_screen.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppAuthProvider>().user;

    if (user == null) {
      return const Center(
        child: Text('Please sign in to view messages'),
      );
    }

    // TODO: Replace this with actual chat data from Firestore
    final mockChats = [
      ChatModel(
        id: '1',
        otherUserId: '123',
        businessName: 'John Doe',
        lastMessage: 'Hello, is my order ready?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        otherUserAvatar: 'https://placehold.co/50x50',
        hasUnread: true,
        orderId: 'order123',
      ),
      ChatModel(
        id: '2',
        otherUserId: '456',
        businessName: 'Jane Smith',
        lastMessage: 'Your delivery is on the way',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        otherUserAvatar: 'https://placehold.co/50x50',
        hasUnread: false,
        orderId: 'order456',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: mockChats.isEmpty
          ? const Center(
              child: Text('No messages yet'),
            )
          : ListView.builder(
              itemCount: mockChats.length,
              itemBuilder: (context, index) {
                return _ChatItem(chat: mockChats[index]);
              },
            ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final ChatModel chat;

  const _ChatItem({
    required this.chat,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              chatId: chat.id,
              otherUserId: chat.otherUserId,
              businessName: chat.businessName,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: chat.hasUnread ? Colors.blue.withOpacity(0.1) : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(chat.otherUserAvatar),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTime(chat.lastMessageTime),
                        style: TextStyle(
                          color: chat.hasUnread ? AppColors.primary : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: chat.hasUnread ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}