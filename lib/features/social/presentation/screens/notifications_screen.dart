import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationProvider.notifier).markAllAsRead(),
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: state.isLoading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.notifications.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColor(notification.type).withValues(alpha: 0.1),
                        child: Icon(_getIcon(notification.type), color: _getColor(notification.type)),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.body),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(notification.createdAt.toLocal()),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      onTap: () {
                        ref.read(notificationProvider.notifier).markAsRead(notification.id);
                        
                        final targetId = notification.data;
                        if (targetId == null || targetId.isEmpty) return;

                        switch (notification.type) {
                          case 'message':
                          case 'match':
                            context.push('/chat/$targetId');
                            break;
                          case 'post':
                          case 'like':
                          case 'comment':
                            context.push('/post/$targetId');
                            break;
                          case 'follow':
                            context.push('/profile/$targetId');
                            break;
                          case 'activity':
                            context.push('/activity/$targetId');
                            break;
                          case 'job':
                            context.push('/job/$targetId');
                            break;
                          default:
                            ToastService.showInfo('Notification tapped: ${notification.title}');
                        }
                      },
                      tileColor: notification.isRead ? null : AppColors.primaryExtraLight.withValues(alpha: 0.3),
                    );
                  },
                ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'match': return Icons.favorite;
      case 'message': return Icons.chat_bubble;
      case 'activity': return Icons.event;
      default: return Icons.notifications;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'match': return AppColors.success;
      case 'message': return AppColors.primary;
      case 'activity': return AppColors.warning;
      default: return AppColors.grey;
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text('Nothing here yet.', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
