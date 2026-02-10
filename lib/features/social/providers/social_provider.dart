import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/social_repository.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) => SocialRepository());

class SocialState {
  final List<Post> posts;
  final List<StoryBundle> stories;
  final bool isLoading;
  final String? error;

  SocialState({
    this.posts = const [],
    this.stories = const [],
    this.isLoading = false,
    this.error,
  });

  SocialState copyWith({
    List<Post>? posts,
    List<StoryBundle>? stories,
    bool? isLoading,
    String? error,
  }) {
    return SocialState(
      posts: posts ?? this.posts,
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SocialNotifier extends StateNotifier<SocialState> {
  final SocialRepository _repository;
  final Ref _ref;
  final Logger _logger = Logger();

  SocialNotifier(this._repository, this._ref) : super(SocialState()) {
    loadFeed();
  }

  Future<void> loadFeed({bool refresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // _logger.i('Loading feed...');
      
      // Get current user ID for like state calculation
      final currentUserId = _ref.read(authProvider).user?.uid;
      
      final posts = await _repository.getHomeFeed(currentUserId: currentUserId);
      // _logger.i('Posts loaded: ${posts.length}');
      
      final stories = await _repository.getActiveStories();
      // _logger.i('Stories loaded: ${stories.length}');

      state = state.copyWith(
        isLoading: false,
        posts: posts,
        stories: stories,
      );
      // _logger.i('Feed state updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error loading feed: $e', error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleLike(String postId) async {
    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final currentUserId = _ref.read(authProvider).user?.uid;
    if (currentUserId == null) return;
    
    final isLiked = post.isLikedByMe;
    
    // Optimistic update with actual user ID
    final updatedLikes = isLiked 
        ? post.likes.where((id) => id != currentUserId).toList()
        : [...post.likes, currentUserId];
    
    final updatedPost = post.copyWith(
      isLikedByMe: !isLiked,
      likes: updatedLikes,
    );
    
    final updatedPosts = [...state.posts];
    updatedPosts[postIndex] = updatedPost;
    state = state.copyWith(posts: updatedPosts);

    try {
      await _repository.toggleLike(postId);
      // Don't reload feed automatically to avoid rate limiting
      // User can pull-to-refresh if they want updated data
    } catch (e) {
      // Revert on error
      updatedPosts[postIndex] = post;
      state = state.copyWith(posts: updatedPosts);
      ToastService.showError('Failed to like post');
    }
  }

  Future<void> createPost(String content, {List<String> photos = const []}) async {
    try {
      // _logger.i('Creating post...');
      await _repository.createPost(caption: content, photos: photos);
      // _logger.i('Post created, reloading feed...');
      await loadFeed(refresh: true);
      // _logger.i('Feed reloaded after post creation');
    } catch (e, stackTrace) {
      _logger.e('Error creating post: $e', error: e, stackTrace: stackTrace);
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> addComment(String postId, String content) async {
    try {
       await _repository.addComment(postId, content);
       // Ideally refresh post or update local state
       await loadFeed(); // Simple refresh for now
    } catch (e) {
       rethrow;
    }
  }

  Future<void> createStory(String assetUrl, {required String type}) async {
    try {
      // _logger.i('Creating story...');
      await _repository.createStory(assetUrl, type);
      // _logger.i('Story created, reloading feed...');
      await loadFeed(refresh: true);
      // _logger.i('Feed reloaded after story creation');
    } catch (e, stackTrace) {
      _logger.e('Error creating story: $e', error: e, stackTrace: stackTrace);
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _repository.deletePost(postId);
      state = state.copyWith(
        posts: state.posts.where((p) => p.id != postId).toList(),
      );
    } catch (e, stackTrace) {
      _logger.e('Error deleting post: $e', error: e, stackTrace: stackTrace);
      state = state.copyWith(error: e.toString());
    }
  }
}

final socialProvider = StateNotifierProvider<SocialNotifier, SocialState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return SocialNotifier(repository, ref);
});
