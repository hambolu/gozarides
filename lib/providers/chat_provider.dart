import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _chats = [];
  Map<String, List<Map<String, dynamic>>> _messages = {};
  String? _selectedChatId;

  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get currentMessages => 
      _selectedChatId != null ? _messages[_selectedChatId] ?? [] : [];

  void listenToChats(String uid) {
    _firebaseService.getChats(uid).listen((QuerySnapshot snapshot) {
      _chats = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
      notifyListeners();
    });
  }

  void selectChat(String chatId) {
    _selectedChatId = chatId;
    if (_messages[chatId] == null) {
      listenToChatMessages(chatId);
    }
    notifyListeners();
  }

  void listenToChatMessages(String chatId) {
    _firebaseService
        .getChatMessages(chatId)
        .listen((QuerySnapshot snapshot) {
      _messages[chatId] = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    try {
      await _firebaseService.sendMessage(chatId, message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(String chatId) async {
    try {
      await _firebaseService.markChatAsRead(chatId);
    } catch (e) {
      rethrow;
    }
  }
}
