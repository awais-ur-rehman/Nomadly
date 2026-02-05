import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/models/post.dart';

class PostsGrid extends StatelessWidget {
  final List<Post> posts;
  final bool isLoading;
  final String emptyMessage;

  const PostsGrid({
    super.key,
    required this.posts,
    this.isLoading = false,
    this.emptyMessage = 'No posts yet',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              emptyMessage,
              style: const TextStyle(color: AppColors.grey),
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = posts[index];
          return GestureDetector(
            onTap: () => context.push('/post/${post.id}', extra: post),
            child: post.photos.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: post.photos.first,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.greyExtraLight),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.greyExtraLight,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  )
                : Container(
                    color: AppColors.greyExtraLight,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      post.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
          );
        },
        childCount: posts.length,
      ),
    );
  }
}
