import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/models/comment.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/social_provider.dart';
import '../../data/repositories/social_repository.dart';
import '../../../../shared/services/toast_service.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  final Post? preloadedPost;

  const PostDetailScreen({super.key, required this.postId, this.preloadedPost});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  Post? _post;
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _isLoadingComments = false;
  
  @override
  void initState() {
    super.initState();
    _post = widget.preloadedPost;
    _loadPost();
    _loadComments();
  }
  
  Future<void> _loadPost() async {
    if (_post == null) setState(() => _isLoading = true);
    
    try {
       final currentUserId = ref.read(authProvider).user?.uid;
       final post = await ref.read(socialRepositoryProvider).getPost(
         widget.postId,
         currentUserId: currentUserId,
       );
       if (mounted) {
         setState(() => _post = post);
       }
    } catch (e) {
      // Keep preloaded post if fetch fails
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadComments() async {
    setState(() => _isLoadingComments = true);
    
    try {
      final comments = await ref.read(socialRepositoryProvider).getComments(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingComments = false);
      }
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || text.length > 1000) return;
    
    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

    // Create optimistic comment
    final optimisticComment = Comment(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.postId,
      author: currentUser,
      text: text,
      createdAt: DateTime.now(),
      isPending: true,
    );

    // Add to UI immediately
    setState(() {
      _comments.insert(0, optimisticComment);
    });

    // Clear input
    _commentController.clear();
    FocusScope.of(context).unfocus();
    
    try {
      await ref.read(socialProvider.notifier).addComment(widget.postId, text);
      
      // Reload comments to get the real one from server
      await _loadComments();
    } catch (e) {
      // Remove optimistic comment on error
      if (mounted) {
        setState(() {
          _comments.removeWhere((c) => c.id == optimisticComment.id);
        });
        ToastService.showError('Failed to add comment');
      }
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      _loadPost(),
      _loadComments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _post == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final post = _post;
    if (post == null) return const Scaffold(body: Center(child: Text('Post not found')));

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Header
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: post.author.profile?.photoUrl != null
                            ? CachedNetworkImageProvider(post.author.profile!.photoUrl!)
                            : null,
                        child: post.author.profile?.photoUrl == null ? const Icon(Icons.person) : null,
                      ),
                      title: Text(post.author.profile?.name ?? 'Unknown'),
                      subtitle: Text(timeago.format(post.createdAt)),
                    ),
                    
                    // Post Image
                    if (post.photos.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: post.photos.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          height: 300,
                          color: AppColors.greyExtraLight,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.caption),
                          const SizedBox(height: AppDimensions.paddingM),
                          
                          // Like and Comment Actions
                          Row(
                            children: [
                              // Like Button
                              IconButton(
                                icon: Icon(
                                  post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                                  color: post.isLikedByMe ? Colors.red : AppColors.grey,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  ref.read(socialProvider.notifier).toggleLike(post.id);
                                  // Note: Like state updates optimistically
                                  // Pull-to-refresh to get server data
                                },
                              ),
                              Text('${post.likes.length} likes'),
                              const SizedBox(width: 16),
                              const Icon(Icons.chat_bubble_outline, color: AppColors.grey, size: 20),
                              const SizedBox(width: 4),
                              Text('${_comments.length} comments'),
                            ],
                          ),
                          
                          const SizedBox(height: AppDimensions.paddingL),
                          const Divider(),
                          const SizedBox(height: AppDimensions.paddingM),
                          
                          // Comments Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (_isLoadingComments)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.paddingM),
                          
                          // Comments List
                          if (_comments.isEmpty && !_isLoadingComments)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'No comments yet.\nBe the first to comment!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          else
                            ..._comments.map((comment) => _buildCommentItem(comment)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Comment Input
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.greyLight)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                      maxLength: 1000,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                        if (!isFocused || currentLength == 0) return null;
                        return Text(
                          '$currentLength/$maxLength',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Opacity(
      opacity: comment.isPending ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: comment.author.profile?.photoUrl != null
                  ? CachedNetworkImageProvider(comment.author.profile!.photoUrl!)
                  : null,
              child: comment.author.profile?.photoUrl == null
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.author.profile?.name ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeago.format(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (comment.isPending) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
