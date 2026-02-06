import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../providers/social_provider.dart';
import '../../../profile/providers/travelers_provider.dart';
import '../../../activities/providers/activity_provider.dart';
import '../../../auth/providers/auth_provider.dart';

import '../widgets/post_card.dart';
import '../widgets/story_tray.dart';
import '../../../profile/presentation/widgets/traveler_card.dart';
import 'story_view_screen.dart';

class PostsFeedScreen extends ConsumerStatefulWidget {
  const PostsFeedScreen({super.key});

  @override
  ConsumerState<PostsFeedScreen> createState() => _PostsFeedScreenState();
}

class _PostsFeedScreenState extends ConsumerState<PostsFeedScreen> {
  int _activeChipIndex = 0; // 0: Feed, 1: Trips, 2: Activities

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(socialProvider.notifier).loadFeed();
      ref.read(travelersProvider.notifier).loadTravelers();
      ref.read(activityProvider.notifier).loadNearbyActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ref.read(socialProvider.notifier).loadFeed(),
      color: AppColors.primary,
      backgroundColor: AppColors.obsidian,
      child: CustomScrollView(
        slivers: [
          // 1. Stories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: _buildStoriesSection(),
            ),
          ),

          // 2. Navigation Chips (Sticky using standard SliverAppBar)
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.obsidian,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 56,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < _chipLabels.length; i++) ...[
                    _buildChip(i, _chipLabels[i]),
                    if (i < _chipLabels.length - 1) const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
          ),

          // 3. Main Content
          _buildContentSliver(),
          
          // Bottom Spacer for navbar visibility
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  static const List<String> _chipLabels = ['Feed', 'Trips', 'Activities'];

  Widget _buildStoriesSection() {
    final state = ref.watch(socialProvider);
    return StoryTray(
      stories: state.stories,
      onAddStory: () => context.push('/create-story'),
      onStoryTap: (bundle) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryViewScreen(
              stories: bundle.stories,
              user: bundle.user,
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(int index, String label) {
    final isSelected = _activeChipIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeChipIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Adjusted vertical padding
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.white.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.white.withOpacity(0.5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            height: 1.1, // Controlled line height to prevent bottom cutoff
            fontFamily: 'Outfit',
          ),
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    switch (_activeChipIndex) {
      case 0: return _buildFeedSliver();
      case 1: return _buildTravelersSliver();
      case 2: return _buildActivitiesSliver();
      default: return _buildFeedSliver();
    }
  }

  Widget _buildFeedSliver() {
    final state = ref.watch(socialProvider);
    if (state.isLoading && state.posts.isEmpty) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => PostCard(post: state.posts[index]),
        childCount: state.posts.length,
      ),
    );
  }

  Widget _buildTravelersSliver() {
    final state = ref.watch(travelersProvider);
    if (state.isLoading) return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TravelerCard(
            user: state.travelers[index],
            onConnect: () => _handleConnect(state.travelers[index]),
          ),
        ),
        childCount: state.travelers.length,
      ),
    );
  }

  Widget _buildActivitiesSliver() {
    final state = ref.watch(activityProvider);
    if (state.isLoading) return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = state.activities[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.obsidian,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white.withOpacity(0.1)),
            ),
            child: ListTile(
              title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Outfit')),
              subtitle: Text(
                DateFormat('MMM dd, hh:mm a').format(activity.startTime),
                style: TextStyle(color: AppColors.white.withOpacity(0.5), fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
              onTap: () => context.push('/activity/${activity.id}', extra: activity),
            ),
          );
        },
        childCount: state.activities.length,
      ),
    );
  }

  void _handleConnect(User traveler) async {
    try {
      await ref.read(travelersProvider.notifier).connectToUser(traveler.uid);
    } catch (_) {}
  }
}
