import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all chats for current user
  Stream<List<Map<String, dynamic>>> getChats() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _database.ref('chats').child(user.uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      List<Map<String, dynamic>> chats = [];
      data.forEach((key, value) {
        if (value is Map) {
          chats.add({
            'chatId': key,
            'userId': user.uid,
            'otherUserId': value['otherUserId'] as String,
            'lastMessage': value['lastMessage'] as String,
            'lastMessageTime': value['lastMessageTime'] as String,
            'unreadCount': value['unreadCount'] ?? 0,
          });
        }
      });

      return chats;
    });
  }

  // Get messages for a specific chat
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _database
        .ref('messages')
        .child(chatId)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      List<Map<String, dynamic>> messages = [];
      data.forEach((key, value) {
        if (value is Map) {
          messages.add({
            'messageId': key,
            'senderId': value['senderId'] as String,
            'content': value['content'] as String,
            'timestamp': value['timestamp'] as String,
            'isRead': value['isRead'] ?? false,
          });
        }
      });

      messages.sort((a, b) => 
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp']))
      );
      return messages;
    });
  }

  // Send a message
  Future<void> sendMessage(String chatId, String content) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final messageRef = _database.ref('messages').child(chatId).push();
    final timestamp = DateTime.now().toIso8601String();

    await messageRef.set({
      'senderId': user.uid,
      'content': content,
      'timestamp': timestamp,
      'isRead': false,
    });

    // Update last message in chat
    await _database.ref('chats')
      .child(user.uid)
      .child(chatId)
      .update({
        'lastMessage': content,
        'lastMessageTime': timestamp,
      });
  }

  // Create a new chat or get existing chat with a seller
  Future<String> createOrGetChat(String sellerId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Check if chat already exists
    final chatsSnapshot = await _database
        .ref('chats')
        .child(user.uid)
        .orderByChild('otherUserId')
        .equalTo(sellerId)
        .get();

    if (chatsSnapshot.exists && chatsSnapshot.value != null) {
      final data = chatsSnapshot.value as Map<dynamic, dynamic>;
      return data.keys.first as String;
    }

    // Get seller details from Firestore
    final sellerDoc = await _firestore.collection('users').doc(sellerId).get();
    if (!sellerDoc.exists) {
      throw Exception('Seller not found');
    }

    // Create new chat
    final chatId = _database.ref('chats').push().key!;
    final timestamp = DateTime.now().toIso8601String();

    // Add chat to both users
    await _database.ref('chats').child(user.uid).child(chatId).set({
      'otherUserId': sellerId,
      'lastMessage': '',
      'lastMessageTime': timestamp,
      'unreadCount': 0,
    });

    await _database.ref('chats').child(sellerId).child(chatId).set({
      'otherUserId': user.uid,
      'lastMessage': '',
      'lastMessageTime': timestamp,
      'unreadCount': 0,
    });

    return chatId;
  }

  // Mark all messages in a chat as read
  Future<void> markChatAsRead(String chatId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _database.ref('chats')
        .child(user.uid)
        .child(chatId)
        .update({'unreadCount': 0});

    final messages = await _database.ref('messages')
        .child(chatId)
        .orderByChild('isRead')
        .equalTo(false)
        .get();

    if (messages.exists && messages.value != null) {
      final data = messages.value as Map<dynamic, dynamic>;
      final batch = _database.ref('messages').child(chatId);
      
      for (var key in data.keys) {
        await batch.child(key).update({'isRead': true});
      }
    }
  }
}
