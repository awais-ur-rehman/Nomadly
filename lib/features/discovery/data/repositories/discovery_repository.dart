import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/match.dart'; // Contains DiscoveryUser

class DiscoveryRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();
  
  // Discovery endpoint
  static const String _discoveryEndpoint = '/discovery';

  // Get discovery feed (GET /api/v1/discovery)
  Future<List<DiscoveryUser>> getDiscoveryFeed({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiClient.get(
        _discoveryEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
          ...?filters,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => DiscoveryUser.fromJson(json)).toList();
      }

      throw Exception('Failed to load discovery feed');
    } on DioException catch (e) {
      _logger.e('Discovery feed error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Swipe on user (POST /api/v1/discovery/swipe)
  Future<Match?> swipeUser({
    required String targetUserId,
    required String action, // 'left', 'right', 'star'
  }) async {
    try {
      final response = await _apiClient.post(
        '$_discoveryEndpoint/swipe',
        data: {
          'matched_user_id': targetUserId,
          'action': action,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        
        // Check if it's a mutual match
        if (data != null && data['isMutual'] == true) {
          return Match.fromJson(data);
        }
        return null; // Not a mutual match yet
      }
      
      return null;
    } on DioException catch (e) {
      _logger.e('Swipe error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get mutual matches (GET /api/v1/discovery/mutual)
  Future<List<Match>> getMutualMatches({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '$_discoveryEndpoint/mutual',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Match.fromJson(json)).toList();
      }

      throw Exception('Failed to load mutual matches');
    } on DioException catch (e) {
      _logger.e('Mutual matches error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Search Users (GET /api/v1/users/search)
  Future<List<dynamic>> searchUsers(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '/users/search',
        queryParameters: {'search': query, 'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is Map) {
          return data['users'] ?? [];
        } else if (data is List) {
          return data;
        }
        return [];
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Search users error: ${e.message}');
      return [];
    }
  }

  // Follow User (POST /api/v1/users/:userId/follow)
  Future<void> followUser(String userId) async {
    try {
      await _apiClient.post('/users/$userId/follow');
    } on DioException catch (e) {
      _logger.e('Follow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Unfollow User (DELETE /api/v1/users/:userId/follow)
  Future<void> unfollowUser(String userId) async {
    try {
      await _apiClient.delete('/users/$userId/follow');
    } on DioException catch (e) {
      _logger.e('Unfollow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Error handling
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

