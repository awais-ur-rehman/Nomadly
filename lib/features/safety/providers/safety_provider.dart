import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/safety_repository.dart';
import '../../../../shared/models/user.dart';

class SafetyState {
  final Set<String> blockedUserIds;
  final List<User> blockedUsers;
  final bool isLoading;

  const SafetyState({
    this.blockedUserIds = const {},
    this.blockedUsers = const [],
    this.isLoading = false,
  });

  SafetyState copyWith({
    Set<String>? blockedUserIds,
    List<User>? blockedUsers,
    bool? isLoading,
  }) {
    return SafetyState(
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isBlocked(String userId) => blockedUserIds.contains(userId);
}

class SafetyNotifier extends StateNotifier<SafetyState> {
  final SafetyRepository _repo;

  SafetyNotifier(this._repo) : super(const SafetyState());

  Future<void> loadBlockedUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await _repo.getBlockedUsers();
      state = state.copyWith(
        blockedUsers: users,
        blockedUserIds: users.map((u) => u.uid).toSet(),
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> blockUser(String userId) async {
    try {
      await _repo.blockUser(userId);
      state = state.copyWith(
        blockedUserIds: {...state.blockedUserIds, userId},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unblockUser(String userId) async {
    try {
      await _repo.unblockUser(userId);
      final updatedIds = Set<String>.from(state.blockedUserIds)..remove(userId);
      final updatedUsers = state.blockedUsers.where((u) => u.uid != userId).toList();
      state = state.copyWith(blockedUserIds: updatedIds, blockedUsers: updatedUsers);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> reportUser(String userId, String reason, {String? description}) async {
    try {
      await _repo.reportUser(userId, reason, description: description);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final safetyProvider = StateNotifierProvider<SafetyNotifier, SafetyState>((ref) {
  return SafetyNotifier(SafetyRepository());
});
