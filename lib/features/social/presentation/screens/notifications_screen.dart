import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          if (state.notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () => ref.read(notificationProvider.notifier).markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationProvider.notifier).loadNotifications(),
        color: AppColors.primary,
        backgroundColor: AppColors.slate,
        child: state.isLoading && state.notifications.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : state.notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return _NotificationTile(
                        notification: notification,
                        onTap: () => _handleNotificationTap(context, ref, notification),
                      );
                    },
                  ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, WidgetRef ref, notification) {
    // Mark as read
    if (!notification.isRead) {
      ref.read(notificationProvider.notifier).markAsRead(notification.id);
    }

    final targetId = notification.data;
    if (targetId == null || targetId.isEmpty) return;

    // Navigate based on notification type
    switch (notification.type) {
      // Marketplace notifications
      case 'job_application':
        context.push('/job/$targetId');
        break;
      case 'application_status':
        context.push('/job/$targetId');
        break;
      case 'consultation_request':
      case 'consultation_accepted':
        // TODO: Navigate to consultation detail when implemented
        break;
      case 'new_review':
        // TODO: Navigate to reviews when implemented
        break;

      // Social notifications
      case 'match':
      case 'message':
        context.push('/chat/$targetId');
        break;
      case 'activity_approval':
        context.push('/activity/$targetId');
        break;
      case 'vouch':
        context.push('/profile/$targetId');
        break;

      default:
        break;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.slate,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 48,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'ll see updates here when they happen',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getNotificationConfig(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.slate : AppColors.slate.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: notification.isRead
            ? null
            : Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    config.icon,
                    color: config.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  _NotificationConfig _getNotificationConfig(String type) {
    switch (type) {
      // Marketplace
      case 'job_application':
        return _NotificationConfig(
          icon: Icons.work,
          color: AppColors.primary,
        );
      case 'application_status':
        return _NotificationConfig(
          icon: Icons.assignment_turned_in,
          color: AppColors.success,
        );
      case 'consultation_request':
        return _NotificationConfig(
          icon: Icons.calendar_today,
          color: AppColors.accent,
        );
      case 'consultation_accepted':
        return _NotificationConfig(
          icon: Icons.check_circle,
          color: AppColors.success,
        );
      case 'new_review':
        return _NotificationConfig(
          icon: Icons.star,
          color: Colors.amber,
        );

      // Social
      case 'match':
        return _NotificationConfig(
          icon: Icons.favorite,
          color: AppColors.error,
        );
      case 'message':
        return _NotificationConfig(
          icon: Icons.chat_bubble,
          color: AppColors.primary,
        );
      case 'activity_approval':
        return _NotificationConfig(
          icon: Icons.event_available,
          color: AppColors.success,
        );
      case 'vouch':
        return _NotificationConfig(
          icon: Icons.verified,
          color: AppColors.primary,
        );

      // Default
      case 'system':
      default:
        return _NotificationConfig(
          icon: Icons.notifications,
          color: AppColors.textSecondary,
        );
    }
  }
}

class _NotificationConfig {
  final IconData icon;
  final Color color;

  _NotificationConfig({required this.icon, required this.color});
}
