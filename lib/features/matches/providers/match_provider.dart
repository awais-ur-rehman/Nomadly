import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/match.dart';
import '../../../../shared/models/user.dart';
import '../data/repositories/match_repository.dart';

// Repository Provider
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository();
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
  final MatchRepository _repository;

  MatchNotifier(this._repository) : super(MatchState()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final matches = await _repository.getMatches();
      state = state.copyWith(matches: matches);
      
      // Fetch details for each matched user
      // Note: In a real app, the match endpoint might return user details expanded
      // For now, assuming we might need to fetch them if not included
      // Optimally, backend sends populated 'matchedUserId' as User object
      // If Match model has userId Strings, we might need to fetch.
      // Let's assume for this phase we just list them.
      
      state = state.copyWith(isLoading: false);
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
