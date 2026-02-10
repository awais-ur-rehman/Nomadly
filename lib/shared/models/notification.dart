import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Helper function to parse notification from backend
AppNotification parseNotification(Map<String, dynamic> json) {
  // Handle backend response structure
  final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';
  final createdAt = json['created_at'] != null
      ? DateTime.parse(json['created_at'])
      : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now());
  final isRead = json['is_read'] ?? json['isRead'] ?? false;

  // Extract primary ID from data object for navigation
  String? dataId;
  if (json['data'] != null && json['data'] is Map) {
    final dataMap = json['data'] as Map<String, dynamic>;
    dataId = dataMap['jobId']?.toString() ??
             dataMap['applicantId']?.toString() ??
             dataMap['consultationId']?.toString() ??
             dataMap['builderId']?.toString() ??
             dataMap['reviewId']?.toString() ??
             dataMap['matchedUserId']?.toString() ??
             dataMap['activityId']?.toString() ??
             dataMap['voucherId']?.toString();
  }

  return AppNotification(
    id: id,
    title: json['title'] ?? '',
    body: json['body'] ?? '',
    type: json['type'] ?? 'system',
    createdAt: createdAt,
    isRead: isRead,
    data: dataId,
  );
}

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required String type,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? data,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
