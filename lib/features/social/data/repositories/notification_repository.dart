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
        // Backend returns { data: { notifications: [...], total: N, unreadCount: N } }
        final responseData = response.data['data'];
        final List<dynamic> notifications = responseData is List
            ? responseData
            : (responseData['notifications'] ?? []);
        return notifications.map((json) => parseNotification(json)).toList();
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
      await _apiClient.post('${AppConfig.baseUrl}/api/v1/notifications/mark-all-read');
    } on DioException catch (e) {
      _logger.e('Mark all as read error: ${e.message}');
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get('${AppConfig.baseUrl}/api/v1/notifications/unread-count');
      if (response.statusCode == 200) {
        return response.data['data']['count'] ?? 0;
      }
      return 0;
    } on DioException catch (e) {
      _logger.e('Get unread count error: ${e.message}');
      return 0;
    }
  }
}
