import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/social_provider.dart';
import '../../../profile/providers/travelers_provider.dart';
import '../../../activities/providers/activity_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Load initial data for tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(travelersProvider.notifier).loadTravelers();
      ref.read(activityProvider.notifier).loadNearbyActivities();
      // Social feed is likely loaded by its own provider on init or here
      ref.read(socialProvider.notifier).loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We don't use Scaffold here because HomeScreen provides it.
    // We use a Column to host the TabBar and the TabBarView.
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Feed'),
                Tab(text: 'Travelers'),
                Tab(text: 'Activities'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _SocialFeedTab(),
                _TravelersTab(),
                _ActivitiesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialFeedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.uid;

    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(socialProvider.notifier).loadFeed(refresh: true),
      child: CustomScrollView(
        slivers: [
          // Stories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: StoryTray(
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
              ),
            ),
          ),
          
          if (state.posts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Icon(Icons.dynamic_feed, size: 60, color: Colors.grey),
                     const SizedBox(height: 16),
                     const Text("Your feed is empty."),
                     TextButton(onPressed: () => ref.refresh(socialProvider), child: const Text("Refresh"))
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => PostCard(post: state.posts[index]),
                childCount: state.posts.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _TravelersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(travelersProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.travelers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "No travelers nearby.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
             const SizedBox(height: 8),
             Text(
              "Travelers heading to your location will appear here.",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.travelers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final traveler = state.travelers[index];
        return TravelerCard(
          user: traveler,
          onConnect: () async {
            try {
               final status = await ref.read(travelersProvider.notifier).connectToUser(traveler.uid);
               if (context.mounted) {
                 final isPending = status == 'pending';
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: Text(
                       isPending 
                       ? 'Connection request sent to ${traveler.username}!' 
                       : 'You are now connected with ${traveler.username}!'
                     ),
                     backgroundColor: isPending ? Colors.orange : Colors.green,
                   )
                 );
               }
            } catch (e) {
               if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Failed to connect: $e'), backgroundColor: Colors.red)
                 );
               }
            }
          },
        );
      },
    );
  }
}

class _ActivitiesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.activities.isEmpty && state.beacons.isEmpty) {
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_activity, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "No activities nearby.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final activity = state.activities[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
               backgroundColor: AppColors.secondary.withOpacity(0.2),
               child: const Icon(Icons.event, color: AppColors.secondary),
            ),
            title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${activity.startTime} • ${activity.participants.length} joined'),
            trailing: ElevatedButton(
              onPressed: () {
                 ref.read(activityProvider.notifier).joinActivity(activity.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Join'),
            ),
            onTap: () {
              context.push('/activity/${activity.id}', extra: activity);
            },
          ),
        );
      },
    );
  }
}
