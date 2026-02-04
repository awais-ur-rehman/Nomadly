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
          // Stories Section (Horizontal List)
          SliverToBoxAdapter(
            child: SizedBox(
               height: 110,
               child: _StoriesList(state: state, currentUserId: currentUserId),
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

class _StoriesList extends StatelessWidget {
  final dynamic state;
  final String? currentUserId;
  const _StoriesList({required this.state, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    // Simplified Stories List Logic for brevity
    // Note: Ideally extract this to a separate widget file
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.stories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _AddStoryButton();
        final bundle = state.stories[index - 1];
        if (bundle.user.uid == currentUserId) return const SizedBox.shrink(); 
        return _StoryAvatar(bundle: bundle);
      },
    );
  }
}

class _AddStoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/create-story'),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFF0F0F0),
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                     padding: const EdgeInsets.all(4),
                     decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                     child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            const Text("Your Story", style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final dynamic bundle;
  const _StoryAvatar({required this.bundle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewScreen(stories: bundle.stories, user: bundle.user)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(bundle.user.profile?.photoUrl ?? 'https://via.placeholder.com/150'),
              ),
            ),
             const SizedBox(height: 4),
             Text(
               bundle.user.profile?.name ?? 'Anon', 
               style: const TextStyle(fontSize: 10),
               maxLines: 1, 
               overflow: TextOverflow.ellipsis
             ),
          ],
        ),
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
