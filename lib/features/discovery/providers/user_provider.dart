import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/user_repository.dart';
import '../../auth/providers/auth_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

class UserSearchState {
  final List<User> results;
  final bool isLoading;
  final String? error;

  UserSearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  UserSearchState copyWith({
    List<User>? results,
    bool? isLoading,
    String? error,
  }) {
    return UserSearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserSearchNotifier extends StateNotifier<UserSearchState> {
  final UserRepository _repository;
  final Ref _ref;
  final Logger _logger = Logger();

  UserSearchNotifier(this._repository, this._ref) : super(UserSearchState());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = UserSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final results = await _repository.searchUsers(query);
      state = state.copyWith(isLoading: false, results: results);
    } catch (e) {
      _logger.e('Search error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFollow(String userId) async {
    final userIndex = state.results.indexWhere((u) => u.uid == userId);
    if (userIndex == -1) return;

    final user = state.results[userIndex];
    final wasFollowing = user.isFollowing;
    final wasPending = user.isFollowingPending;

    // Optimistic update
    final updatedUser = user.copyWith(
      isFollowing: !wasFollowing && !wasPending,
      isFollowingPending: false,
    );
    
    final updatedResults = [...state.results];
    updatedResults[userIndex] = updatedUser;
    state = state.copyWith(results: updatedResults);

    try {
      if (wasFollowing || wasPending) {
        // Unfollow
        await _repository.unfollowUser(userId);
      } else {
        // Follow
        final status = await _repository.followUser(userId);
        
        // Update based on response
        final finalUser = user.copyWith(
          isFollowing: status == 'active',
          isFollowingPending: status == 'pending',
        );
        updatedResults[userIndex] = finalUser;
        state = state.copyWith(results: updatedResults);
      }
    } catch (e) {
      // Revert on error
      updatedResults[userIndex] = user;
      state = state.copyWith(results: updatedResults);
      ToastService.showError('Failed to update follow status');
    }
  }

  void clear() {
    state = UserSearchState();
  }
}

final userSearchProvider = StateNotifierProvider<UserSearchNotifier, UserSearchState>((ref) {
  return UserSearchNotifier(ref.read(userRepositoryProvider), ref);
});

// User Profile State
class UserProfileState {
  final User? user;
  final List<Post> posts;
  final bool canViewPosts;
  final bool isPrivate;
  final bool isLoading;
  final String? error;

  UserProfileState({
    this.user,
    this.posts = const [],
    this.canViewPosts = true,
    this.isPrivate = false,
    this.isLoading = false,
    this.error,
  });

  UserProfileState copyWith({
    User? user,
    List<Post>? posts,
    bool? canViewPosts,
    bool? isPrivate,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      canViewPosts: canViewPosts ?? this.canViewPosts,
      isPrivate: isPrivate ?? this.isPrivate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserRepository _repository;
  final Ref _ref;
  final Logger _logger = Logger();

  UserProfileNotifier(this._repository, this._ref) : super(UserProfileState());

  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Load profile
      final user = await _repository.getUserProfile(userId);
      
      // Load posts
      final currentUserId = _ref.read(authProvider).user?.uid;
      final postsData = await _repository.getUserPosts(
        userId,
        currentUserId: currentUserId,
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
        posts: postsData['posts'] as List<Post>,
        canViewPosts: postsData['canViewPosts'] as bool,
        isPrivate: postsData['isPrivate'] as bool,
      );
    } catch (e) {
      _logger.e('Load profile error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFollow() async {
    if (state.user == null) return;

    final user = state.user!;
    final wasFollowing = user.isFollowing;
    final wasPending = user.isFollowingPending;

    // Optimistic update
    final updatedUser = user.copyWith(
      isFollowing: !wasFollowing && !wasPending,
      isFollowingPending: false,
    );
    state = state.copyWith(user: updatedUser);

    try {
      if (wasFollowing || wasPending) {
        // Unfollow
        await _repository.unfollowUser(user.uid);
        
        // If was following a private account, hide posts
        if (user.isPrivate) {
          state = state.copyWith(
            canViewPosts: false,
            posts: [],
          );
        }
      } else {
        // Follow
        final status = await _repository.followUser(user.uid);
        
        final finalUser = user.copyWith(
          isFollowing: status == 'active',
          isFollowingPending: status == 'pending',
        );
        state = state.copyWith(user: finalUser);
        
        // If following a private account and accepted, reload posts
        if (status == 'active' && user.isPrivate) {
          final currentUserId = _ref.read(authProvider).user?.uid;
          final postsData = await _repository.getUserPosts(
            user.uid,
            currentUserId: currentUserId,
          );
          state = state.copyWith(
            posts: postsData['posts'] as List<Post>,
            canViewPosts: postsData['canViewPosts'] as bool,
          );
        }
      }
    } catch (e) {
      // Revert on error
      state = state.copyWith(user: user);
      ToastService.showError('Failed to update follow status');
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier(ref.read(userRepositoryProvider), ref);
});
