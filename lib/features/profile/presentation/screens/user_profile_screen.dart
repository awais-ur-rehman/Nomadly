import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/profile_provider.dart';
import '../../../chat/providers/chat_provider.dart';
import '../../../social/providers/social_provider.dart';
import '../../../safety/providers/safety_provider.dart';
import '../../../matching/providers/matching_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final User? preloadedUser;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.preloadedUser,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  List<Post> _posts = [];
  bool _loadingPosts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
      _loadPosts();
    });
  }

  Future<void> _loadPosts() async {
    setState(() => _loadingPosts = true);
    try {
      final posts = await ref.read(socialRepositoryProvider).getUserPosts(widget.userId);
      if (mounted) setState(() => _posts = posts);
    } catch (_) {}
    if (mounted) setState(() => _loadingPosts = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);
    final user = state.user ?? widget.preloadedUser;
    final isLoading = state.isLoading && user == null;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Text(
            state.error ?? 'User not found',
            style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
          ),
        ),
      );
    }

    final profile = user.profile;
    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text(
            'Profile not found',
            style: TextStyle(color: AppColors.white, fontFamily: 'Inter'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          user.username ?? profile.name ?? 'User',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () => _showSafetySheet(context, user),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
          await _loadPosts();
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildProfileContent(user, profile)),
            SliverToBoxAdapter(child: _buildPostGridHeader()),
            _buildPostGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(User user, Profile profile) {
    final rig = user.rig;
    final route = user.travelRoute;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Profile Photo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                  ? Image.network(profile.photoUrl!, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.slate,
                      child: const Icon(Icons.person, size: 45, color: AppColors.grey),
                    ),
            ),
          ),
          const SizedBox(height: 14),

          // Name + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.name ?? 'User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: AppColors.white,
                ),
              ),
              if (user.verificationLevel > 0) ...[
                const SizedBox(width: 8),
                Icon(Icons.verified, color: AppColors.primary, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('${_posts.length}', 'Posts'),
              GestureDetector(
                onTap: () => context.push('/profile/${user.uid}/connections?tab=0'),
                child: _buildStatItem(_formatCount(user.followerCount), 'Followers'),
              ),
              GestureDetector(
                onTap: () => context.push('/profile/${user.uid}/connections?tab=1'),
                child: _buildStatItem(_formatCount(user.followingCount), 'Following'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            Text(
              profile.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Info chips
          _buildCompactInfo(rig, route),

          // Hobbies (max 3)
          if (profile.hobbies.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildHobbiesRow(profile.hobbies),
          ],

          const SizedBox(height: 20),

          // Action Buttons
          _buildActionButtons(user, route),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.6),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildCompactInfo(Rig? rig, TravelRoute? route) {
    final infoParts = <Widget>[];

    if (rig != null && rig.type != null) {
      infoParts.add(_buildInfoChip(Icons.directions_car_outlined, _formatRigType(rig.type!)));
    }

    if (route != null && route.destination != null) {
      infoParts.add(_buildInfoChip(Icons.route_outlined, 'On the Road'));
    }

    if (infoParts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: infoParts,
    );
  }

  String _formatRigType(String type) {
    return type.split('_').map((word) =>
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHobbiesRow(List<String> hobbies) {
    final displayHobbies = hobbies.take(3).toList();
    final remainingCount = hobbies.length - 3;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        ...displayHobbies.map((hobby) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            hobby,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        )),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$remainingCount',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(User user, TravelRoute? route) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _FollowButton(user: user, ref: ref)),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final convo = await ref.read(chatListProvider.notifier).createConversation(user.uid);
                  if (convo != null && mounted) {
                    context.push('/chat/${convo.id}', extra: user);
                  }
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Message'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        if (route != null && route.destination != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ref.read(matchingProvider.notifier).requestJoinCaravan(user.uid),
              icon: const Icon(Icons.group_add_outlined, size: 20),
              label: const Text('Request to Join Caravan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPostGridHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: const Icon(Icons.grid_on, color: AppColors.white, size: 24),
    );
  }

  Widget _buildPostGrid() {
    if (_loadingPosts) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 60, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No posts yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];
          return GestureDetector(
            onTap: () => context.push('/post/${post.id}', extra: post),
            child: post.photos.isNotEmpty
                ? Image.network(post.photos.first, fit: BoxFit.cover)
                : Container(
                    color: AppColors.slate,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      post.caption,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  void _showSafetySheet(BuildContext context, User user) {
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
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User', style: TextStyle(color: AppColors.white, fontFamily: 'Inter')),
              subtitle: Text(
                "They won't be able to contact you",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontFamily: 'Inter', fontSize: 13),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: AppColors.slate,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Block User?', style: TextStyle(color: AppColors.white, fontFamily: 'Outfit')),
                    content: Text(
                      "They won't be able to see your profile or message you.",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontFamily: 'Inter'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Block', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  final ok = await ref.read(safetyProvider.notifier).blockUser(user.uid);
                  if (mounted) {
                    ok ? ToastService.showSuccess('User blocked') : ToastService.showError('Failed to block');
                    if (ok && mounted) context.pop();
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Report User', style: TextStyle(color: AppColors.white, fontFamily: 'Inter')),
              subtitle: Text(
                "Let us know what's wrong",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontFamily: 'Inter', fontSize: 13),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog(context, user.uid);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, String userId) {
    const reasons = [
      ('harassment', 'Harassment'),
      ('fake_profile', 'Fake Profile'),
      ('inappropriate_content', 'Inappropriate Content'),
      ('spam', 'Spam'),
      ('threatening_behavior', 'Threatening Behavior'),
      ('scam', 'Scam'),
      ('other', 'Other'),
    ];
    String? selectedReason;
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.slate,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Report User', style: TextStyle(color: AppColors.white, fontFamily: 'Outfit')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a reason:',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontFamily: 'Inter'),
                ),
                const SizedBox(height: 8),
                ...reasons.map((r) => RadioListTile<String>(
                  value: r.$1,
                  groupValue: selectedReason,
                  title: Text(r.$2, style: const TextStyle(fontSize: 14, color: AppColors.white, fontFamily: 'Inter')),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setDialogState(() => selectedReason = v),
                )),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                  decoration: InputDecoration(
                    hintText: 'Additional details (optional)',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontFamily: 'Inter'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
            ),
            TextButton(
              onPressed: () async {
                if (selectedReason == null) {
                  ToastService.showError('Select a reason');
                  return;
                }
                Navigator.pop(ctx);
                final ok = await ref.read(safetyProvider.notifier).reportUser(
                  userId,
                  selectedReason!,
                  description: descController.text.trim(),
                );
                if (mounted) {
                  ok ? ToastService.showSuccess('Report submitted') : ToastService.showError('Failed to submit report');
                }
              },
              child: const Text('Submit', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final User user;
  final WidgetRef ref;

  const _FollowButton({required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isFollowing = user.isFollowing;
    final isPending = user.isFollowingPending;

    String label;
    if (isPending) {
      label = 'Requested';
    } else if (isFollowing) {
      label = 'Following';
    } else {
      label = 'Follow';
    }

    return ElevatedButton(
      onPressed: isPending
          ? null
          : () {
              if (isFollowing) {
                ref.read(userProfileProvider.notifier).unfollowUser();
              } else {
                ref.read(userProfileProvider.notifier).followUser();
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing || isPending ? AppColors.slate : AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.slate,
        disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isFollowing || isPending
              ? BorderSide(color: Colors.white.withValues(alpha: 0.2))
              : BorderSide.none,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Outfit'),
      ),
    );
  }
}
