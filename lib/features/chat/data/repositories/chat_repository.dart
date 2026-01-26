import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/conversation.dart';
import '../../../../shared/models/message.dart';

class ChatRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get all conversations
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.chatEndpoint}/conversations',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Conversation.fromJson(json)).toList();
      }

      throw Exception('Failed to load conversations');
    } on DioException catch (e) {
      _logger.e('Get conversations error: ${e.message}');
      return [];
    }
  }

  // Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId, {int page = 1}) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.chatEndpoint}/conversations/$conversationId/messages',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Message.fromJson(json)).toList();
      }

      throw Exception('Failed to load messages');
    } on DioException catch (e) {
      _logger.e('Get messages error: ${e.message}');
      return [];
    }
  }

  // Send message
  Future<Message> sendMessage({
    required String conversationId,
    required String message,
    String type = 'text',
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.chatEndpoint}/conversations/$conversationId/messages',
        data: {
          'message': message,
          'type': type,
        },
      );

      if (response.statusCode == 201) {
        return Message.fromJson(response.data['data']);
      }

      throw Exception('Failed to send message');
    } on DioException catch (e) {
      _logger.e('Send message error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Create conversation (or get existing)
  Future<Conversation> createConversation(String targetUserId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.chatEndpoint}/conversations',
        data: {'targetUserId': targetUserId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Conversation.fromJson(response.data['data']);
      }

      throw Exception('Failed to create conversation');
    } on DioException catch (e) {
      _logger.e('Create conversation error: ${e.message}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
    }
    return 'An unexpected error occurred.';
  }
}
