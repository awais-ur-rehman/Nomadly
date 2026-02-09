import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/beacon.dart';

class ActivityRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  /// Maps backend activity JSON (snake_case) to frontend format (camelCase)
  Map<String, dynamic> _mapActivityFromBackend(Map<String, dynamic> data) {
    final mapped = Map<String, dynamic>.from(data);

    // Map _id to id
    mapped['id'] = data['_id']?.toString() ?? data['id'];

    // Map activity_type to type
    mapped['type'] = data['activity_type'] ?? data['type'] ?? 'other';

    // Map event_time to startTime
    mapped['startTime'] = data['event_time'] ?? data['startTime'];

    // Map max_participants to maxParticipants
    mapped['maxParticipants'] = data['max_participants'] ?? data['maxParticipants'] ?? 10;

    // Map current_participants to participants
    final participants = data['current_participants'] ?? data['participants'] ?? [];
    mapped['participants'] = (participants as List).map((p) {
      if (p is Map<String, dynamic>) {
        return _mapUserFromBackend(p);
      }
      // Handle raw ObjectId strings (unpopulated references)
      if (p is String) {
        return {'id': p, 'uid': p, 'username': 'User'};
      }
      return p;
    }).toList();

    // Map pending_requests to pendingRequests
    final pendingRequests = data['pending_requests'] ?? data['pendingRequests'] ?? [];
    mapped['pendingRequests'] = (pendingRequests as List).map((p) {
      if (p is Map<String, dynamic>) {
        return _mapUserFromBackend(p);
      }
      // Handle raw ObjectId strings (unpopulated references)
      if (p is String) {
        return {'id': p, 'uid': p, 'username': 'User'};
      }
      return p;
    }).toList();

    // Map host_id to creator
    final hostId = data['host_id'];
    if (hostId is Map<String, dynamic>) {
      mapped['creator'] = _mapUserFromBackend(hostId);
    } else if (hostId != null) {
      mapped['creator'] = {'id': hostId.toString(), 'uid': hostId.toString(), 'username': 'Unknown'};
    }

    // Handle location format - ensure it's in GeoJSON format for GeoPoint.fromJson
    final location = data['location'];
    if (location is Map<String, dynamic>) {
      if (location['coordinates'] is List) {
        // Already in GeoJSON format, keep it as is
        mapped['location'] = {
          'type': location['type'] ?? 'Point',
          'coordinates': location['coordinates'],
        };
      } else if (location['lat'] != null || location['latitude'] != null) {
        // Simple lat/lng format - convert to GeoJSON
        final lat = location['lat'] ?? location['latitude'];
        final lng = location['lng'] ?? location['longitude'];
        mapped['location'] = {
          'type': 'Point',
          'coordinates': [lng, lat],
        };
      }
    }

    // Ensure description exists
    mapped['description'] = data['description'] ?? '';

    // Ensure title exists
    mapped['title'] = data['title'] ?? 'Untitled';

    return mapped;
  }

  /// Maps backend user JSON to frontend format
  Map<String, dynamic> _mapUserFromBackend(Map<String, dynamic> data) {
    final mapped = Map<String, dynamic>.from(data);
    mapped['id'] = data['_id']?.toString() ?? data['id'];
    mapped['uid'] = data['_id']?.toString() ?? data['id'] ?? data['uid'];
    return mapped;
  }

  Future<List<Activity>> getNearbyActivities({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/beacons/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) {
          final mapped = _mapActivityFromBackend(json as Map<String, dynamic>);
          return Activity.fromJson(mapped);
        }).toList();
      }

      throw Exception('Failed to load activities');
    } on DioException catch (e) {
      _logger.e('Get nearby activities error: ${e.message}');
      return [];
    }
  }

  Future<List<Beacon>> getNearbyBeacons({
    required double latitude,
    required double longitude,
    double radiusKm = 20.0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/beacons/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Beacon.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get nearby beacons error: ${e.message}');
      return [];
    }
  }

  // Create Beacon
  Future<Beacon> createBeacon(Map<String, dynamic> beaconData) async {
    try {
      final response = await _apiClient.post(
        '/v1/beacons',
        data: beaconData,
      );
      if (response.statusCode == 201) {
        return Beacon.fromJson(response.data['data']);
      }
      throw Exception('Failed to create beacon');
    } on DioException catch (e) {
      _logger.e('Create beacon error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Join Beacon (if relevant to logic, e.g. "I'm interested")
  Future<void> joinBeacon(String beaconId) async {
    try {
      await _apiClient.post('/v1/beacons/$beaconId/join');
    } on DioException catch (e) {
       _logger.e('Join beacon error: ${e.message}');
       throw _handleError(e);
    }
  }

  // Create activity
  Future<Activity> createActivity(Map<String, dynamic> data) async {
    try {
      _logger.i('Creating activity with data: $data');
      final response = await _apiClient.post(
        '/v1/beacons',
        data: data,
      );

      _logger.i('Create activity response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 201) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }
      throw Exception('Failed to create activity');
    } on DioException catch (e) {
      _logger.e('Create activity error: ${e.message}', error: e, stackTrace: e.stackTrace);
      if (e.response != null) {
         _logger.e('Error response data: ${e.response?.data}');
      }
      throw _handleError(e);
    } catch (e, stack) {
      _logger.e('Unexpected error creating activity', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // Join activity
  Future<Activity> joinActivity(String activityId) async {
    try {
      final response = await _apiClient.post(
        '/v1/activities/$activityId/join',
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to join activity');
    } on DioException catch (e) {
      _logger.e('Join activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  Future<Activity> getActivity(String activityId) async {
    try {
      final response = await _apiClient.get(
        '/v1/activities/$activityId',
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to load activity');
    } on DioException catch (e) {
      _logger.e('Get activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Approve a pending request to join an activity
  Future<Activity> approveRequest(String activityId, String userId) async {
    try {
      final response = await _apiClient.patch(
        '/v1/activities/$activityId/approve/$userId',
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to approve request');
    } on DioException catch (e) {
      _logger.e('Approve request error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Reject a pending request to join an activity
  Future<Activity> rejectRequest(String activityId, String userId) async {
    try {
      final response = await _apiClient.patch(
        '/v1/activities/$activityId/reject/$userId',
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to reject request');
    } on DioException catch (e) {
      _logger.e('Reject request error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get activities the current user is hosting
  Future<List<Activity>> getMyHostedActivities() async {
    try {
      final response = await _apiClient.get(
        '/v1/activities/mine',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) {
          final mapped = _mapActivityFromBackend(json as Map<String, dynamic>);
          return Activity.fromJson(mapped);
        }).toList();
      }

      throw Exception('Failed to load hosted activities');
    } on DioException catch (e) {
      _logger.e('Get hosted activities error: ${e.message}');
      return [];
    }
  }

  /// Get activities the current user has joined
  Future<List<Activity>> getMyJoinedActivities() async {
    try {
      final response = await _apiClient.get(
        '/v1/activities/joined',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) {
          final mapped = _mapActivityFromBackend(json as Map<String, dynamic>);
          return Activity.fromJson(mapped);
        }).toList();
      }

      throw Exception('Failed to load joined activities');
    } on DioException catch (e) {
      _logger.e('Get joined activities error: ${e.message}');
      return [];
    }
  }

  /// Update an activity (host only)
  Future<Activity> updateActivity(String activityId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.patch(
        '/v1/activities/$activityId',
        data: data,
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to update activity');
    } on DioException catch (e) {
      _logger.e('Update activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Delete/cancel an activity (host only)
  Future<void> deleteActivity(String activityId) async {
    try {
      final response = await _apiClient.delete(
        '/v1/activities/$activityId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete activity');
      }
    } on DioException catch (e) {
      _logger.e('Delete activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Leave an activity (participant only)
  Future<Activity> leaveActivity(String activityId) async {
    try {
      final response = await _apiClient.delete(
        '/v1/activities/$activityId/leave',
      );

      if (response.statusCode == 200) {
        final mapped = _mapActivityFromBackend(response.data['data']);
        return Activity.fromJson(mapped);
      }

      throw Exception('Failed to leave activity');
    } on DioException catch (e) {
      _logger.e('Leave activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
    }
    return 'An unexpected error occurred.';
  }
}
