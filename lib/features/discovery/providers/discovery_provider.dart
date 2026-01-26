import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/match.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/discovery_repository.dart';

// Repository Provider
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository();
});

// State for the Discovery Feed
class DiscoveryState {
  final List<DiscoveryUser> users;
  final bool isLoading;
  final String? error;
  final bool noMoreUsers;
  final Map<String, dynamic> filters;

  DiscoveryState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.noMoreUsers = false,
    this.filters = const {},
  });

  DiscoveryState copyWith({
    List<DiscoveryUser>? users,
    bool? isLoading,
    String? error,
    bool? noMoreUsers,
    Map<String, dynamic>? filters,
  }) {
    return DiscoveryState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      noMoreUsers: noMoreUsers ?? this.noMoreUsers,
      filters: filters ?? this.filters,
    );
  }
}

// Discovery Notifier
class DiscoveryNotifier extends StateNotifier<DiscoveryState> {
  final DiscoveryRepository _repository;
  int _page = 1;

  DiscoveryNotifier(this._repository) : super(DiscoveryState()) {
    loadDiscoveryFeed();
  }

  Future<void> loadDiscoveryFeed({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      state = state.copyWith(isLoading: true, noMoreUsers: false, users: [], error: null);
    } else {
      if (state.isLoading || state.noMoreUsers) return;
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final newUsers = await _repository.getDiscoveryFeed(
        page: _page,
        filters: state.filters,
      );
      
      if (newUsers.isEmpty) {
        state = state.copyWith(isLoading: false, noMoreUsers: true);
      } else {
        _page++;
        state = state.copyWith(
          isLoading: false,
          users: refresh ? newUsers : [...state.users, ...newUsers],
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void updateFilters(Map<String, dynamic> filters) {
    state = state.copyWith(filters: filters);
    loadDiscoveryFeed(refresh: true);
  }

  Future<Match?> swipeUser(String userId, String action) async {
    // Optimistically remove user from list
    final updatedUsers = state.users.where((u) => u.user.id != userId).toList();
    state = state.copyWith(users: updatedUsers);

    try {
      final match = await _repository.swipeUser(
        targetUserId: userId,
        action: action,
      );
      
      if (match != null && match.isMutual) {
        // Return match to trigger UI dialog
        return match;
      }
    } catch (e) {
      // If error, maybe re-add user? For now, just show error toast
      ToastService.showError('Failed to swipe: $e');
    }
    
    // Load more if running low
    if (state.users.length < 5) {
      loadDiscoveryFeed();
    }
    
    return null;
  }
}

// Provider
final discoveryProvider = StateNotifierProvider<DiscoveryNotifier, DiscoveryState>((ref) {
  final repository = ref.watch(discoveryRepositoryProvider);
  return DiscoveryNotifier(repository);
});
