import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/shared/models/user.dart';
import 'package:nomadly/shared/widgets/profile_header_stats.dart';
import 'package:nomadly/shared/widgets/profile_bio_section.dart';
import 'package:nomadly/shared/widgets/profile_details_section.dart';
import 'package:nomadly/shared/widgets/posts_grid.dart';

class ProfileViewBase extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final profile = user.profile;
    if (profile == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Photo + Stats row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 2,
                          ),
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
                        child: ProfileHeaderStats(
                          postsCount: posts.length,
                          followersCount: user.followerCount ?? 0,
                          followingCount: user.followingCount ?? 0,
                          onFollowersTap: onFollowersTap,
                          onFollowingTap: onFollowingTap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bio Section (Name, Username, Bio, Verification)
                  ProfileBioSection(
                    name: profile.name,
                    username: user.username,
                    bio: profile.bio,
                    verificationLevel: user.verificationLevel,
                    isPrivate: user.isPrivate,
                  ),

                  // Details Section (Rig, Trip, Hobbies)
                  ProfileDetailsSection(
                    rig: user.rig,
                    route: user.travelRoute,
                    hobbies: profile.hobbies,
                  ),

                  const SizedBox(height: 12),

                  // Banner
                  if (banner != null) ...[
                    banner!,
                    const SizedBox(height: 12),
                  ],

                  // Action Buttons
                  if (headerButtons != null) headerButtons!,
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // Post Grid Header
          const SliverToBoxAdapter(
            child: Column(
              children: [
                Divider(height: 1),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.grid_on, color: AppColors.textPrimary),
                ),
                Divider(height: 1),
              ],
            ),
          ),

          // Post Grid or Private Message
          if (!canViewContent && user.isPrivate)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    Text(
                      'This Account is Private',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    const Text(
                      'Follow this user to see their posts and travel routes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            PostsGrid(
              posts: posts,
              isLoading: isPostsLoading,
              emptyMessage: isOwnProfile ? 'No posts yet' : 'This user has no posts',
            ),
        ],
      ),
    );
  }
}
