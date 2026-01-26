import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/post.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/social_provider.dart';
import '../widgets/post_card.dart';
import 'story_view_screen.dart';

class PostsFeedScreen extends ConsumerWidget {
  const PostsFeedScreen({super.key});
  
  static final _logger = Logger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.uid;

    // Debug logging
    _logger.d('📖 [UI] Building feed - Total story bundles: ${state.stories.length}');
    _logger.d('📖 [UI] Current user ID: $currentUserId');
    
    // Find user's own story bundle
    final userStoryIndex = state.stories.indexWhere(
      (bundle) => bundle.user.uid == currentUserId
    );
    final hasUserStory = userStoryIndex != -1;
    
    _logger.d('📖 [UI] User has story: $hasUserStory (index: $userStoryIndex)');
    if (hasUserStory) {
      final userBundle = state.stories[userStoryIndex];
      _logger.d('📖 [UI] User story bundle - Stories: ${userBundle.stories.length}, HasUnviewed: ${userBundle.hasUnviewed}');
    }

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
                  itemCount: state.stories.length + 1, // +1 for user's story/add button
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    _logger.d('📖 [UI] Building story item at index $index');
                    
                    if (index == 0) {
                      // First position: Always show user's story or add button
                      if (hasUserStory) {
                        final userBundle = state.stories[userStoryIndex];
                        _logger.d('📖 [UI] Index 0: Showing user story with ${userBundle.stories.length} stories');
                        return _buildUserStory(context, userBundle, ref);
                      } else {
                        _logger.d('📖 [UI] Index 0: Showing add story button');
                        return _buildAddStory(context);
                      }
                    }
                    
                    // For other positions, show other users' stories
                    // Adjust index to account for user's story being at position 0
                    final storyIndex = hasUserStory && index - 1 >= userStoryIndex 
                        ? index  // If user story was removed from its original position, shift
                        : index - 1;
                    
                    if (storyIndex >= state.stories.length) {
                      _logger.d('📖 [UI] Index $index: Out of bounds, returning empty');
                      return const SizedBox.shrink();
                    }
                    
                    final bundle = state.stories[storyIndex];
                    
                    // Skip if this is the user's story (already shown at index 0)
                    if (bundle.user.uid == currentUserId) {
                      _logger.d('📖 [UI] Index $index: Skipping duplicate user story');
                      return const SizedBox.shrink();
                    }
                    
                    _logger.d('📖 [UI] Index $index: Showing ${bundle.user.profile?.name}\'s story');
                    return _buildStoryItem(context, bundle, false);
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

  Widget _buildAddStory(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/create-story'),
      child: Column(
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
      ),
    );
  }

  Widget _buildUserStory(BuildContext context, StoryBundle bundle, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewScreen(
              stories: bundle.stories,
              user: bundle.user,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: bundle.allViewed ? AppColors.grey : AppColors.primary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: bundle.user.profile?.photoUrl != null
                      ? NetworkImage(bundle.user.profile!.photoUrl!)
                      : null,
                  child: bundle.user.profile?.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => context.push('/create-story'),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Your Story', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryBundle bundle, bool isCurrentUser) {
    if (bundle.stories.isEmpty) return const SizedBox.shrink();
    final user = bundle.user;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewScreen(
              stories: bundle.stories,
              user: bundle.user,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: bundle.allViewed ? AppColors.grey : AppColors.primary, 
                width: 2
              ),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: user.profile?.photoUrl != null
                  ? NetworkImage(user.profile!.photoUrl!)
                  : null,
              child: user.profile?.photoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.profile?.name ?? 'Anon',
            style: const TextStyle(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
