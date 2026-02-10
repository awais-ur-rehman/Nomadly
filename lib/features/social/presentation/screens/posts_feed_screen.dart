import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/social_provider.dart';

import '../widgets/post_card.dart';
import '../widgets/story_tray.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(socialProvider.notifier).loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(socialProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(socialProvider.notifier).loadFeed(),
      color: AppColors.primary,
      backgroundColor: AppColors.obsidian,
      child: CustomScrollView(
        slivers: [
          // 1. Stories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: _buildStoriesSection(),
            ),
          ),

          // 2. Posts Feed
          if (state.isLoading && state.posts.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (state.posts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No posts yet',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Follow travelers to see their posts',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
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

          // Bottom Spacer for navbar visibility
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

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
}
