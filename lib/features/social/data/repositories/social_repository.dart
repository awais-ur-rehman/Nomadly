import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/models/comment.dart';
import '../../../../shared/models/user.dart';

class SocialRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();
  
  // Endpoints
  static const String _feedEndpoint = '/feed';
  static const String _storiesEndpoint = '/stories';

  // --- Posts ---

  // Get home timeline (GET /api/v1/feed)
  Future<List<Post>> getHomeFeed({int page = 1, int limit = 20, String? currentUserId}) async {
    try {
      final response = await _apiClient.get(
        _feedEndpoint,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['posts'] ?? [];
        // _logger.i('Parsing ${data.length} posts...');
        final posts = <Post>[];
        for (int i = 0; i < data.length; i++) {
          try {
            final postJson = data[i] as Map<String, dynamic>;
            
            // Calculate isLikedByMe based on current user ID
            final likes = (postJson['likes'] as List<dynamic>?)?.cast<String>() ?? [];
            final isLikedByMe = currentUserId != null && likes.contains(currentUserId);
            
            // Add isLikedByMe to the JSON before parsing
            postJson['isLikedByMe'] = isLikedByMe;
            
            final post = Post.fromJson(postJson);
            posts.add(post);
          } catch (e, stackTrace) {
            _logger.e('Error parsing post at index $i: $e', error: e, stackTrace: stackTrace);
            _logger.e('Post JSON: ${data[i]}');
          }
        }
        // _logger.i('Successfully parsed ${posts.length} out of ${data.length} posts');
        return posts;
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get feed error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Create post (POST /api/v1/feed/posts)
  Future<Post> createPost({
    List<String>? photos,
    String? caption,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiClient.post(
        '$_feedEndpoint/posts',
        data: {
          if (photos != null) 'photos': photos,
          if (caption != null) 'caption': caption,
          if (tags != null) 'tags': tags,
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

  // Delete post (DELETE /api/v1/feed/posts/:postId)
  Future<void> deletePost(String postId) async {
    try {
      await _apiClient.delete('$_feedEndpoint/posts/$postId');
    } on DioException catch (e) {
      _logger.e('Delete post error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Like/Unlike post (POST /api/v1/feed/posts/:postId/like)
  Future<void> toggleLike(String postId) async {
    try {
      await _apiClient.post('$_feedEndpoint/posts/$postId/like');
    } on DioException catch (e) {
      _logger.e('Toggle like error: ${e.message}');
      throw _handleError(e);
    }
  }
  
  // Add Comment (POST /api/v1/feed/posts/:postId/comments)
  Future<void> addComment(String postId, String text) async {
    try {
      await _apiClient.post(
        '$_feedEndpoint/posts/$postId/comments',
        data: {'text': text},
      );
    } on DioException catch (e) {
      _logger.e('Add comment error: ${e.message}');
      throw _handleError(e);
    }
  }
  
  // Get Comments (GET /api/v1/feed/posts/:postId/comments)
  Future<List<Comment>> getComments(String postId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '$_feedEndpoint/posts/$postId/comments',
        queryParameters: {'page': page, 'limit': limit},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> commentsJson = data['comments'] ?? [];
        return commentsJson.map((json) => Comment.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get comments error: ${e.message}');
      return [];
    }
  }
  
  // Get user's posts (GET /api/v1/feed/user/:userId)
  Future<List<Post>> getUserPosts(String userId) async {
    try {
      final response = await _apiClient.get('$_feedEndpoint/users/$userId/posts');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['posts'] ?? [];
        return data.map((json) => Post.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get user posts error: ${e.message}');
      return [];
    }
  }

  // --- Stories ---

  // Get active stories (GET /api/v1/stories/active)
  Future<List<StoryBundle>> getActiveStories() async {
    try {
      final response = await _apiClient.get('$_storiesEndpoint/active');
      if (response.statusCode == 200) {
        // _logger.i('Stories response: ${response.data}');
        final List<dynamic> data = response.data['data'] ?? [];
        // _logger.i('Stories data length: ${data.length}');
        return data.map((json) {
          try {
            return StoryBundle.fromJson(json);
          } catch (e) {
            _logger.e('Error parsing story bundle: $e, JSON: $json');
            rethrow;
          }
        }).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get active stories error: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Unexpected error in getActiveStories: $e');
      return [];
    }
  }
  
  // Create Story (POST /api/v1/stories)
  Future<void> createStory(String assetUrl, String type) async {
    try {
      await _apiClient.post(
        _storiesEndpoint,
        data: {
          'asset_url': assetUrl,
          'asset_type': type,
          'type': type, // backend requires 'type' as well
        },
      );
    } on DioException catch (e) {
      _logger.e('Create story error: ${e.message}');
      throw _handleError(e);
    }
  }
  
  // Get My Stories (GET /api/v1/stories/me)
  Future<List<Story>> getMyStories() async {
    try {
      final response = await _apiClient.get('$_storiesEndpoint/me');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['stories'] ?? [];
        return data.map((json) => Story.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get my stories error: ${e.message}');
      return [];
    }
  }

  // Get User Stories (GET /api/v1/stories/user/:userId)
  Future<List<Story>> getUserStories(String userId) async {
    try {
      final response = await _apiClient.get('$_storiesEndpoint/user/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['stories'] ?? response.data['data'] ?? [];
        return data.map((json) => Story.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get user stories error: ${e.message}');
      return [];
    }
  }
  
  // View Story (GET /api/v1/stories/:storyId)
  Future<void> viewStory(String storyId) async {
    try {
      await _apiClient.get('$_storiesEndpoint/$storyId');
    } on DioException catch (e) {
      _logger.e('View story error: ${e.message}');
      // Don't throw for view tracking failures
    }
  }

  // Get Story Viewers (GET /api/v1/stories/:storyId/viewers)
  Future<List<User>> getStoryViewers(String storyId) async {
    try {
      final response = await _apiClient.get('$_storiesEndpoint/$storyId/viewers');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get story viewers error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Delete Story (DELETE /api/v1/stories/:storyId)
  Future<void> deleteStory(String storyId) async {
    try {
      await _apiClient.delete('$_storiesEndpoint/$storyId');
    } on DioException catch (e) {
      _logger.e('Delete story error: ${e.message}');
      throw _handleError(e);
    }
  }
  
  // Get Single Post (GET /api/v1/feed/posts/:postId)
  Future<Post> getPost(String postId, {String? currentUserId}) async {
    try {
      final response = await _apiClient.get('$_feedEndpoint/posts/$postId');
      if (response.statusCode == 200) {
        final postJson = response.data['data'] as Map<String, dynamic>;
        
        // Calculate isLikedByMe based on current user ID
        final likes = (postJson['likes'] as List<dynamic>?)?.cast<String>() ?? [];
        final isLikedByMe = currentUserId != null && likes.contains(currentUserId);
        
        // Add isLikedByMe to the JSON before parsing
        postJson['isLikedByMe'] = isLikedByMe;
        
        return Post.fromJson(postJson);
      }
      throw Exception('Failed to load post');
    } on DioException catch (e) {
       _logger.e('Get post error: ${e.message}');
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

