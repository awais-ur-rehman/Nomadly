import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

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
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
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
                _buildSectionHeader('Account'),
                SwitchListTile(
                  title: const Text('Private Account'),
                  subtitle: const Text('Only followers can see your posts and rig details'),
                  value: isPrivate,
                  onChanged: _updatePrivacy,
                ),
                const Divider(),
                _buildSectionHeader('Notifications'),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: true, // Placeholder
                  onChanged: (val) {
                    // Mock implementation for now
                    setState(() {
                       // Update local state if needed
                       ToastService.showSuccess('Notification settings updated');
                    });
                  },
                ),
                const Divider(),
                _buildSectionHeader('About'),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to webview
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to webview
                  },
                ),
                const SizedBox(height: AppDimensions.paddingL),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingL, 
        AppDimensions.paddingL, 
        AppDimensions.paddingL, 
        AppDimensions.paddingS
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
