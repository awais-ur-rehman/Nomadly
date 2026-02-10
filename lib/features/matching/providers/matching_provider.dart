import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomadly/shared/models/recommended_user.dart';
import 'package:nomadly/features/matching/data/repositories/matching_repository.dart';
import 'package:nomadly/shared/services/toast_service.dart';

// State Class
class MatchingState {
  final List<RecommendedUser> recommendations;
  final Set<String> swipedUserIds; // Track swiped users locally
  final bool isLoading;
  final String? error;
  final bool deckExhausted; // True when user has swiped all available cards
  final bool noMoreFromServer; // True when server has no more users
  final String mode; // 'friends', 'dating', 'both'
  final Map<String, dynamic>? newMatch;
  final List<RecommendedUser> searchResults;
  final bool isSearching;

  MatchingState({
    this.recommendations = const [],
    this.swipedUserIds = const {},
    this.isLoading = false,
    this.error,
    this.deckExhausted = false,
    this.noMoreFromServer = false,
    this.mode = 'both',
    this.newMatch,
    this.searchResults = const [],
    this.isSearching = false,
  });

  // Get available (non-swiped) recommendations
  List<RecommendedUser> get availableRecommendations {
    return recommendations
        .where((r) => !swipedUserIds.contains(r.user.uid))
        .toList();
  }

  MatchingState copyWith({
    List<RecommendedUser>? recommendations,
    Set<String>? swipedUserIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? deckExhausted,
    bool? noMoreFromServer,
    String? mode,
    Map<String, dynamic>? newMatch,
    bool clearMatch = false,
    List<RecommendedUser>? searchResults,
    bool? isSearching,
  }) {
    return MatchingState(
      recommendations: recommendations ?? this.recommendations,
      swipedUserIds: swipedUserIds ?? this.swipedUserIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      deckExhausted: deckExhausted ?? this.deckExhausted,
      noMoreFromServer: noMoreFromServer ?? this.noMoreFromServer,
      mode: mode ?? this.mode,
      newMatch: clearMatch ? null : (newMatch ?? this.newMatch),
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

    // If not refreshing and we have unswiped recommendations, don't reload
    if (!refresh && state.availableRecommendations.isNotEmpty) return;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      deckExhausted: false,
    );

    try {
      _logger.d('[MatchingProvider] Loading recommendations (mode: ${state.mode})...');

      final users = await _repository.getRecommendations(
        page: 1,
        limit: 20,
        mode: state.mode,
      );

      _logger.d('[MatchingProvider] Loaded ${users.length} recommendations');

      // On refresh, clear swiped users to show fresh deck
      final newSwipedIds = refresh ? <String>{} : state.swipedUserIds;

      state = state.copyWith(
        isLoading: false,
        recommendations: users,
        swipedUserIds: newSwipedIds,
        noMoreFromServer: users.isEmpty,
        deckExhausted: users.isEmpty,
      );
    } catch (e, stackTrace) {
      _logger.e('[MatchingProvider] Error loading: $e');
      _logger.e('[MatchingProvider] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load recommendations. Please try again.',
      );
    }
  }

  Future<void> swipeUser(String userId, String action) async {
    // 1. Track this user as swiped locally
    final newSwipedIds = Set<String>.from(state.swipedUserIds)..add(userId);

    // 2. Check if deck is now exhausted
    final remainingCount = state.recommendations
        .where((r) => !newSwipedIds.contains(r.user.uid))
        .length;

    _logger.d('[MatchingProvider] Swiped $userId ($action). Remaining: $remainingCount');

    // 3. Update state with swiped user
    state = state.copyWith(
      swipedUserIds: newSwipedIds,
      deckExhausted: remainingCount == 0,
      clearMatch: true, // Clear previous match
    );

    // 4. Make API call
    try {
      _logger.d('👉 [MatchingProvider] Swiping $action on $userId');
      final result = await _repository.swipeUser(
        targetUserId: userId,
        action: action,
      );

      // 5. Handle Match
      if (result['isMatch'] == true) {
        _logger.i('🎉 [MatchingProvider] IT\'S A MATCH!');
        state = state.copyWith(newMatch: result);
      }
    } catch (e) {
      _logger.e('❌ [MatchingProvider] Swipe failed: $e');
      // Don't revert the swipe - user already saw the card go away
      // Just log the error, the swipe is recorded locally
    }
  }

  /// Called when CardSwiper reaches the end
  void onDeckEnd() {
    _logger.d('[MatchingProvider] Deck end reached');
    state = state.copyWith(deckExhausted: true);
  }

  /// Reset deck and reload fresh recommendations
  Future<void> refreshDeck() async {
    _logger.d('[MatchingProvider] Refreshing deck...');
    state = state.copyWith(
      swipedUserIds: {},
      recommendations: [],
      deckExhausted: false,
      noMoreFromServer: false,
    );
    await loadRecommendations(refresh: true);
  }

  /// Switch matching mode and reload the deck.
  Future<void> setMode(String mode) async {
    if (mode == state.mode) return;
    state = state.copyWith(
      mode: mode,
      recommendations: [],
      swipedUserIds: {},
      deckExhausted: false,
      noMoreFromServer: false,
    );
    await loadRecommendations(refresh: true);
  }

  // Update Max Distance Preference
  Future<void> updateDistance(int distanceKm) async {
    try {
      _logger.d('⚙️ [MatchingProvider] Updating distance to $distanceKm km');

      // 1. Update backend
      await _repository.updateMatchingPreferences(distanceKm);

      // 2. Reload deck with new settings
      await refreshDeck();

    } catch (e) {
      _logger.e('❌ [MatchingProvider] Failed to update distance: $e');
      ToastService.showError('Failed to update distance');
    }
  }

  void clearMatch() {
    state = state.copyWith(clearMatch: true);
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
