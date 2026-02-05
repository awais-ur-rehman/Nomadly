import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/profile_provider.dart';
import '../../../chat/providers/chat_provider.dart';
import '../../../social/providers/social_provider.dart';
import '../../../safety/providers/safety_provider.dart';
import '../../../matching/providers/matching_provider.dart';
import '../widgets/verification_badge.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.error ?? 'User not found')),
      );
    }

    final profile = user.profile;
    if (profile == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Profile not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username != null ? '@${user.username}' : (profile.name ?? 'User')),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showSafetySheet(context, user),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
          await _loadPosts();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(user, profile)),
            SliverToBoxAdapter(child: _buildPostGridHeader()),
            _buildPostGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User user, profile) {
    final rig = user.rig;
    final route = user.travelRoute;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Photo + Stats
          Row(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                ),
                child: ClipOval(
                  child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(imageUrl: profile.photoUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 40, color: AppColors.grey),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Posts', '${_posts.length}'),
                    _buildStat('Followers', '${user.followerCount}', onTap: () {
                      context.push('/profile/${user.uid}/connections?tab=0');
                    }),
                    _buildStat('Following', '${user.followingCount}', onTap: () {
                      context.push('/profile/${user.uid}/connections?tab=1');
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Name + badge
          Row(
            children: [
              Text(profile.name ?? 'User', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (profile.age != null)
                Text(', ${profile.age}', style: const TextStyle(fontSize: 16)),
              if (user.verificationLevel > 0) ...[
                const SizedBox(width: 6),
                VerificationBadge(level: user.verificationLevel),
              ],
            ],
          ),

          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(profile.bio!, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],

          // Rig one-liner
          if (rig != null && (rig.type != null || rig.crewType != null)) ...[
            const SizedBox(height: 6),
            _infoLine(Icons.directions_car, _rigSummary(rig)),
          ],

          // Trip one-liner
          if (route != null && route.destination != null) ...[
            const SizedBox(height: 4),
            _infoLine(Icons.place, _tripSummary(route)),
          ],

          // Hobby chips
          if (profile.hobbies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.hobbies.map<Widget>((h) => Chip(
                label: Text(h, style: const TextStyle(fontSize: 12)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: AppColors.primaryExtraLight,
                labelStyle: const TextStyle(color: AppColors.primary),
              )).toList(),
            ),
          ],

          const SizedBox(height: 12),

          // Follow + Message buttons
          Row(
            children: [
              Expanded(
                child: _FollowButton(user: user, ref: ref),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final convo = await ref.read(chatListProvider.notifier).createConversation(user.uid);
                    if (convo != null && context.mounted) {
                      context.push('/chat/${convo.id}', extra: user);
                    }
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Join Caravan Button (Core Phase 2 Feature)
          if (route != null && route.destination != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ref.read(matchingProvider.notifier).requestJoinCaravan(user.uid),
                  icon: const Icon(Icons.group_add_outlined),
                  label: const Text('Request to Join Caravan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _rigSummary(rig) {
    final parts = <String>[];
    if (rig.type != null) parts.add(rig.type![0].toUpperCase() + rig.type!.substring(1));
    if (rig.crewType != null) {
      final crew = (rig.crewType as String).replaceAll('_', ' ');
      parts.add(crew[0].toUpperCase() + crew.substring(1));
    }
    if (rig.petFriendly) parts.add('+ Pet');
    return parts.join(' · ');
  }

  String _tripSummary(route) {
    String text = '';
    if (route.origin != null) {
      text += '${route.origin.latitude.toStringAsFixed(1)},${route.origin.longitude.toStringAsFixed(1)}';
    }
    if (route.destination != null) {
      if (text.isNotEmpty) text += ' → ';
      text += '${route.destination.latitude.toStringAsFixed(1)},${route.destination.longitude.toStringAsFixed(1)}';
    }
    if (route.startDate != null) {
      text += ' · ${DateFormat.MMMd().format(route.startDate!)}';
    }
    return text;
  }

  Widget _buildPostGridHeader() {
    return const Column(
      children: [
        Divider(height: 1),
        Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.grid_on, color: AppColors.textPrimary)),
        Divider(height: 1),
      ],
    );
  }

  Widget _buildPostGrid() {
    if (_loadingPosts) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }
    if (_posts.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Padding(padding: EdgeInsets.only(top: 40), child: Text('No posts yet', style: TextStyle(color: AppColors.grey)))),
      );
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];
          return GestureDetector(
            onTap: () => context.push('/post/${post.id}', extra: post),
            child: post.photos.isNotEmpty
                ? CachedNetworkImage(imageUrl: post.photos.first, fit: BoxFit.cover, placeholder: (_, __) => Container(color: AppColors.greyExtraLight))
                : Container(
                    color: AppColors.greyExtraLight,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(post.caption, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                  ),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  Widget _buildStat(String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showSafetySheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 16), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User'),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Block User?'),
                    content: const Text('They won\'t be able to see your profile or message you.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Block', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  final ok = await ref.read(safetyProvider.notifier).blockUser(user.uid);
                  if (mounted) {
                    ok ? ToastService.showSuccess('User blocked') : ToastService.showError('Failed to block');
                    if (ok) context.pop();
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog(context, user.uid);
              },
            ),
            const SizedBox(height: 8),
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
          title: const Text('Report User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a reason:'),
                const SizedBox(height: 8),
                ...reasons.map((r) => RadioListTile<String>(
                  value: r.$1,
                  groupValue: selectedReason,
                  title: Text(r.$2, style: const TextStyle(fontSize: 14)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setDialogState(() => selectedReason = v),
                )),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(hintText: 'Additional details (optional)', border: OutlineInputBorder(), isDense: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                if (selectedReason == null) { ToastService.showError('Select a reason'); return; }
                Navigator.pop(ctx);
                final ok = await ref.read(safetyProvider.notifier).reportUser(userId, selectedReason!, description: descController.text.trim());
                if (mounted) ok ? ToastService.showSuccess('Report submitted') : ToastService.showError('Failed to submit report');
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
      onPressed: isPending ? null : () {
        if (isFollowing) {
          ref.read(userProfileProvider.notifier).unfollowUser();
        } else {
          ref.read(userProfileProvider.notifier).followUser();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing || isPending ? AppColors.greyExtraLight : AppColors.primary,
        foregroundColor: isFollowing || isPending ? AppColors.textPrimary : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}
