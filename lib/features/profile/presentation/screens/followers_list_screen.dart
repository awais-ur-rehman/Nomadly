import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../providers/profile_provider.dart';

class FollowersListScreen extends ConsumerStatefulWidget {
  final String userId;
  final int initialTab; // 0 for followers, 1 for following

  const FollowersListScreen({
    super.key, 
    required this.userId, 
    this.initialTab = 0,
  });

  @override
  ConsumerState<FollowersListScreen> createState() => _FollowersListScreenState();
}

class _FollowersListScreenState extends ConsumerState<FollowersListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<User>? _followers;
  List<User>? _following;
  bool _isLoadingFollowers = false;
  bool _isLoadingFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(profileRepositoryProvider);

    // Load Followers
    setState(() => _isLoadingFollowers = true);
    try {
      final followers = await repo.getFollowers(widget.userId);
      if (mounted) setState(() => _followers = followers);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoadingFollowers = false);
    }

    // Load Following
    setState(() => _isLoadingFollowing = true);
    try {
      final following = await repo.getFollowing(widget.userId);
      if (mounted) setState(() => _following = following);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoadingFollowing = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(_followers, _isLoadingFollowers, 'No followers yet'),
          _buildUserList(_following, _isLoadingFollowing, 'Not following anyone yet'),
        ],
      ),
    );
  }

  Widget _buildUserList(List<User>? users, bool isLoading, String emptyMessage) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users == null || users.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final profile = user.profile;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.greyExtraLight,
            backgroundImage: (profile?.photoUrl != null) 
                ? CachedNetworkImageProvider(profile!.photoUrl!) 
                : null,
            child: (profile?.photoUrl == null)
                ? const Icon(Icons.person, color: AppColors.grey)
                : null,
          ),
          title: Text(profile?.name ?? 'Unknown'),
          subtitle: user.rig != null 
              ? Text('${user.rig?.type?.toUpperCase() ?? ''} • ${user.rig?.crewType?.toUpperCase() ?? ''}')
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to user profile
            context.push('/profile/${user.id}', extra: user);
          },
        );
      },
    );
  }
}
