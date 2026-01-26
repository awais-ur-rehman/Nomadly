import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';

class MatchingRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();
  
  static const _matchingEndpoint = '/v1/matching';

  // Get Recommendations (The Deck)
  Future<List<User>> getRecommendations({int page = 1, int limit = 10}) async {
    try {
      _logger.d('🔍 [MatchingRepo] Fetching recommendations - Page: $page');
      
      final response = await _apiClient.get(
        '$_matchingEndpoint/recommendations',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      _logger.d('✅ [MatchingRepo] Recommendations response: ${response.statusCode}');
      _logger.d('📦 [MatchingRepo] Raw Response: ${response.data}'); // Added debug log

      if (response.statusCode == 200) {
        final data = response.data['data'];
        
        // Handle both direct array or wrapped in 'users' object (defensive programming)
        List<dynamic> usersJson = [];
        if (data is List) {
          usersJson = data;
        } else if (data['users'] != null) {
          usersJson = data['users'];
        }

        _logger.d('📦 [MatchingRepo] Parsed ${usersJson.length} users from response');
        
        return usersJson.map((json) {
          try {
            return User.fromJson(json);
          } catch (e) {
            _logger.e('❌ [MatchingRepo] Error parsing user: $e');
            // Return a partial user or handle gracefully
            // For now, rethrowing to see in logs which user failed
            rethrow; 
          }
        }).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Get recommendations error: ${e.message}');
      if (e.response != null) {
        _logger.e('❌ [MatchingRepo] API Error Response: ${e.response?.data}');
      }
      throw _handleError(e);
    }
  }

  // Swipe Action
  Future<Map<String, dynamic>> swipeUser({
    required String targetUserId,
    required String action, // 'like', 'pass', 'super_like'
  }) async {
    try {
      _logger.d('Pw [MatchingRepo] Swiping $action on user: $targetUserId');
      
      final response = await _apiClient.post(
        '$_matchingEndpoint/swipe',
        data: {
          'targetUserId': targetUserId,
          'action': action,
        },
      );

      _logger.d('✅ [MatchingRepo] Swipe response: ${response.statusCode}');
      _logger.d('📦 [MatchingRepo] Swipe Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'isMatch': data['isMatch'] ?? false,
          'match': data['match'], // Will be null if no match
        };
      }
      throw Exception('Failed to swipe');
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Swipe error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get Matches
  Future<List<Map<String, dynamic>>> getMatches() async {
    try {
      _logger.d('🔍 [MatchingRepo] Fetching matches');
      
      final response = await _apiClient.get('$_matchingEndpoint/matches');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> matchesJson = data['matches'] ?? [];
        
        _logger.d('✅ [MatchingRepo] Found ${matchesJson.length} matches');
        
        return matchesJson.cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Get matches error: ${e.message}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
    }
    return 'An unexpected error occurred.';
  }
}
