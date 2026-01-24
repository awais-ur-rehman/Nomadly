import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';

class ProfileRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get user profile by ID
  Future<User> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/$userId',
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      _logger.e('Get user profile error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Update profile
  Future<User> updateProfile({
    required Map<String, dynamic> profileData,
    Map<String, dynamic>? rigData,
  }) async {
    try {
      final response = await _apiClient.patch(
        '${AppConfig.usersEndpoint}/profile',
        data: {
          'profile': profileData,
          if (rigData != null) 'rig': rigData,
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to update profile');
    } on DioException catch (e) {
      _logger.e('Update profile error: ${e.message}');
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
