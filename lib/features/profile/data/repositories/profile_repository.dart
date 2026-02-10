import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';

class ProfileRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get user profile by ID
  Future<User> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/$userId',
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      _logger.e('Get user profile error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Update current user profile (PATCH /api/v1/users/me)
  Future<User> updateProfile({
    bool? isPrivate,
    Map<String, dynamic>? profileData,
    Map<String, dynamic>? rigData,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (isPrivate != null) data['is_private'] = isPrivate;
      if (profileData != null) data['profile'] = profileData;
      if (rigData != null) data['rig'] = rigData;

      final response = await _apiClient.patch(
        '${AppConfig.usersEndpoint}/me',
        data: data,
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to update profile');
    } on DioException catch (e) {
      _logger.e('Update profile error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Follow user (POST /api/v1/users/:userId/follow)
  Future<String> followUser(String userId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.usersEndpoint}/$userId/follow',
      );

      if (response.statusCode == 200) {
        // Returns "active" or "pending" for private accounts
        return response.data['data']['followStatus'] as String;
      }

      throw Exception('Failed to follow user');
    } on DioException catch (e) {
      _logger.e('Follow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Unfollow user (DELETE /api/v1/users/:userId/follow)
  Future<void> unfollowUser(String userId) async {
    try {
      final response = await _apiClient.delete(
        '${AppConfig.usersEndpoint}/$userId/follow',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unfollow user');
      }
    } on DioException catch (e) {
      _logger.e('Unfollow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get followers (GET /api/v1/users/:userId/followers)
  Future<List<User>> getFollowers(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/$userId/followers',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => User.fromJson(json)).toList();
      }

      throw Exception('Failed to load followers');
    } on DioException catch (e) {
      _logger.e('Get followers error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get following (GET /api/v1/users/:userId/following)
  Future<List<User>> getFollowing(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/$userId/following',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => User.fromJson(json)).toList();
      }

      throw Exception('Failed to load following');
    } on DioException catch (e) {
      _logger.e('Get following error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Vouch for user (POST /api/v1/vouch/:userId)
  Future<void> vouchForUser(String userId) async {
    try {
      await _apiClient.post('${AppConfig.vouchEndpoint}/$userId');
    } on DioException catch (e) {
      _logger.e('Vouch error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get received vouches (GET /api/v1/vouch/received)
  Future<List<dynamic>> getReceivedVouches() async {
    try {
      final response = await _apiClient.get('${AppConfig.vouchEndpoint}/received');
      if (response.statusCode == 200) {
        return response.data['data'] ?? [];
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get vouches error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get travelers nearby (GET /api/v1/search/travelers -> mapped to users endpoint in backend)
  // Wait, backend route is /api/v1/users/travelers
  Future<List<User>> getTravelers({
    required double lat,
    required double lng,
    double radiusKm = 50.0,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/travelers',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'radius': radiusKm * 1000, // Convert to meters
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get travelers error: ${e.message}');
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

