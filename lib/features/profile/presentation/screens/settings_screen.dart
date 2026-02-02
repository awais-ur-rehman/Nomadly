import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../../safety/providers/safety_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _updatePrivacy(bool isPrivate) async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      final updatedUser = await repo.updateProfile(isPrivate: isPrivate);
      ref.read(authProvider.notifier).updateUser(updatedUser);
      ToastService.showSuccess('Privacy settings updated');
    } catch (e) {
      ToastService.showError('Failed to update privacy');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isPrivate = user?.isPrivate ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // ── Account ──
                _sectionHeader('Account'),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/edit-profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.verified_outlined),
                  title: const Text('Verification'),
                  subtitle: Text(
                    user != null ? 'Level ${user.verificationLevel}' : '',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: verification screen
                    ToastService.showSuccess('Coming soon');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.card_giftcard_outlined),
                  title: const Text('Invite Codes'),
                  subtitle: Text(
                    '${user?.inviteCount ?? 0} invites available',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: invite screen
                    ToastService.showSuccess('Coming soon');
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline),
                  title: const Text('Private Account'),
                  subtitle: const Text('Only followers can see your posts'),
                  value: isPrivate,
                  onChanged: _updatePrivacy,
                ),
                const Divider(),

                // ── Matching ──
                _sectionHeader('Matching'),
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: const Text('Matching Preferences'),
                  subtitle: const Text('Distance, age, interests'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: matching prefs screen
                    ToastService.showSuccess('Coming soon');
                  },
                ),
                const Divider(),

                // ── Safety ──
                _sectionHeader('Safety'),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text('Blocked Users'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showBlockedUsers(context),
                ),
                const Divider(),

                // ── About ──
                _sectionHeader('About'),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  trailing: const Text('1.0.0', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const Divider(),

                // Logout
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimensions.paddingL, AppDimensions.paddingL, AppDimensions.paddingL, AppDimensions.paddingS),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
      ),
    );
  }

  void _showBlockedUsers(BuildContext context) {
    final safety = ref.read(safetyProvider);
    final blockedIds = safety.blockedUserIds.toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 8), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Blocked Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            if (blockedIds.isEmpty)
              const Expanded(child: Center(child: Text('No blocked users')))
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: blockedIds.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(blockedIds[i]),
                    trailing: TextButton(
                      child: const Text('Unblock', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final ok = await ref.read(safetyProvider.notifier).unblockUser(blockedIds[i]);
                        if (ok && context.mounted) {
                          Navigator.pop(ctx);
                          ToastService.showSuccess('User unblocked');
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
