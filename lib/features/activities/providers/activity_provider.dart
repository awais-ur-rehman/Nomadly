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
  
  Future<Activity?> joinActivity(String activityId) async {
     try {
       final updatedActivity = await _repository.joinActivity(activityId);
       ToastService.showSuccess('Join request sent!');
       await loadNearbyActivities();
       return updatedActivity;
     } catch (e) {
       ToastService.showError(e.toString());
       return null;
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

  Future<Activity?> approveRequest(String activityId, String userId) async {
    try {
      final updatedActivity = await _repository.approveRequest(activityId, userId);
      ToastService.showSuccess('Request approved!');
      return updatedActivity;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  Future<Activity?> rejectRequest(String activityId, String userId) async {
    try {
      final updatedActivity = await _repository.rejectRequest(activityId, userId);
      ToastService.showSuccess('Request rejected');
      return updatedActivity;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  Future<Activity?> updateActivity(String activityId, Map<String, dynamic> data) async {
    try {
      final updatedActivity = await _repository.updateActivity(activityId, data);
      ToastService.showSuccess('Activity updated!');
      return updatedActivity;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }

  Future<bool> deleteActivity(String activityId) async {
    try {
      await _repository.deleteActivity(activityId);
      ToastService.showSuccess('Activity cancelled');
      return true;
    } catch (e) {
      ToastService.showError(e.toString());
      return false;
    }
  }

  Future<Activity?> leaveActivity(String activityId) async {
    try {
      final updatedActivity = await _repository.leaveActivity(activityId);
      ToastService.showSuccess('Left activity');
      return updatedActivity;
    } catch (e) {
      ToastService.showError(e.toString());
      return null;
    }
  }
}

// Provider
final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return ActivityNotifier(repository);
});

// My Hosted Activities State
class MyActivitiesState {
  final List<Activity> hosted;
  final List<Activity> joined;
  final bool isLoading;
  final String? error;

  MyActivitiesState({
    this.hosted = const [],
    this.joined = const [],
    this.isLoading = false,
    this.error,
  });

  MyActivitiesState copyWith({
    List<Activity>? hosted,
    List<Activity>? joined,
    bool? isLoading,
    String? error,
  }) {
    return MyActivitiesState(
      hosted: hosted ?? this.hosted,
      joined: joined ?? this.joined,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Filter for upcoming (not expired)
  List<Activity> get upcomingHosted =>
      hosted.where((a) => a.startTime.isAfter(DateTime.now())).toList();

  List<Activity> get upcomingJoined =>
      joined.where((a) => a.startTime.isAfter(DateTime.now())).toList();

  // Filter for past (expired)
  List<Activity> get pastHosted =>
      hosted.where((a) => a.startTime.isBefore(DateTime.now())).toList();

  List<Activity> get pastJoined =>
      joined.where((a) => a.startTime.isBefore(DateTime.now())).toList();
}

// My Activities Notifier
class MyActivitiesNotifier extends StateNotifier<MyActivitiesState> {
  final ActivityRepository _repository;

  MyActivitiesNotifier(this._repository) : super(MyActivitiesState());

  Future<void> loadMyActivities() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final hosted = await _repository.getMyHostedActivities();
      final joined = await _repository.getMyJoinedActivities();

      state = state.copyWith(
        isLoading: false,
        hosted: hosted,
        joined: joined,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void removeActivity(String activityId) {
    state = state.copyWith(
      hosted: state.hosted.where((a) => a.id != activityId).toList(),
      joined: state.joined.where((a) => a.id != activityId).toList(),
    );
  }
}

// My Activities Provider
final myActivitiesProvider =
    StateNotifierProvider<MyActivitiesNotifier, MyActivitiesState>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return MyActivitiesNotifier(repository);
});

// Nearby Activities Provider (for discover hub)
final nearbyActivitiesProvider = FutureProvider.autoDispose<List<Activity>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);

  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );

    return await repository.getNearbyActivities(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  } catch (e) {
    // Return empty list if location fails
    return [];
  }
});
