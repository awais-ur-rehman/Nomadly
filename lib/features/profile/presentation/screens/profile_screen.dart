import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/models/geo_point.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../social/providers/social_provider.dart';
import '../widgets/verification_badge.dart';

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

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(user, profile)),
          SliverToBoxAdapter(child: _buildPostGridHeader()),
          _buildPostGrid(),
        ],
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

          // Photo + Stats row (Instagram-style)
          Row(
            children: [
              // Avatar
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                ),
                child: ClipOval(
                  child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profile.photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (_, __, ___) => const Icon(Icons.person, size: 40),
                        )
                      : const Icon(Icons.person, size: 40, color: AppColors.grey),
                ),
              ),
              const SizedBox(width: 24),
              // Stats
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

          // Name + verification badge
          Row(
            children: [
              Text(
                profile.name ?? 'User',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (user.verificationLevel > 0) ...[
                const SizedBox(width: 6),
                VerificationBadge(level: user.verificationLevel),
              ],
            ],
          ),

          // Username
          if (user.username != null)
            Text(
              '@${user.username}',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),

          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(profile.bio!, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],

          // Rig one-liner
          if (rig != null && (rig.type != null || rig.crewType != null)) ...[
            const SizedBox(height: 6),
            _buildOneLiner(
              Icons.directions_car,
              _rigSummary(rig),
            ),
          ],

          // Trip one-liner
          if (route != null && route.destination != null) ...[
            const SizedBox(height: 4),
            _buildOneLiner(
              Icons.place,
              _tripSummary(route),
            ),
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

          // Edit Profile button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/edit-profile'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOneLiner(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _rigSummary(rig) {
    final parts = <String>[];
    if (rig.type != null) {
      parts.add(rig.type![0].toUpperCase() + rig.type!.substring(1));
    }
    if (rig.crewType != null) {
      final crew = (rig.crewType as String).replaceAll('_', ' ');
      parts.add(crew[0].toUpperCase() + crew.substring(1));
    }
    if (rig.petFriendly) parts.add('+ Pet');
    return parts.join(' · ');
  }

  String _tripSummary(route) {
    final dest = route.destination;
    final origin = route.origin;
    String text = '';
    if (origin != null) {
      text += '${origin.latitude.toStringAsFixed(1)},${origin.longitude.toStringAsFixed(1)}';
    }
    if (dest != null) {
      if (text.isNotEmpty) text += ' → ';
      text += '${dest.latitude.toStringAsFixed(1)},${dest.longitude.toStringAsFixed(1)}';
    }
    if (route.startDate != null) {
      text += ' · ${DateFormat.MMMd().format(route.startDate!)}';
      if (route.durationDays != null) {
        final end = route.startDate!.add(Duration(days: route.durationDays!));
        text += '-${DateFormat.MMMd().format(end)}';
      }
    }
    return text;
  }

  Widget _buildPostGridHeader() {
    return const Column(
      children: [
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(Icons.grid_on, color: AppColors.textPrimary),
        ),
        Divider(height: 1),
      ],
    );
  }

  Widget _buildPostGrid() {
    if (_loadingPosts) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_posts.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text('No posts yet', style: TextStyle(color: AppColors.grey)),
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
                ? CachedNetworkImage(
                    imageUrl: post.photos.first,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.greyExtraLight),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.greyExtraLight,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  )
                : Container(
                    color: AppColors.greyExtraLight,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      post.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
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
}
