import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';
import 'package:nomadly/features/social/providers/social_provider.dart';
import 'package:nomadly/shared/models/user.dart';
import 'package:nomadly/features/profile/presentation/widgets/profile_view_base.dart';
import 'package:nomadly/core/constants/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Post> _posts = [];
  bool _loadingPosts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPosts());
  }

  Future<void> _loadPosts() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    setState(() => _loadingPosts = true);
    try {
      final posts = await ref.read(socialRepositoryProvider).getUserPosts(user.uid);
      if (mounted) setState(() => _posts = posts);
    } catch (_) {}
    if (mounted) setState(() => _loadingPosts = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final profile = user.profile;
    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profile not completed',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.push('/profile-setup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: ProfileViewBase(
          user: user,
          posts: _posts,
          isPostsLoading: _loadingPosts,
          isOwnProfile: true,
          onRefresh: _loadPosts,
          onFollowersTap: () {
            context.push('/profile/${user.uid}/connections?tab=0');
          },
          onFollowingTap: () {
            context.push('/profile/${user.uid}/connections?tab=1');
          },
          onSettingsTap: () => _showSettingsSheet(context),
          banner: !user.isBuilder ? _buildMarketplaceBanner() : null,
          headerButtons: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/edit-profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.slate,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildSettingsItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pop(ctx);
                context.push('/edit-profile');
              },
            ),
            _buildSettingsItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(ctx);
                context.push('/settings');
              },
            ),
            _buildSettingsItem(
              icon: Icons.bookmark_outline,
              title: 'Saved',
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            _buildSettingsItem(
              icon: Icons.qr_code,
              title: 'QR Code',
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            _buildSettingsItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontFamily: 'Inter',
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildMarketplaceBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.storefront_outlined, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Join the Marketplace',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Offer your skills to the community and earn while you travel.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/builder-setup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
