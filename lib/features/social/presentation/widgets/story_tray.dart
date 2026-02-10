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
    return RepaintBoundary(
      child: Semantics(
        container: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStory(BuildContext context) {
    return GestureDetector(
      onTap: onAddStory,
      child: Container(
        width: 75,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                    color: AppColors.slate.withOpacity(0.3),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
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
            const SizedBox(height: 8),
            const Text(
              'You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
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
        width: 75,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: bundle.hasUnviewed
                      ? [AppColors.primary, const Color(0xFF64B5F6)] // Sunset Orange to Sky Blue
                      : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.obsidian,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.slate,
                  backgroundImage: profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(profile.photoUrl!)
                      : null,
                  child: profile?.photoUrl == null || profile!.photoUrl!.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.username ?? (profile?.name ?? 'User'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: bundle.hasUnviewed ? FontWeight.bold : FontWeight.w500,
                fontFamily: 'Inter',
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
