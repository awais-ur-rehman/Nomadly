import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/features/discovery/providers/user_provider.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';
import 'package:nomadly/features/profile/presentation/widgets/profile_view_base.dart';

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
      body: profileState.isLoading && profileState.user == null
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
              ? Center(child: Text('Error: ${profileState.error}'))
              : profileState.user == null
                  ? const Center(child: Text('User not found'))
                  : ProfileViewBase(
                      user: profileState.user!,
                      posts: profileState.posts,
                      isPostsLoading: profileState.isLoading,
                      isOwnProfile: isOwnProfile,
                      canViewContent: profileState.canViewPosts,
                      onRefresh: () => ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId),
                      headerButtons: isOwnProfile
                          ? null
                          : SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: _ProfileFollowButton(
                                userId: widget.userId,
                                isFollowing: profileState.user!.isFollowing,
                                isFollowingPending: profileState.user!.isFollowingPending,
                              ),
                            ),
                    ),
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
