import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/match.dart';
import '../../../../shared/models/user.dart';
import '../../matching/data/repositories/matching_repository.dart';

// Repository Provider - Uses the new MatchingRepository
final matchRepositoryProvider = Provider<MatchingRepository>((ref) {
  return MatchingRepository();
});

// State
class MatchState {
  final List<Match> matches;
  final Map<String, User> matchedUsers; // Cache user details
  final bool isLoading;
  final String? error;

  MatchState({
    this.matches = const [],
    this.matchedUsers = const {},
    this.isLoading = false,
    this.error,
  });

  MatchState copyWith({
    List<Match>? matches,
    Map<String, User>? matchedUsers,
    bool? isLoading,
    String? error,
  }) {
    return MatchState(
      matches: matches ?? this.matches,
      matchedUsers: matchedUsers ?? this.matchedUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class MatchNotifier extends StateNotifier<MatchState> {
  final MatchingRepository _repository;

  MatchNotifier(this._repository) : super(MatchState()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final matchesData = await _repository.getMatches();
      
      // Parse maps to Match objects
      final List<Match> matches = matchesData.map((m) {
        try {
          return Match.fromJson(m);
        } catch (e) {
          // Log parsing error but skip invalid item
           return null;
        }
      }).whereType<Match>().toList();

      state = state.copyWith(matches: matches, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final matchProvider = StateNotifierProvider<MatchNotifier, MatchState>((ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return MatchNotifier(repository);
});
