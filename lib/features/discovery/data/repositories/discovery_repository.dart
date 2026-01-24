import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/match.dart'; // Contains DiscoveryUser

class DiscoveryRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get discovery feed
  Future<List<DiscoveryUser>> getDiscoveryFeed({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/discovery',
        queryParameters: {
          'page': page,
          'limit': limit,
          ...?filters,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => DiscoveryUser.fromJson(json)).toList();
      }

      throw Exception('Failed to load discovery feed');
    } on DioException catch (e) {
      _logger.e('Discovery feed error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Swipe Left/Right/Star
  Future<Match?> swipeUser({
    required String targetUserId,
    required String action, // 'left', 'right', 'star'
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.matchesEndpoint}/swipe',
        data: {
          'targetUserId': targetUserId,
          'action': action,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        
        // Check if it's a match (data might be the Match object directly or inside response)
        // Adjust based on exact API response structure. Assuming standard 'data' envelope.
        if (data != null && data['isMutual'] == true) {
             return Match.fromJson(data);
        }
        return null; // Not a mutual match yet
      }
      
      return null;
    } on DioException catch (e) {
       _logger.e('Swipe error: ${e.message}');
       // Don't throw for swipes, just log and return null to keep UX smooth? 
       // Better to let provider handle UI feedback if needed.
       throw _handleError(e);
    }
  }

  // Error handling (reuse from AuthRepository or create shared mixin/util)
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
