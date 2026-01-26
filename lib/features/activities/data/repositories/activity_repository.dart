import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/beacon.dart';

class ActivityRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

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
        return data.map((json) => Activity.fromJson(json)).toList();
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
        '/api/v1/beacons/nearby',
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
        '/beacons',
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

  // ... (keeping joinBeacon etc)
  
  // Join Beacon (if relevant to logic, e.g. "I'm interested")
  Future<void> joinBeacon(String beaconId) async {
    try {
      await _apiClient.post('/beacons/$beaconId/join');
    } on DioException catch (e) {
       _logger.e('Join beacon error: ${e.message}');
       throw _handleError(e);
    }
  }

  // Create activity (legacy/compatibility, mapping to beacon)
  Future<Activity> createActivity(Map<String, dynamic> activityData) async {
    try {
      final response = await _apiClient.post(
        '/beacons',
        data: activityData,
      );

      if (response.statusCode == 201) {
        return Activity.fromJson(response.data['data']);
      }

      throw Exception('Failed to create activity');
    } on DioException catch (e) {
      _logger.e('Create activity error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Join activity
  Future<Activity> joinActivity(String activityId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.baseUrl}/api/v1/activities/$activityId/join',
      );

      if (response.statusCode == 200) {
        return Activity.fromJson(response.data['data']);
      }

      throw Exception('Failed to join activity');
    } on DioException catch (e) {
      _logger.e('Join activity error: ${e.message}');
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
