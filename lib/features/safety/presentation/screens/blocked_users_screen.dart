import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/safety_provider.dart';

class BlockedUsersScreen extends ConsumerStatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  ConsumerState<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends ConsumerState<BlockedUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(safetyProvider.notifier).loadBlockedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final safety = ref.watch(safetyProvider);
    final blockedUsers = safety.blockedUsers;

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Blocked Users',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: safety.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : blockedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.slate,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.block,
                          size: 48,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No blocked users',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: blockedUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.slate,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: user.profile?.photoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: user.profile!.photoUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(color: AppColors.obsidian),
                                      errorWidget: (_, __, ___) => Container(
                                        color: AppColors.obsidian,
                                        child: Icon(Icons.person, color: Colors.white.withValues(alpha: 0.5)),
                                      ),
                                    )
                                  : Container(
                                      color: AppColors.obsidian,
                                      child: Icon(Icons.person, color: Colors.white.withValues(alpha: 0.5)),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.profile?.name ?? user.username ?? 'Unknown',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                if (user.username != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '@${user.username}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              final ok = await ref.read(safetyProvider.notifier).unblockUser(user.uid);
                              if (mounted) {
                                ok
                                    ? ToastService.showSuccess('User unblocked')
                                    : ToastService.showError('Failed to unblock');
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              'Unblock',
                              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
