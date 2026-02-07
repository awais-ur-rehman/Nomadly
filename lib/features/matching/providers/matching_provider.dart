import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomadly/shared/models/recommended_user.dart';
import 'package:nomadly/features/matching/data/repositories/matching_repository.dart';
import 'package:nomadly/shared/services/toast_service.dart';

// State Class
class MatchingState {
  final List<RecommendedUser> recommendations;
  final bool isLoading;
  final String? error;
  final bool noMoreUsers;
  final String mode; // 'friends', 'dating', 'both'
  final Map<String, dynamic>? newMatch;
  final List<RecommendedUser> searchResults;
  final bool isSearching;

  MatchingState({
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
    this.noMoreUsers = false,
    this.mode = 'both',
    this.newMatch,
    this.searchResults = const [],
    this.isSearching = false,
  });

  MatchingState copyWith({
    List<RecommendedUser>? recommendations,
    bool? isLoading,
    String? error,
    bool? noMoreUsers,
    String? mode,
    Map<String, dynamic>? newMatch,
    List<RecommendedUser>? searchResults,
    bool? isSearching,
  }) {
    return MatchingState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      noMoreUsers: noMoreUsers ?? this.noMoreUsers,
      mode: mode ?? this.mode,
      newMatch: newMatch,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
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
    if (!refresh && state.recommendations.isNotEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      _logger.d('[MatchingProvider] Loading recommendations (mode: ${state.mode})...');

      final users = await _repository.getRecommendations(
        page: 1,
        limit: 20,
        mode: state.mode,
      );

      _logger.d('[MatchingProvider] Loaded ${users.length} recommendations');

      state = state.copyWith(
        isLoading: false,
        recommendations: users,
        noMoreUsers: users.isEmpty,
      );
    } catch (e, stackTrace) {
      _logger.e('[MatchingProvider] Error loading: $e');
      _logger.e('[MatchingProvider] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> swipeUser(String userId, String action) async {
    // 1. Optimistic Update: REMOVED to prevent CardSwiper index issues. 
    // The UI (CardSwiper) handles the visual removal. We just track the API call.
    // We will clear the list only when the stack is fully consumed.
    
    // Clear previous match info if any
    state = state.copyWith(newMatch: null);

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
      // Ideally show error toast
    }
  }

  void resetDeck() {
    state = state.copyWith(recommendations: [], noMoreUsers: false);
  }

  /// Switch matching mode and reload the deck.
  Future<void> setMode(String mode) async {
    if (mode == state.mode) return;
    state = state.copyWith(mode: mode, recommendations: [], noMoreUsers: false);
    await loadRecommendations(refresh: true);
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

  Future<void> requestJoinCaravan(String userId) async {
    try {
      await _repository.requestJoinCaravan(userId);
      ToastService.showSuccess('Join request sent!');
    } catch (e) {
      ToastService.showError(e.toString());
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true);
    
    // Simple debounce could be added here or in UI. Assuming UI handles heavy debounce.
    try {
      final results = await _repository.searchUsers(query);
      state = state.copyWith(searchResults: results, isSearching: false);
    } catch (e) {
      _logger.e('Search failed: $e');
      state = state.copyWith(isSearching: false);
    }
  }
}

// Provider
final matchingProvider = StateNotifierProvider<MatchingNotifier, MatchingState>((ref) {
  return MatchingNotifier(MatchingRepository());
});
