import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/travel_route.dart';
import '../../../shared/models/trip.dart';
import '../../../shared/services/toast_service.dart';
import '../data/repositories/trip_repository.dart';

// Repository Provider
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository();
});

// ============ Legacy: User's travel_route ============

// FutureProvider for user's travel_route (used by my_trips_screen)
final currentTripProvider = FutureProvider.autoDispose<TravelRoute?>((ref) async {
  final repository = TripRepository();
  final user = await repository.getCurrentUser();
  return user.travelRoute;
});

// ============ New Trip Collection Providers ============

// My created trips
final myTripsProvider = FutureProvider.autoDispose<List<Trip>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getMyTrips();
});

// Trips I've joined
final joinedTripsProvider = FutureProvider.autoDispose<List<Trip>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripsJoined();
});

// Nearby trips for discovery
final nearbyTripsProvider = FutureProvider.autoDispose<List<Trip>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);

  try {
    final position = await Geolocator.getCurrentPosition();
    return repository.getNearbyTrips(
      latitude: position.latitude,
      longitude: position.longitude,
      radiusKm: 100,
    );
  } catch (e) {
    // Fallback to empty list if location fails
    return [];
  }
});

// Single trip detail
final tripDetailProvider = FutureProvider.autoDispose.family<Trip, String>((ref, tripId) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTrip(tripId);
});

// ============ Trip Notifier for mutations ============

class TripState {
  final TravelRoute? currentUserRoute;
  final List<Trip> myTrips;
  final List<Trip> nearbyTrips;
  final bool isLoading;
  final String? error;

  TripState({
    this.currentUserRoute,
    this.myTrips = const [],
    this.nearbyTrips = const [],
    this.isLoading = false,
    this.error,
  });

  TripState copyWith({
    TravelRoute? currentUserRoute,
    List<Trip>? myTrips,
    List<Trip>? nearbyTrips,
    bool? isLoading,
    String? error,
    bool clearUserRoute = false,
  }) {
    return TripState(
      currentUserRoute: clearUserRoute ? null : (currentUserRoute ?? this.currentUserRoute),
      myTrips: myTrips ?? this.myTrips,
      nearbyTrips: nearbyTrips ?? this.nearbyTrips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TripNotifier extends StateNotifier<TripState> {
  final TripRepository _repository;

  TripNotifier(this._repository) : super(TripState());

  // Legacy: Delete user's travel_route
  Future<bool> deleteUserRoute() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteUserRoute();
      state = state.copyWith(
        isLoading: false,
        clearUserRoute: true,
      );
      ToastService.showSuccess('Trip deleted successfully');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError('Failed to delete trip');
      return false;
    }
  }

  // Create new trip
  Future<Trip?> createTrip(Map<String, dynamic> tripData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trip = await _repository.createTrip(tripData);
      state = state.copyWith(
        isLoading: false,
        myTrips: [trip, ...state.myTrips],
      );
      ToastService.showSuccess('Trip created successfully!');
      return trip;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Delete trip
  Future<bool> deleteTrip(String tripId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteTrip(tripId);
      state = state.copyWith(
        isLoading: false,
        myTrips: state.myTrips.where((t) => t.id != tripId).toList(),
      );
      ToastService.showSuccess('Trip deleted successfully');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError('Failed to delete trip');
      return false;
    }
  }

  // Show interest in a trip
  Future<Trip?> showInterest(String tripId, {String message = ''}) async {
    try {
      final trip = await _repository.showInterest(tripId, message: message);
      // Update nearby trips list
      state = state.copyWith(
        nearbyTrips: state.nearbyTrips.map((t) => t.id == tripId ? trip : t).toList(),
      );
      ToastService.showSuccess('Interest sent!');
      return trip;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Cancel interest
  Future<Trip?> cancelInterest(String tripId) async {
    try {
      final trip = await _repository.cancelInterest(tripId);
      state = state.copyWith(
        nearbyTrips: state.nearbyTrips.map((t) => t.id == tripId ? trip : t).toList(),
      );
      ToastService.showSuccess('Interest cancelled');
      return trip;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Accept interest (trip owner)
  Future<Trip?> acceptInterest(String tripId, String userId) async {
    try {
      final trip = await _repository.acceptInterest(tripId, userId);
      state = state.copyWith(
        myTrips: state.myTrips.map((t) => t.id == tripId ? trip : t).toList(),
      );
      ToastService.showSuccess('Interest accepted!');
      return trip;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Decline interest (trip owner)
  Future<Trip?> declineInterest(String tripId, String userId) async {
    try {
      final trip = await _repository.declineInterest(tripId, userId);
      state = state.copyWith(
        myTrips: state.myTrips.map((t) => t.id == tripId ? trip : t).toList(),
      );
      ToastService.showSuccess('Interest declined');
      return trip;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Leave trip (companion)
  Future<bool> leaveTrip(String tripId) async {
    try {
      await _repository.leaveTrip(tripId);
      ToastService.showSuccess('Left trip successfully');
      return true;
    } catch (e) {
      ToastService.showError(e.toString());
      return false;
    }
  }
}

// Provider
final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripNotifier(repository);
});
