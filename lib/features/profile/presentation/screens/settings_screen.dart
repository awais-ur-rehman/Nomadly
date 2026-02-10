import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../../../shared/providers/revenue_cat_provider.dart';

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
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.white, fontFamily: 'Outfit', fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontFamily: 'Inter'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontFamily: 'Inter', fontWeight: FontWeight.w600),
            ),
          ),
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
    
    final revenueCatAsync = ref.watch(isProProvider);
    final localIsPro = revenueCatAsync.value ?? false;
    final isPro = (user?.isPro ?? false) || localIsPro;

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
          'Settings',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Account Section
                _buildSectionHeader('Account'),
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => context.push('/edit-profile'),
                ),
                _buildSettingsTile(
                  icon: Icons.verified_outlined,
                  title: 'Verification',
                  subtitle: user != null ? 'Level ${user.verificationLevel}' : null,
                  onTap: () => context.push('/verification'),
                ),
                _buildSettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Subscription',
                  subtitle: isPro ? 'Vantage Pro' : 'Free Plan',
                  onTap: () => context.push('/subscription'),
                ),
                _buildSettingsTile(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Invite Codes',
                  subtitle: '${user?.inviteCount ?? 0} invites available',
                  onTap: () => context.push('/invites'),
                ),
                _buildSwitchTile(
                  icon: Icons.lock_outline,
                  title: 'Private Account',
                  subtitle: 'Only followers can see your posts',
                  value: isPrivate,
                  onChanged: _updatePrivacy,
                ),
                const SizedBox(height: 16),

                // Matching Section
                _buildSectionHeader('Matching'),
                _buildSettingsTile(
                  icon: Icons.tune,
                  title: 'Matching Preferences',
                  subtitle: 'Distance, age, interests',
                  onTap: () => context.push('/matching-preferences'),
                ),
                const SizedBox(height: 16),

                // Travel & Activities Section
                _buildSectionHeader('Travel & Activities'),
                _buildSettingsTile(
                  icon: Icons.explore_outlined,
                  title: 'My Trip',
                  subtitle: 'View and manage your current trip',
                  onTap: () => context.push('/my-trip'),
                ),
                _buildSettingsTile(
                  icon: Icons.event,
                  title: 'My Activities',
                  subtitle: 'Activities you\'re hosting or joined',
                  onTap: () => context.push('/my-activities'),
                ),
                const SizedBox(height: 16),

                // Marketplace Section
                _buildSectionHeader('Marketplace'),
                _buildSettingsTile(
                  icon: Icons.assignment_outlined,
                  title: 'My Applications',
                  subtitle: 'Track your job applications',
                  onTap: () => context.push('/my-applications'),
                ),
                _buildSettingsTile(
                  icon: Icons.work_outline,
                  title: 'My Posted Jobs',
                  subtitle: 'Manage jobs you\'ve posted',
                  onTap: () => context.push('/my-jobs'),
                ),
                _buildSettingsTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'My Consultations',
                  subtitle: 'Track your consultation requests',
                  onTap: () => context.push('/my-consultations'),
                ),
                _buildSettingsTile(
                  icon: Icons.storefront_outlined,
                  title: 'Marketplace',
                  subtitle: 'Find talent & browse jobs',
                  onTap: () => context.push('/marketplace'),
                ),
                const SizedBox(height: 16),

                // Safety Section
                _buildSectionHeader('Safety'),
                _buildSettingsTile(
                  icon: Icons.block,
                  iconColor: Colors.red,
                  title: 'Blocked Users',
                  onTap: () => context.push('/blocked-users'),
                ),
                const SizedBox(height: 16),

                // Notifications Section
                _buildSectionHeader('Notifications'),
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // About Section
                _buildSectionHeader('About'),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white.withValues(alpha: 0.5), size: 24),
                      const SizedBox(width: 16),
                      Text(
                        'Version',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.15),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.4),
          fontFamily: 'Outfit',
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? Colors.white.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return Colors.white.withValues(alpha: 0.5);
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary.withValues(alpha: 0.3);
              }
              return Colors.white.withValues(alpha: 0.1);
            }),
          ),
        ],
      ),
    );
  }
}
