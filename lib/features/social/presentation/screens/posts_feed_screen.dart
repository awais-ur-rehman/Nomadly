import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/post.dart';
import '../../providers/social_provider.dart';
import '../widgets/post_card.dart';
import 'story_view_screen.dart';

class PostsFeedScreen extends ConsumerWidget {
  const PostsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(socialProvider.notifier).loadFeed(refresh: true),
        child: CustomScrollView(
          slivers: [
            // Stories Section
            SliverToBoxAdapter(
              child: Container(
                height: 120,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.stories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAddStory();
                    }
                    final story = state.stories[index - 1];
                    return _buildStoryItem(context, story, state.stories, index - 1);
                  },
                ),
              ),
            ),

            // Posts List
            if (state.isLoading && state.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.posts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.post_add, size: 64, color: AppColors.grey),
                      const SizedBox(height: 16),
                      const Text('No posts yet. Start following people!'),
                      TextButton(
                        onPressed: () => ref.read(socialProvider.notifier).loadFeed(refresh: true),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PostCard(post: state.posts[index]);
                    },
                    childCount: state.posts.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddStory() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.greyExtraLight,
              child: Icon(Icons.person, color: AppColors.grey),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Your Story', style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildStoryItem(BuildContext context, Story story, List<Story> allStories, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewScreen(stories: allStories, initialIndex: index),
          ),
        );
      },
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
              backgroundImage: story.author.profile?.photoUrl != null
                  ? NetworkImage(story.author.profile!.photoUrl!)
                  : null,
              child: story.author.profile?.photoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            story.author.profile?.name ?? 'Anon',
            style: const TextStyle(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
