import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/post.dart';
import '../../providers/social_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/post/${post.id}', extra: post);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Info
            ListTile(
              leading: CircleAvatar(
                backgroundImage: post.author.profile?.photoUrl != null
                    ? NetworkImage(post.author.profile!.photoUrl!)
                    : null,
                child: post.author.profile?.photoUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(
                post.author.profile?.name ?? 'Unknown Nomad',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('MMM d, h:mm a').format(post.createdAt.toLocal()),
                style: const TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                post.caption,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Images (if any)
            if (post.photos.isNotEmpty)
              SizedBox(
                height: 250,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: post.photos.first,
                  fit: BoxFit.cover,
                ),
              ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                      color: post.isLikedByMe ? Colors.red : null,
                      semanticLabel: post.isLikedByMe ? 'Unlike post' : 'Like post',
                    ),
                    tooltip: post.isLikedByMe ? 'Unlike' : 'Like',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(socialProvider.notifier).toggleLike(post.id);
                    },
                  ),
                  Text(
                    '${post.likes.length}',
                    semanticsLabel: '${post.likes.length} likes',
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, semanticLabel: 'Comment on post'),
                    tooltip: 'Comment',
                    onPressed: () {
                       context.push('/post/${post.id}', extra: post);
                    },
                  ),
                  Text(
                    '${post.commentCount}',
                    semanticsLabel: '${post.commentCount} comments',
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, semanticLabel: 'Share post'),
                    tooltip: 'Share',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
