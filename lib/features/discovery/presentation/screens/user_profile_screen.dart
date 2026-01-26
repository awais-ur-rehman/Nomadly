import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/user_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final currentUser = ref.watch(authProvider).user;
    final isOwnProfile = currentUser?.uid == widget.userId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          profileState.user?.username ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
              ? Center(child: Text('Error: ${profileState.error}'))
              : profileState.user == null
                  ? const Center(child: Text('User not found'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(userProfileProvider.notifier)
                            .loadUserProfile(widget.userId);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Header
                            _ProfileHeader(
                              user: profileState.user!,
                              isOwnProfile: isOwnProfile,
                            ),

                            const SizedBox(height: AppDimensions.paddingL),

                            // Posts Grid or Privacy Message
                            if (!profileState.canViewPosts && profileState.isPrivate)
                              _PrivateAccountMessage()
                            else if (profileState.posts.isEmpty)
                              const _NoPostsMessage()
                            else
                              _PostsGrid(posts: profileState.posts),
                          ],
                        ),
                      ),
                    ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final user;
  final bool isOwnProfile;

  const _ProfileHeader({
    required this.user,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo and Stats
          Row(
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 40,
                backgroundImage: user.profile?.photoUrl != null
                    ? CachedNetworkImageProvider(user.profile!.photoUrl!)
                    : null,
                child: user.profile?.photoUrl == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: AppDimensions.paddingL),

              // Stats
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final profileState = ref.watch(userProfileProvider);
                    final postsCount = profileState.posts.length;
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatColumn(
                          label: 'Posts',
                          count: postsCount,
                        ),
                        _StatColumn(
                          label: 'Followers',
                          count: user.followerCount ?? 0,
                        ),
                        _StatColumn(
                          label: 'Following',
                          count: user.followingCount ?? 0,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Name and Verification
          Row(
            children: [
              Text(
                user.profile?.name ?? user.username ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (user.nomadId?.verified == true) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
              if (user.isPrivate) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.lock,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ],
          ),

          // Bio
          if (user.profile?.bio != null) ...[
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              user.profile!.bio!,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ],

          const SizedBox(height: AppDimensions.paddingM),

          // Follow Button (if not own profile)
          if (!isOwnProfile)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: _ProfileFollowButton(
                userId: user.uid,
                isFollowing: user.isFollowing,
                isFollowingPending: user.isFollowingPending,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int count;

  const _StatColumn({
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ProfileFollowButton extends ConsumerWidget {
  final String userId;
  final bool isFollowing;
  final bool isFollowingPending;

  const _ProfileFollowButton({
    required this.userId,
    required this.isFollowing,
    required this.isFollowingPending,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String buttonText;
    Color buttonColor;
    Color textColor;

    if (isFollowing) {
      buttonText = 'Following';
      buttonColor = Colors.grey[200]!;
      textColor = Colors.black;
    } else if (isFollowingPending) {
      buttonText = 'Requested';
      buttonColor = Colors.grey[200]!;
      textColor = Colors.black;
    } else {
      buttonText = 'Follow';
      buttonColor = AppColors.primary;
      textColor = Colors.white;
    }

    return ElevatedButton(
      onPressed: () {
        ref.read(userProfileProvider.notifier).toggleFollow();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _PrivateAccountMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            'Follow to see their posts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoPostsMessage extends StatelessWidget {
  const _NoPostsMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'No Posts Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostsGrid extends StatelessWidget {
  final List posts;

  const _PostsGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final imageUrl = post.photos.isNotEmpty ? post.photos[0] : null;

        return GestureDetector(
          onTap: () {
            context.push('/post/${post.id}', extra: post);
          },
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                )
              : Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
        );
      },
    );
  }
}
