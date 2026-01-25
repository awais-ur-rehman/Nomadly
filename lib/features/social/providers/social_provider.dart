import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/social_repository.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) => SocialRepository());

class SocialState {
  final List<Post> posts;
  final List<Story> stories;
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
    List<Story>? stories,
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

  SocialNotifier(this._repository) : super(SocialState()) {
    loadFeed();
  }

  Future<void> loadFeed({bool refresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _repository.getPosts();
      final stories = await _repository.getStories();
      state = state.copyWith(
        isLoading: false,
        posts: posts,
        stories: stories,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleLike(String postId) async {
    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final isLiked = post.isLikedByMe;
    
    // Optimistic update
    final updatedPost = post.copyWith(
      isLikedByMe: !isLiked,
      likes: isLiked 
          ? post.likes.where((id) => id != 'me').toList() // Dummy 'me' ID for UI
          : [...post.likes, 'me'],
    );
    
    final updatedPosts = [...state.posts];
    updatedPosts[postIndex] = updatedPost;
    state = state.copyWith(posts: updatedPosts);

    try {
      await _repository.toggleLike(postId);
    } catch (e) {
      // Revert on error
      updatedPosts[postIndex] = post;
      state = state.copyWith(posts: updatedPosts);
      ToastService.showError('Failed to like post');
    }
  }

  Future<void> createPost(String content, {List<String>? imageUrls}) async {
    state = state.copyWith(isLoading: true);
    try {
      final newPost = await _repository.createPost(content: content, imageUrls: imageUrls);
      state = state.copyWith(
        isLoading: false,
        posts: [newPost, ...state.posts],
      );
      ToastService.showSuccess('Post created!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
    }
  }
}

final socialProvider = StateNotifierProvider<SocialNotifier, SocialState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return SocialNotifier(repository);
});
