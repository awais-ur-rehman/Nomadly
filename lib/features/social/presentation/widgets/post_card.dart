import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/post.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/social_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      container: true,
      label: 'Post by ${post.author.profile?.name ?? 'Nomad'}',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Content Container with Floating Pills
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Main Photo (Base Layer)
                  if (post.photos.isNotEmpty)
                    GestureDetector(
                      onTap: () => context.push('/post/${post.id}', extra: post),
                      child: CachedNetworkImage(
                        imageUrl: post.photos.first,
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppColors.slate),
                        errorWidget: (context, url, error) => Container(color: AppColors.slate, child: const Icon(Icons.error)),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: AppColors.slate,
                      child: const Center(child: Icon(Icons.text_fields, color: Colors.white)),
                    ),
  
                  // SEMANTICS OVERLAY: Interactive elements in a clean sibling context
                  Positioned.fill(
                    child: Stack(
                      children: [
                        // Author Pill
                        Positioned(
                          top: 16,
                          left: 16,
                          child: _buildFloatingPill(
                            padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: post.author.profile?.photoUrl != null
                                      ? NetworkImage(post.author.profile!.photoUrl!)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  post.author.profile?.name ?? 'Nomad',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
  
                        // Like Pill
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(socialProvider.notifier).toggleLike(post.id);
                            },
                            child: _buildFloatingPill(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                                    color: post.isLikedByMe ? AppColors.primary : Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${post.likes.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
  
                        // Comment Pill
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => context.push('/post/${post.id}', extra: post),
                            child: _buildFloatingPill(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${post.commentCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
  
            // Caption Section
            if (post.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: '${post.author.profile?.name ?? 'Nomad'} ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                      ),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPill({required Widget child, required EdgeInsets padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bypassing semantics for the blur layer to fix 'parentDataDirty' assertion loop
          Positioned.fill(
            child: RepaintBoundary( // Isolates the expensive blur from the list's repaint/semantics tree
              child: ExcludeSemantics(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
