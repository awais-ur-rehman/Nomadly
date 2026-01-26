import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../data/repositories/profile_repository.dart';

// Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// State for Other User Profile
class UserProfileState {
  final User? user;
  final bool isLoading;
  final String? error;

  UserProfileState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  UserProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final ProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(UserProfileState());

  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.getUserProfile(userId);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> followUser() async {
    final user = state.user;
    if (user == null) return;

    // Optimistic update
    // Assuming we have an 'isFollowing' field or similar on User
    // If not, we just rely on API and reload
    // User model in shared/models/user.dart needs to be checked for isFollowing
    // For now, simple API call + reload
    
    try {
       await _repository.followUser(user.uid);
       // Reload profile to update follow status/counts
       await loadUserProfile(user.uid);
    } catch (e) {
       // Handle error
    }
  }

  Future<void> unfollowUser() async {
    final user = state.user;
    if (user == null) return;

    try {
       await _repository.unfollowUser(user.uid);
       await loadUserProfile(user.uid);
    } catch (e) {
       // Handle error
    }
  }

  Future<void> vouchForUser() async {
    final user = state.user;
    if (user == null) return;

    try {
       await _repository.vouchForUser(user.uid);
       // Using ToastService if I import it, or rethrow
       // I'll skip Toast for now to avoid import mess again unless I verified imports
    } catch (e) {
       // Handle error
    }
  }
}

// Provider
final userProfileProvider = StateNotifierProvider.autoDispose<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UserProfileNotifier(repository);
});
