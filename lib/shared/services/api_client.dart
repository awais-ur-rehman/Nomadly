import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/config/app_config.dart';
import 'secure_storage_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final _logger = Logger();
  final _storage = SecureStorageService();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      /*
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
      */
    ]);
  }

  // Auth Interceptor - Adds JWT token to requests
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for public endpoints
        if (_isPublicEndpoint(options.path)) {
          return handler.next(options);
        }

        // Add token to header
        final token = await _storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    );
  }

  // Error Interceptor - Handles 401 and auto-refreshes token
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          _logger.w('401 Unauthorized - Attempting token refresh');

          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the original request
            try {
              final options = error.requestOptions;
              final token = await _storage.getAccessToken();
              options.headers['Authorization'] = 'Bearer $token';

              final response = await _dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              _logger.e('Error retrying request after token refresh: $e');
              return handler.next(error);
            }
          } else {
            // Refresh failed - user needs to login again
            _logger.e('Token refresh failed - redirecting to login');
            await _storage.clearAll();
            _logger.e('Token refresh failed - redirecting to login');
            // _logger.i('Redirecting to login (simulated)');
            // Note: Actual navigation requires a GlobalKey<NavigatorState> or re-auth stream listener
            // which is handled by RouterListenable in router.dart mostly.
            // verifying auth state change should trigger redirect.
            return handler.next(error);
          }
        }

        // Handle other errors
        _logger.e('API Error: ${error.message}');
        return handler.next(error);
      },
    );
  }

  // Refresh Token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        '${AppConfig.authEndpoint}/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['data']['token'];
        await _storage.saveTokens(
          accessToken: newToken,
          refreshToken: refreshToken,
        );
        // _logger.d('Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      _logger.e('Error refreshing token: $e');
      return false;
    }
  }

  // Check if endpoint is public (doesn't require auth)
  bool _isPublicEndpoint(String path) {
    const publicEndpoints = [
      '/auth/register',
      '/auth/login',
      '/auth/verify-otp',
      '/auth/resend-otp',
      '/auth/refresh',
    ];

    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('GET Error: $e');
      rethrow;
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('POST Error: $e');
      rethrow;
    }
  }

  // PATCH Request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('PATCH Error: $e');
      rethrow;
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('DELETE Error: $e');
      rethrow;
    }
  }

  // Upload File
  Future<Response> uploadFile(
    String path,
    String filePath, {
    String fileKey = 'image',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      _logger.e('Upload Error: $e');
      rethrow;
    }
  }
}
