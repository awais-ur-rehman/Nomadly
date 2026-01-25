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
}

// Provider
final userProfileProvider = StateNotifierProvider.autoDispose<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UserProfileNotifier(repository);
});
