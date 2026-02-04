import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(title: const Text('Blocked Users')),
      body: safety.isLoading
          ? const Center(child: CircularProgressIndicator())
          : blockedUsers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.block, size: 48, color: AppColors.grey),
                      SizedBox(height: 16),
                      Text('No blocked users', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: blockedUsers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profile?.photoUrl != null 
                          ? NetworkImage(user.profile!.photoUrl!) 
                          : null,
                        child: user.profile?.photoUrl == null 
                          ? const Icon(Icons.person) 
                          : null,
                      ),
                      title: Text(user.profile?.name ?? user.username ?? 'Unknown'),
                      subtitle: Text('@${user.username ?? ''}'),
                      trailing: OutlinedButton(
                        onPressed: () async {
                          final ok = await ref.read(safetyProvider.notifier).unblockUser(user.uid);
                          if (mounted) {
                            ok
                                ? ToastService.showSuccess('User unblocked')
                                : ToastService.showError('Failed to unblock');
                          }
                        },
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Unblock'),
                      ),
                    );
                  },
                ),
    );
  }
}
