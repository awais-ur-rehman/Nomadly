import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../../shared/models/user.dart';
import '../data/repositories/matching_repository.dart';

// State Class
class MatchingState {
  final List<User> recommendations;
  final bool isLoading;
  final String? error;
  final bool noMoreUsers;
  final Map<String, dynamic>? newMatch; // Temporarily holds a new match to show UI

  MatchingState({
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
    this.noMoreUsers = false,
    this.newMatch,
  });

  MatchingState copyWith({
    List<User>? recommendations,
    bool? isLoading,
    String? error,
    bool? noMoreUsers,
    Map<String, dynamic>? newMatch,
  }) {
    return MatchingState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Nullable update
      noMoreUsers: noMoreUsers ?? this.noMoreUsers,
      newMatch: newMatch, // Nullable update for clearing match
    );
  }
}

// Notifier
class MatchingNotifier extends StateNotifier<MatchingState> {
  final MatchingRepository _repository;
  final _logger = Logger();

  MatchingNotifier(this._repository) : super(MatchingState());

  Future<void> loadRecommendations({bool refresh = false}) async {
    if (state.isLoading) return;
    
    // If we already have users and not refreshing, maybe load more? 
    // For now, let's keep it simple: fetch initial batch
    if (!refresh && state.recommendations.isNotEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      _logger.d('🔄 [MatchingProvider] Loading recommendations...');
      
      final users = await _repository.getRecommendations(page: 1, limit: 20); // Always page 1 of *unseen* users
      
      _logger.d('✅ [MatchingProvider] Loaded ${users.length} users');
      
      state = state.copyWith(
        isLoading: false,
        recommendations: users,
        noMoreUsers: users.isEmpty,
      );
    } catch (e) {
      _logger.e('❌ [MatchingProvider] Error loading: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> swipeUser(String userId, String action) async {
    // 1. Optimistic Update: Remove user from deck immediately
    final currentList = List<User>.from(state.recommendations);
    currentList.removeWhere((u) => u.uid == userId);
    
    state = state.copyWith(
      recommendations: currentList,
      newMatch: null, // Clear previous match info if any
    );

    // If running low on cards, fetch more?
    if (currentList.length < 3) {
      _logger.d('⚠️ [MatchingProvider] Low on cards, pre-fetching more (TODO)');
       // Ideally trigger background fetch
    }

    try {
      // 2. API Call
      _logger.d('👉 [MatchingProvider] Swiping $action on $userId');
      final result = await _repository.swipeUser(
        targetUserId: userId,
        action: action,
      );

      // 3. Handle Match
      if (result['isMatch'] == true) {
        _logger.i('🎉 [MatchingProvider] IT\'S A MATCH!');
        state = state.copyWith(newMatch: result);
      }
    } catch (e) {
      _logger.e('❌ [MatchingProvider] Swipe failed: $e');
      // Ideally revert the removal or show error toast
      // For a dating app, silent failure on "pass" is usually fine, but "like" failure hurts.
    }
  }



  // Update Max Distance Preference
  Future<void> updateDistance(int distanceKm) async {
    try {
      _logger.d('⚙️ [MatchingProvider] Updating distance to $distanceKm km');
      
      // 1. Update backend
      await _repository.updateMatchingPreferences(distanceKm);
      
      // 2. Reload deck with new settings
      await loadRecommendations(refresh: true);
      
    } catch (e) {
      _logger.e('❌ [MatchingProvider] Failed to update distance: $e');
      // Show error via state if needed, or toast
    }
  }

  void clearMatch() {
    state = state.copyWith(newMatch: null);
  }
}

// Provider
final matchingProvider = StateNotifierProvider<MatchingNotifier, MatchingState>((ref) {
  return MatchingNotifier(MatchingRepository());
});
