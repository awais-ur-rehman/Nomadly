import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  
  static String get apiUrl => '$baseUrl/api';
  
  static String get socketUrl => baseUrl;
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String matchesEndpoint = '/matches';
  static const String chatEndpoint = '/v1/chat';
  static const String activitiesEndpoint = '/activities';
  static const String marketplaceEndpoint = '/marketplace';
  static const String uploadEndpoint = '/upload';
  static const String vouchEndpoint = '/vouch';
  static const String paymentsEndpoint = '/payments';
  static const String notificationsEndpoint = '/notifications';
  static const String safetyEndpoint = '/v1/safety';
  static const String inviteEndpoint = '/v1/invite';
  static const String verificationEndpoint = '/v1/verification';
  static const String aiEndpoint = '/v1/ai';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Upload
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}
