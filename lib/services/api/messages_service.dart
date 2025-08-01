import 'api_client.dart';

class MessagesService {
  final ApiClient _apiClient;

  MessagesService(this._apiClient);

  Future<List<Map<String, dynamic>>> getChats() async {
    final response = await _apiClient.get('messages/chats');
    return List<Map<String, dynamic>>.from(response['chats']);
  }

  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    final response = await _apiClient.get('messages/chats/$chatId');
    return List<Map<String, dynamic>>.from(response['messages']);
  }

  Future<Map<String, dynamic>> sendMessage(String chatId, String message) async {
    final response = await _apiClient.post('messages/chats/$chatId', {
      'message': message,
    });

    return response;
  }
}
