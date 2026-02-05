import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';
import 'package:nomadly/features/social/providers/social_provider.dart';
import 'package:nomadly/shared/models/user.dart';
import 'package:nomadly/features/profile/presentation/widgets/profile_view_base.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
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
      return const Center(child: CircularProgressIndicator());
    }

    final profile = user.profile;
    if (profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile not completed'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/profile-setup'),
              child: const Text('Complete Profile'),
            ),
          ],
        ),
      );
    }

    return ProfileViewBase(
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
      banner: !user.isBuilder ? _buildMarketplaceBanner() : null,
      headerButtons: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => context.push('/edit-profile'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: const Text('Edit Profile'),
        ),
      ),
    );
  }

  Widget _buildMarketplaceBanner() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Offer your skills to the community and earn while you travel.',
            style: TextStyle(color: Colors.white, fontSize: 13),
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
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}
