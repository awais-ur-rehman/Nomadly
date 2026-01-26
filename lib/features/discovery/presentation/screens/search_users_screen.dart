import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/user_provider.dart';

class SearchUsersScreen extends ConsumerStatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  ConsumerState<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends ConsumerState<SearchUsersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      ref.read(userSearchProvider.notifier).searchUsers(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Colors.black)),
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
      body: Column(
        children: [
          // Search Field
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                if (value.isEmpty) {
                  ref.read(userSearchProvider.notifier).clear();
                }
              },
              onSubmitted: _performSearch,
            ),
          ),

          // Results
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState.results.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Search for nomads by name or username'
                              : 'No users found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchState.results.length,
                        itemBuilder: (context, index) {
                          final user = searchState.results[index];
                          return _UserSearchItem(user: user);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _UserSearchItem extends ConsumerWidget {
  final user;

  const _UserSearchItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: user.profile?.photoUrl != null
            ? CachedNetworkImageProvider(user.profile!.photoUrl!)
            : null,
        child: user.profile?.photoUrl == null
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Row(
        children: [
          Text(
            user.profile?.name ?? user.username ?? 'Unknown',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (user.nomadId?.verified == true) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.verified,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ],
      ),
      subtitle: Text(
        '@${user.username ?? ''}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: _FollowButton(
        userId: user.uid,
        isFollowing: user.isFollowing,
        isFollowingPending: user.isFollowingPending,
        isPrivate: user.isPrivate,
      ),
      onTap: () {
        context.push('/user/${user.uid}');
      },
    );
  }
}

class _FollowButton extends ConsumerWidget {
  final String userId;
  final bool isFollowing;
  final bool isFollowingPending;
  final bool isPrivate;

  const _FollowButton({
    required this.userId,
    required this.isFollowing,
    required this.isFollowingPending,
    required this.isPrivate,
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

    return SizedBox(
      width: 100,
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          ref.read(userSearchProvider.notifier).toggleFollow(userId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
