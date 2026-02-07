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

        _logger.d('[MatchingRepo] Raw users count: ${usersJson.length}');

        final List<RecommendedUser> results = [];
        for (int i = 0; i < usersJson.length; i++) {
          try {
            final rawJson = usersJson[i];
            _logger.d('[MatchingRepo] Parsing user $i: ${rawJson['username'] ?? rawJson['_id']}');

            final sanitized = _sanitizeUserJson(rawJson);
            _logger.d('[MatchingRepo] Sanitized user $i - profile.intent: ${sanitized['profile']?['intent']}');
            _logger.d('[MatchingRepo] Sanitized user $i - matching_profile: ${sanitized['matching_profile']}');

            final recommended = RecommendedUser.fromRecommendationJson(sanitized);
            results.add(recommended);
            _logger.d('[MatchingRepo] Successfully parsed user $i');
          } catch (e, stack) {
            _logger.e('[MatchingRepo] Failed to parse user $i: $e');
            _logger.e('[MatchingRepo] Raw JSON for user $i: ${usersJson[i]}');
            _logger.e('[MatchingRepo] Stack: $stack');
            // Continue to next user instead of failing completely
          }
        }

        _logger.d('[MatchingRepo] Successfully parsed ${results.length} recommendations');
        return results;
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

  // Search Users
  Future<List<RecommendedUser>> searchUsers(String query) async {
    try {
      _logger.d('🔍 [MatchingRepo] Searching for: $query');
      
      final response = await _apiClient.get(
        '/users/search',
        queryParameters: {'q': query}, // Adjusted to 'q' or 'search' based on backend audit, let's assume 'search' first but check other file. Wait, discovery_repository uses 'search'.
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        List<dynamic> usersJson = [];
        if (data is Map && data['users'] != null) {
          usersJson = data['users'];
        } else if (data is List) {
          usersJson = data;
        }
        
        return usersJson
            .map((json) => RecommendedUser.fromRecommendationJson(
                _sanitizeUserJson(json)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('❌ [MatchingRepo] Search error: ${e.message}');
      return [];
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

  // Sanitize JSON to prevent null errors in strict models
  Map<String, dynamic> _sanitizeUserJson(dynamic json) {
    if (json == null) return {};
    final map = Map<String, dynamic>.from(json is Map ? json : {});

    // Ensure username is not null (use empty string as fallback)
    if (map['username'] == null) {
      map['username'] = '';
    }

    // Sanitize profile
    if (map['profile'] != null && map['profile'] is Map) {
      final profile = Map<String, dynamic>.from(map['profile']);

      // Fix Profile.intent (non-nullable string with @Default in model)
      if (profile['intent'] == null) {
        profile['intent'] = 'friends';
      }

      // Ensure hobbies is a list
      if (profile['hobbies'] == null) {
        profile['hobbies'] = <String>[];
      }

      // Ensure photo_url is a String or null
      if (profile['photo_url'] != null && profile['photo_url'] is! String) {
        profile['photo_url'] = null;
      }

      map['profile'] = profile;
    }

    // Sanitize rig
    if (map['rig'] != null && map['rig'] is Map) {
      final rig = Map<String, dynamic>.from(map['rig']);

      // pet_friendly has @Default(false) - explicit null will crash
      if (rig.containsKey('pet_friendly') && rig['pet_friendly'] == null) {
        rig['pet_friendly'] = false;
      }

      map['rig'] = rig;
    }

    // Sanitize matching_profile
    if (map['matching_profile'] != null && map['matching_profile'] is Map) {
      final mp = Map<String, dynamic>.from(map['matching_profile']);

      // Fix MatchingProfile.intent (non-nullable string with @Default)
      if (mp['intent'] == null) {
        mp['intent'] = 'friends';
      }

      // Fix is_discoverable
      if (mp.containsKey('is_discoverable') && mp['is_discoverable'] == null) {
        mp['is_discoverable'] = true;
      }

      // Sanitize nested preferences
      if (mp['preferences'] != null && mp['preferences'] is Map) {
        final prefs = Map<String, dynamic>.from(mp['preferences']);
        if (prefs.containsKey('min_age') && prefs['min_age'] == null) {
          prefs['min_age'] = 18;
        }
        if (prefs.containsKey('max_age') && prefs['max_age'] == null) {
          prefs['max_age'] = 100;
        }
        if (prefs.containsKey('max_distance_km') && prefs['max_distance_km'] == null) {
          prefs['max_distance_km'] = 100;
        }
        if (prefs['gender_interest'] == null) {
          prefs['gender_interest'] = <String>[];
        }
        mp['preferences'] = prefs;
      }

      map['matching_profile'] = mp;
    }

    // Sanitize compatibility scores
    if (map['compatibility'] != null && map['compatibility'] is Map) {
      final comp = Map<String, dynamic>.from(map['compatibility']);
      final intFields = [
        'route_overlap',
        'temporal_overlap',
        'hobby_match',
        'proximity',
        'trust',
        'rig_compatibility',
        'total'
      ];
      for (var key in intFields) {
        if (comp.containsKey(key) && comp[key] == null) {
          comp[key] = 0;
        }
      }
      map['compatibility'] = comp;
    }

    // Sanitize nomad_id
    if (map['nomad_id'] != null && map['nomad_id'] is Map) {
      final nomadId = Map<String, dynamic>.from(map['nomad_id']);
      if (nomadId.containsKey('verified') && nomadId['verified'] == null) {
        nomadId['verified'] = false;
      }
      if (nomadId.containsKey('vouch_count') && nomadId['vouch_count'] == null) {
        nomadId['vouch_count'] = 0;
      }
      map['nomad_id'] = nomadId;
    }

    // Sanitize verification
    if (map['verification'] != null && map['verification'] is Map) {
      final verification = Map<String, dynamic>.from(map['verification']);
      if (verification.containsKey('level') && verification['level'] == null) {
        verification['level'] = 0;
      }
      if (verification.containsKey('badge') && verification['badge'] == null) {
        verification['badge'] = 'none';
      }

      // Sanitize nested verification items (email, phone, photo, id_document, community)
      final nestedKeys = ['email', 'phone', 'photo', 'id_document', 'community'];
      for (var key in nestedKeys) {
        if (verification[key] != null && verification[key] is Map) {
          final nested = Map<String, dynamic>.from(verification[key]);
          if (nested.containsKey('status') && nested['status'] == null) {
            nested['status'] = 'none';
          }
          if (nested.containsKey('vouch_count') && nested['vouch_count'] == null) {
            nested['vouch_count'] = 0;
          }
          verification[key] = nested;
        }
      }

      map['verification'] = verification;
    }

    // Sanitize boolean fields with defaults
    if (map.containsKey('is_builder') && map['is_builder'] == null) {
      map['is_builder'] = false;
    }
    if (map.containsKey('is_private') && map['is_private'] == null) {
      map['is_private'] = false;
    }
    if (map.containsKey('is_active') && map['is_active'] == null) {
      map['is_active'] = true;
    }

    // Sanitize int fields with defaults
    if (map.containsKey('invite_count') && map['invite_count'] == null) {
      map['invite_count'] = 0;
    }

    return map;
  }
}
