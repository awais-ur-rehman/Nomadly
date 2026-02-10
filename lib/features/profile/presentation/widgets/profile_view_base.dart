import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/shared/models/user.dart';
import 'package:nomadly/features/profile/presentation/widgets/verification_badge.dart';

class ProfileViewBase extends StatefulWidget {
  final User user;
  final List<Post> posts;
  final bool isPostsLoading;
  final bool isOwnProfile;
  final bool canViewContent;
  final Widget? headerButtons;
  final Widget? banner;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onSettingsTap;

  const ProfileViewBase({
    super.key,
    required this.user,
    required this.posts,
    this.isPostsLoading = false,
    this.isOwnProfile = false,
    this.canViewContent = true,
    this.headerButtons,
    this.banner,
    this.onRefresh,
    this.onFollowersTap,
    this.onFollowingTap,
    this.onSettingsTap,
  });

  @override
  State<ProfileViewBase> createState() => _ProfileViewBaseState();
}

class _ProfileViewBaseState extends State<ProfileViewBase> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.user.profile;
    if (profile == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Custom Header (Username + Settings)
          SliverToBoxAdapter(
            child: _buildCustomHeader(),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: _buildProfileContent(profile),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: _tabController,
            ),
          ),

          // Tab Content
          if (!widget.canViewContent && widget.user.isPrivate)
            _buildPrivateAccountMessage()
          else
            _buildPostGrid(),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Username on left
          Row(
            children: [
              Text(
                widget.user.username ?? 'nomad',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: AppColors.white,
                ),
              ),
              if (widget.user.isPrivate) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.lock,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ],
          ),
          // Settings icon on right
          GestureDetector(
            onTap: widget.onSettingsTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.slate.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(Profile profile) {
    final rig = widget.user.rig;
    final route = widget.user.travelRoute;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Centered Profile Photo
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
                  ? CachedNetworkImage(
                      imageUrl: profile.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.slate,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.slate,
                        child: const Icon(Icons.person, size: 45, color: AppColors.grey),
                      ),
                    )
                  : Container(
                      color: AppColors.slate,
                      child: const Icon(Icons.person, size: 45, color: AppColors.grey),
                    ),
            ),
          ),
          const SizedBox(height: 14),

          // Name + Verification Badge
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
              if (widget.user.verificationLevel > 0) ...[
                const SizedBox(width: 8),
                VerificationBadge(level: widget.user.verificationLevel),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Stats Row (transparent)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('${widget.posts.length}', 'Posts'),
              GestureDetector(
                onTap: widget.onFollowersTap,
                child: _buildStatItem(_formatCount(widget.user.followerCount), 'Followers'),
              ),
              GestureDetector(
                onTap: widget.onFollowingTap,
                child: _buildStatItem(_formatCount(widget.user.followingCount), 'Following'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bio Section
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

          // Compact Info Row (Rig + Route)
          _buildCompactInfo(rig, route),

          // Hobbies (max 3)
          if (profile.hobbies.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildHobbiesRow(profile.hobbies),
          ],

          const SizedBox(height: 16),

          // Banner (Marketplace)
          if (widget.banner != null) ...[
            widget.banner!,
            const SizedBox(height: 12),
          ],

          // Action Buttons
          if (widget.headerButtons != null) widget.headerButtons!,

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

    // Rig info
    if (rig != null && rig.type != null) {
      infoParts.add(_buildInfoChip(
        Icons.directions_car_outlined,
        _formatRigType(rig.type!),
      ));
    }

    // Travel route - show simplified version
    if (route != null && route.destination != null) {
      infoParts.add(_buildInfoChip(
        Icons.route_outlined,
        'On the Road',
      ));
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

  Widget _buildPrivateAccountMessage() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.slate,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 50,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This Account is Private',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Follow this user to see their posts and travel routes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostGrid() {
    if (widget.isPostsLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (widget.posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 60,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isOwnProfile ? 'Share your first post' : 'No posts yet',
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
          final post = widget.posts[index];
          return GestureDetector(
            onTap: () => context.push('/post/${post.id}', extra: post),
            child: post.photos.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: post.photos.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.slate),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.slate,
                      child: const Icon(Icons.broken_image, color: Colors.white24),
                    ),
                  )
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
        childCount: widget.posts.length,
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _TabBarDelegate({required this.tabController});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.obsidian,
      child: TabBar(
        controller: tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        labelColor: AppColors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
        tabs: const [
          Tab(icon: Icon(Icons.grid_on, size: 24)),
          Tab(icon: Icon(Icons.alternate_email, size: 24)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
