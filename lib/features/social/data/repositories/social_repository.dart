import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/post.dart';

class SocialRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get posts feed
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.baseUrl}/api/v1/social/posts',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Post.fromJson(json)).toList();
      }
      throw Exception('Failed to load posts');
    } on DioException catch (e) {
      _logger.e('Get posts error: ${e.message}');
      return [];
    }
  }

  // Create post
  Future<Post> createPost({required String content, List<String>? imageUrls}) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.baseUrl}/api/v1/social/posts',
        data: {
          'content': content,
          if (imageUrls != null) 'imageUrls': imageUrls,
        },
      );

      if (response.statusCode == 201) {
        return Post.fromJson(response.data['data']);
      }
      throw Exception('Failed to create post');
    } on DioException catch (e) {
      _logger.e('Create post error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Like/Unlike post
  Future<void> toggleLike(String postId) async {
    try {
      await _apiClient.post('${AppConfig.baseUrl}/api/v1/social/posts/$postId/like');
    } on DioException catch (e) {
      _logger.e('Toggle like error: ${e.message}');
    }
  }

  // Get stories
  Future<List<Story>> getStories() async {
    try {
      final response = await _apiClient.get('${AppConfig.baseUrl}/api/v1/social/stories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get stories error: ${e.message}');
      return [];
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
