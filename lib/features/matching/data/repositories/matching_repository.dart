import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/recommended_user.dart';

class MatchingRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();
  
  static const _matchingEndpoint = '/v1/matching';

  // Get Recommendations (The Deck)
  Future<List<RecommendedUser>> getRecommendations({
    int page = 1,
    int limit = 10,
    String mode = 'both', // 'friends', 'dating', 'both'
  }) async {
    try {
      _logger.d('[MatchingRepo] Fetching recommendations - page: $page, mode: $mode');

      final response = await _apiClient.get(
        '$_matchingEndpoint/recommendations',
        queryParameters: {
          'page': page,
          'limit': limit,
          'mode': mode,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        // Handle both direct array or wrapped in 'users' object
        List<dynamic> usersJson = [];
        if (data is List) {
          usersJson = data;
        } else if (data is Map && data['users'] != null) {
          usersJson = data['users'] as List<dynamic>;
        }

        _logger.d('[MatchingRepo] Parsed ${usersJson.length} recommendations');

        return usersJson
            .map((json) => RecommendedUser.fromRecommendationJson(
                Map<String, dynamic>.from(json)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('[MatchingRepo] Get recommendations error: ${e.message}');
      if (e.response != null) {
        _logger.e('[MatchingRepo] API error response: ${e.response?.data}');
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

  // Update Matching Preferences
  Future<void> updateMatchingPreferences(int maxDistanceKm) async {
    try {
      _logger.d('⚙️ [MatchingRepo] Updating distance to $maxDistanceKm km');

      // 1. Fetch current profile first to avoid overwriting other fields
      final meResponse = await _apiClient.get('/v1/users/me');
      if (meResponse.statusCode != 200) throw Exception('Failed to fetch user profile');
      
      final userData = meResponse.data['data'];
      final Map<String, dynamic> matchingProfile = 
          userData['matching_profile'] != null 
          ? Map<String, dynamic>.from(userData['matching_profile'])
          : {};
          
      // Ensure nested structure exists
      if (!matchingProfile.containsKey('preferences')) {
        matchingProfile['preferences'] = {};
      }
      final preferences = Map<String, dynamic>.from(matchingProfile['preferences']);
      
      // Update value
      preferences['max_distance_km'] = maxDistanceKm;
      matchingProfile['preferences'] = preferences;

      _logger.d('⚙️ [MatchingRepo] Sending full update: $matchingProfile');

      // 2. Send full nested object
      final response = await _apiClient.patch(
        '/v1/users/me',
        data: {
          'matching_profile': matchingProfile,
        },
      );

      if (response.statusCode == 200) {
        _logger.d('✅ [MatchingRepo] Preferences updated successfully');
        return;
      }
      throw Exception('Failed to update preferences');
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Update preferences error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Caravan Joining
  Future<void> requestJoinCaravan(String targetUserId) async {
    try {
      await _apiClient.post(
        '$_matchingEndpoint/caravan/request',
        data: {'targetUserId': targetUserId},
      );
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Request join caravan error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getCaravanRequests(String type) async {
    try {
      final response = await _apiClient.get(
        '$_matchingEndpoint/caravan/requests',
        queryParameters: {'type': type},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> requestsJson = data['requests'] ?? [];
        return requestsJson.cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Get caravan requests error: ${e.message}');
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
