import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';

class AiRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  Future<Map<String, dynamic>> sendMessage(
    String message, {
    List<Map<String, String>>? history,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.aiEndpoint}/chat',
        data: {
          'message': message,
          if (history != null && history.isNotEmpty) 'history': history,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Backend returns { status: 'success', data: { response: '...', usage: {...} } }
        return response.data['data'];
      }
      
      throw Exception('Failed to get response');
    } on DioException catch (e) {
      _logger.e('AI Chat error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Fetches the current AI quota without consuming a credit.
  Future<Map<String, dynamic>> fetchQuota() async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.aiEndpoint}/quota',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data']['usage'];
      }
      
      throw Exception('Failed to fetch quota');
    } on DioException catch (e) {
      _logger.e('AI Quota error: ${e.message}');
      // Return default free-tier values on error
      return {'remaining': 5, 'limit': 5, 'isPremium': false};
    }
  }

  String _handleError(DioException error) {
      if (error.response != null) {
          final data = error.response!.data;
          if (data is Map && data.containsKey('message')) {
              return data['message'];
          }
      }
      return 'Something went wrong. Please try again.';
  }
}
