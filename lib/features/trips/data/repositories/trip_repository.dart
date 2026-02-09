import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/trip.dart';

class TripRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  static const String _tripsEndpoint = '/v1/trips';

  // ============ Legacy: User's travel_route ============

  /// Get current user's trip (travel_route from user profile)
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/me',
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      _logger.e('Get current user error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Delete current user's trip (travel_route)
  Future<User> deleteUserRoute() async {
    try {
      final response = await _apiClient.delete(
        '${AppConfig.usersEndpoint}/route',
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to delete trip');
    } on DioException catch (e) {
      _logger.e('Delete trip error: ${e.message}');
      throw _handleError(e);
    }
  }

  // ============ New Trip Collection API ============

  /// Create a new trip
  Future<Trip> createTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await _apiClient.post(
        _tripsEndpoint,
        data: tripData,
      );

      if (response.statusCode == 201) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to create trip');
    } on DioException catch (e) {
      _logger.e('Create trip error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get trip by ID
  Future<Trip> getTrip(String tripId) async {
    try {
      final response = await _apiClient.get('$_tripsEndpoint/$tripId');

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to load trip');
    } on DioException catch (e) {
      _logger.e('Get trip error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get my created trips
  Future<List<Trip>> getMyTrips() async {
    try {
      _logger.i('Fetching my trips from $_tripsEndpoint/mine');
      final response = await _apiClient.get('$_tripsEndpoint/mine');

      _logger.i('My trips response: ${response.statusCode}, count: ${(response.data['data'] as List?)?.length ?? 0}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Trip.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      _logger.e('Get my trips error: ${e.message}', error: e);
      if (e.response != null) {
        _logger.e('Response status: ${e.response?.statusCode}, data: ${e.response?.data}');
      }
      return [];
    }
  }

  /// Get trips I've joined as companion
  Future<List<Trip>> getTripsJoined() async {
    try {
      final response = await _apiClient.get('$_tripsEndpoint/joined');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Trip.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      _logger.e('Get joined trips error: ${e.message}');
      return [];
    }
  }

  /// Get nearby trips for discovery
  Future<List<Trip>> getNearbyTrips({
    required double latitude,
    required double longitude,
    double radiusKm = 100,
  }) async {
    try {
      _logger.i('Fetching nearby trips: lat=$latitude, lng=$longitude, radius=$radiusKm');
      final response = await _apiClient.get(
        '$_tripsEndpoint/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
        },
      );

      _logger.i('Nearby trips response: ${response.statusCode}, count: ${(response.data['data'] as List?)?.length ?? 0}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Trip.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      _logger.e('Get nearby trips error: ${e.message}', error: e);
      if (e.response != null) {
        _logger.e('Response status: ${e.response?.statusCode}, data: ${e.response?.data}');
      }
      return [];
    }
  }

  /// Update a trip
  Future<Trip> updateTrip(String tripId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.patch(
        '$_tripsEndpoint/$tripId',
        data: updates,
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to update trip');
    } on DioException catch (e) {
      _logger.e('Update trip error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Delete a trip
  Future<void> deleteTrip(String tripId) async {
    try {
      await _apiClient.delete('$_tripsEndpoint/$tripId');
    } on DioException catch (e) {
      _logger.e('Delete trip error: ${e.message}');
      throw _handleError(e);
    }
  }

  // ============ Interest Management ============

  /// Show interest in a trip
  Future<Trip> showInterest(String tripId, {String message = ''}) async {
    try {
      final response = await _apiClient.post(
        '$_tripsEndpoint/$tripId/interest',
        data: {'message': message},
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to show interest');
    } on DioException catch (e) {
      _logger.e('Show interest error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Cancel my interest in a trip
  Future<Trip> cancelInterest(String tripId) async {
    try {
      final response = await _apiClient.delete(
        '$_tripsEndpoint/$tripId/interest',
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to cancel interest');
    } on DioException catch (e) {
      _logger.e('Cancel interest error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Accept an interest request (trip owner only)
  Future<Trip> acceptInterest(String tripId, String userId) async {
    try {
      final response = await _apiClient.patch(
        '$_tripsEndpoint/$tripId/interest/$userId/accept',
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to accept interest');
    } on DioException catch (e) {
      _logger.e('Accept interest error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Decline an interest request (trip owner only)
  Future<Trip> declineInterest(String tripId, String userId) async {
    try {
      final response = await _apiClient.patch(
        '$_tripsEndpoint/$tripId/interest/$userId/decline',
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to decline interest');
    } on DioException catch (e) {
      _logger.e('Decline interest error: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Leave a trip (for companions)
  Future<Trip> leaveTrip(String tripId) async {
    try {
      final response = await _apiClient.delete(
        '$_tripsEndpoint/$tripId/leave',
      );

      if (response.statusCode == 200) {
        return Trip.fromJson(response.data['data']);
      }

      throw Exception('Failed to leave trip');
    } on DioException catch (e) {
      _logger.e('Leave trip error: ${e.message}');
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
