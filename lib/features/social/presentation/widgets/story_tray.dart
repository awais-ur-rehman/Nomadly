import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/post.dart';

class StoryTray extends StatelessWidget {
  final List<StoryBundle> stories;
  final VoidCallback? onAddStory;
  final Function(StoryBundle)? onStoryTap;

  const StoryTray({
    super.key,
    required this.stories,
    this.onAddStory,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + (onAddStory != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (onAddStory != null && index == 0) {
            return _buildAddStory(context);
          }
          final bundle = stories[onAddStory != null ? index - 1 : index];
          return _buildStoryItem(context, bundle);
        },
      ),
    );
  }

  Widget _buildAddStory(BuildContext context) {
    return GestureDetector(
      onTap: onAddStory,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Your Story',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryBundle bundle) {
    final user = bundle.user;
    final profile = user.profile;

    return GestureDetector(
      onTap: () => onStoryTap?.call(bundle),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: bundle.hasUnviewed
                      ? [AppColors.primary, AppColors.secondary]
                      : [Colors.grey[300]!, Colors.grey[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(profile.photoUrl!)
                      : null,
                  child: profile?.photoUrl == null || profile!.photoUrl!.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              user.username ?? (profile?.name ?? 'User'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: bundle.hasUnviewed ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
