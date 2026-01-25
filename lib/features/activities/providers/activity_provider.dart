import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/beacon.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/activity_repository.dart';
import 'package:geolocator/geolocator.dart'; // To get current location

// Repository Provider
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository();
});

// State
class ActivityState {
  final List<Activity> activities;
  final List<Beacon> beacons;
  final bool isLoading;
  final String? error;

  ActivityState({
    this.activities = const [],
    this.beacons = const [],
    this.isLoading = false,
    this.error,
  });

  ActivityState copyWith({
    List<Activity>? activities,
    List<Beacon>? beacons,
    bool? isLoading,
    String? error,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      beacons: beacons ?? this.beacons,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;

  ActivityNotifier(this._repository) : super(ActivityState());

  Future<void> loadNearbyActivities() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final position = await Geolocator.getCurrentPosition();
      
      final activities = await _repository.getNearbyActivities(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      final beacons = await _repository.getNearbyBeacons(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      state = state.copyWith(
        isLoading: false, 
        activities: activities,
        beacons: beacons,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createBeacon(String message) async {
    try {
      state = state.copyWith(isLoading: true);
      final position = await Geolocator.getCurrentPosition();
      final newBeacon = await _repository.createBeacon(
        message: message,
        lat: position.latitude,
        lng: position.longitude,
      );
      state = state.copyWith(
        isLoading: false,
        beacons: [newBeacon, ...state.beacons],
      );
      ToastService.showSuccess('Beacon sent!');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      ToastService.showError(e.toString());
    }
  }

  Future<void> createActivity(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isLoading: true);
      final newActivity = await _repository.createActivity(data);
      state = state.copyWith(
        isLoading: false,
        activities: [...state.activities, newActivity],
      );
      ToastService.showSuccess('Activity created successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
    }
  }
  
  Future<void> joinActivity(String activityId) async {
     try {
       // Optimistic update or refresh?
       // Let's refresh whole list or update specific item if API returns updated object
       await _repository.joinActivity(activityId);
       ToastService.showSuccess('Joined activity!');
       await loadNearbyActivities(); // Refresh to show updated participant list
     } catch (e) {
       ToastService.showError(e.toString());
     }
  }
}

// Provider
final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return ActivityNotifier(repository);
});
