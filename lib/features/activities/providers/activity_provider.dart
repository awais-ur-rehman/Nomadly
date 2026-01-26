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
    state = state.copyWith(isLoading: true);
    final pos = await Geolocator.getCurrentPosition();
    
    final beaconData = {
      'message': message,
      'type': 'social',
      'startTime': DateTime.now().toIso8601String(),
      'maxParticipants': 0,
      'location': {
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      }
    };

    try {
      final beacon = await _repository.createBeacon(beaconData);
      state = state.copyWith(
        isLoading: false,
        beacons: [beacon, ...state.beacons],
      );
      ToastService.showSuccess('Beacon shouted!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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

  Future<void> joinBeacon(String beaconId) async {
     try {
       await _repository.joinBeacon(beaconId);
       ToastService.showSuccess('Joined beacon!');
       await loadNearbyActivities(); 
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
