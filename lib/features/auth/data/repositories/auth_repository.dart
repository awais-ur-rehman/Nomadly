import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/secure_storage_service.dart';
import '../../../../shared/models/user.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final _apiClient = ApiClient();
  final _storage = SecureStorageService();
  final _logger = Logger();

  // Register new user
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String username,
    required String name,
    String? phone,
    int? age,
    String? gender,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'name': name,
          if (phone != null) 'phone': phone,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        return RegisterResponse.fromJson(data);
      }

      throw Exception('Registration failed');
    } on DioException catch (e) {
      _logger.e('Registration error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Verify OTP
  Future<AuthResponse> verifyOTP({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/verify-otp',
        data: {
          'email': email,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final authResponse = AuthResponse.fromJson(data);

        // Save tokens
        await _storage.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        // Save user info
        await _storage.saveUserId(authResponse.user.uid);
        await _storage.saveUserEmail(authResponse.user.email ?? '');

        return authResponse;
      }

      throw Exception('OTP verification failed');
    } on DioException catch (e) {
      _logger.e('OTP verification error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Resend OTP
  Future<void> resendOTP(String email) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/resend-otp',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to resend OTP');
      }
    } on DioException catch (e) {
      _logger.e('Resend OTP error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        
        _logger.i('🔍 Login response received, parsing AuthResponse...');
        _logger.i('📄 User JSON: ${data['user']}');
        
        try {
          final authResponse = AuthResponse.fromJson(data);
          _logger.i('✅ AuthResponse parsed successfully!');
          
          // Save tokens
          await _storage.saveTokens(
            accessToken: authResponse.token,
            refreshToken: authResponse.refreshToken,
          );

          // Save user info
          await _storage.saveUserId(authResponse.user.uid);
          await _storage.saveUserEmail(authResponse.user.email ?? '');

          return authResponse;
        } catch (e, stackTrace) {
          _logger.e('❌ PARSING ERROR: $e');
          _logger.e('📋 Stack trace: $stackTrace');
          _logger.e('📄 Failed JSON: $data');
          rethrow;
        }
      }

      throw Exception('Login failed');
    } on DioException catch (e) {
      _logger.e('Login error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Complete Profile
  Future<User> completeProfile({
    required Map<String, dynamic> profileData,
    required Map<String, dynamic> rigData,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.usersEndpoint}/complete-profile',
        data: {
          'profile': profileData,
          'rig': rigData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        // The API might return the full user object or just the profile
        // Assuming it returns the updated User object structure based on standard REST patterns
        // If the structure is different, we might need a different DTO or parsing logic
        // For now, let's assume it returns { data: { ...User... } }
        return User.fromJson(data);
      }

      throw Exception('Failed to complete profile');
    } on DioException catch (e) {
      _logger.e('Complete profile error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get current user profile
  Future<User> getMe() async {
    try {
      final response = await _apiClient.get('${AppConfig.usersEndpoint}/me');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return User.fromJson(data);
      }
      throw Exception('Failed to fetch user profile');
    } on DioException catch (e) {
      _logger.e('GetMe error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Forgot Password - Request reset OTP
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send reset code');
      }
    } on DioException catch (e) {
      _logger.e('Forgot password error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Reset Password - Verify OTP and set new password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/reset-password',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reset password');
      }
    } on DioException catch (e) {
      _logger.e('Reset password error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _storage.clearAll();
      _logger.d('User logged out');
    } catch (e) {
      _logger.e('Logout error: $e');
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    return await _storage.getUserId();
  }

  // Error handling
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
