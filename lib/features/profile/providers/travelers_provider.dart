import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../shared/models/user.dart';
import 'profile_provider.dart';
import '../data/repositories/profile_repository.dart';

class TravelersState {
  final List<User> travelers;
  final bool isLoading;
  final String? error;

  TravelersState({
    this.travelers = const [],
    this.isLoading = false,
    this.error,
  });

  TravelersState copyWith({
    List<User>? travelers,
    bool? isLoading,
    String? error,
  }) {
    return TravelersState(
      travelers: travelers ?? this.travelers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TravelersNotifier extends StateNotifier<TravelersState> {
  final ProfileRepository _repository;

  TravelersNotifier(this._repository) : super(TravelersState());

  Future<void> loadTravelers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final position = await Geolocator.getCurrentPosition();
      
      final travelers = await _repository.getTravelers(
        lat: position.latitude,
        lng: position.longitude,
        radiusKm: 500.0, // Large radius for travelers (Brief: "I'm leaving, they're staying")
      );
      
      state = state.copyWith(
        isLoading: false, 
        travelers: travelers,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  Future<String> connectToUser(String userId) async {
    try {
      final status = await _repository.followUser(userId);
      return status;
    } catch (e) {
      throw e;
    }
  }
}

final travelersProvider = StateNotifierProvider.autoDispose<TravelersNotifier, TravelersState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return TravelersNotifier(repository);
});
