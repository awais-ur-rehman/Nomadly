import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/post.dart';

class UserRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();
  
  static const _usersEndpoint = '/v1/users';
  static const _feedEndpoint = '/v1/feed';

  // Search Users (GET /api/v1/users/search)
  Future<List<User>> searchUsers(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '$_usersEndpoint/search',
        queryParameters: {
          'search': query,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        // Backend returns data as an array directly, not wrapped in 'users'
        if (data is List) {
          return data.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
        }
        return [];
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Search users error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get User Profile (GET /api/v1/users/:userId)
  Future<User> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get('$_usersEndpoint/$userId');

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }
      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      _logger.e('Get user profile error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get User Posts (GET /api/v1/feed/users/:userId/posts)
  Future<Map<String, dynamic>> getUserPosts(
    String userId, {
    int page = 1,
    int limit = 20,
    String? currentUserId,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_feedEndpoint/users/$userId/posts',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> postsJson = data['posts'] ?? [];
        
        // Parse posts and calculate isLikedByMe
        final posts = <Post>[];
        for (final postJson in postsJson) {
          final postData = postJson as Map<String, dynamic>;
          
          // Calculate isLikedByMe
          final likes = (postData['likes'] as List<dynamic>?)?.cast<String>() ?? [];
          final isLikedByMe = currentUserId != null && likes.contains(currentUserId);
          postData['isLikedByMe'] = isLikedByMe;
          
          posts.add(Post.fromJson(postData));
        }

        return {
          'posts': posts,
          'canViewPosts': data['canViewPosts'] ?? true,
          'isPrivate': data['isPrivate'] ?? false,
          'total': data['pagination']?['total'] ?? 0,
        };
      }
      throw Exception('Failed to load user posts');
    } on DioException catch (e) {
      _logger.e('Get user posts error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Follow User (POST /api/v1/users/:userId/follow)
  Future<String> followUser(String userId) async {
    try {
      final response = await _apiClient.post('$_usersEndpoint/$userId/follow');

      if (response.statusCode == 200) {
        final status = response.data['data']['status'] as String;
        return status; // "active" or "pending"
      }
      throw Exception('Failed to follow user');
    } on DioException catch (e) {
      _logger.e('Follow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Unfollow User (DELETE /api/v1/users/:userId/follow)
  Future<void> unfollowUser(String userId) async {
    try {
      await _apiClient.delete('$_usersEndpoint/$userId/follow');
    } on DioException catch (e) {
      _logger.e('Unfollow user error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get Followers (GET /api/v1/users/:userId/followers)
  Future<List<User>> getFollowers(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '$_usersEndpoint/$userId/followers',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> followersJson = data['followers'] ?? [];
        return followersJson.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get followers error: ${e.message}');
      return [];
    }
  }

  // Get Following (GET /api/v1/users/:userId/following)
  Future<List<User>> getFollowing(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '$_usersEndpoint/$userId/following',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> followingJson = data['following'] ?? [];
        return followingJson.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get following error: ${e.message}');
      return [];
    }
  }

  // Get Travelers (GET /api/v1/users/travelers)
  Future<List<User>> getTravelers({
    required double lat,
    required double lng,
    double radius = 50000,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_usersEndpoint/travelers',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'radius': radius,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data['data'] ?? [];
        return usersJson.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get travelers error: ${e.message}');
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
}
