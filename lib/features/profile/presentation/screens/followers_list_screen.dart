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
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Network',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
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
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (users == null || users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 60,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'Inter',
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final profile = user.profile;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/profile/${user.uid}', extra: user),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: (profile?.photoUrl != null)
                          ? CachedNetworkImage(
                              imageUrl: profile!.photoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: AppColors.slate),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.slate,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.slate,
                              child: Icon(
                                Icons.person,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name and info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.name ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        if (user.rig != null && user.rig?.type != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatRigType(user.rig!.type!),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                ),
                              ),
                              if (user.rig?.crewType != null) ...[
                                Text(
                                  ' • ',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                Text(
                                  _capitalize(user.rig!.crewType!),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Chevron
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatRigType(String type) {
    return type.split('_').map((word) =>
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
