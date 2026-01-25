import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/notification.dart';

class NotificationRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get notifications
  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _apiClient.get('${AppConfig.baseUrl}/api/v1/notifications');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AppNotification.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get notifications error: ${e.message}');
      return [];
    }
  }

  // Mark as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.patch('${AppConfig.baseUrl}/api/v1/notifications/$notificationId/read');
    } on DioException catch (e) {
      _logger.e('Mark as read error: ${e.message}');
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.patch('${AppConfig.baseUrl}/api/v1/notifications/read-all');
    } on DioException catch (e) {
      _logger.e('Mark all as read error: ${e.message}');
    }
  }
}
