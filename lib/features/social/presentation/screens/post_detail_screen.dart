import 'dart:ui';
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
      final post = await ref
          .read(socialRepositoryProvider)
          .getPost(widget.postId, currentUserId: currentUserId);
      if (mounted) setState(() => _post = post);
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadComments() async {
    setState(() => _isLoadingComments = true);
    try {
      final comments = await ref
          .read(socialRepositoryProvider)
          .getComments(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    try {
      await ref.read(socialProvider.notifier).addComment(widget.postId, text);
      await _loadComments();
    } catch (_) {
      ToastService.showError('Failed to add comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _post == null) {
      return const Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final post = _post;
    if (post == null) {
      return const Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(child: Text('Post not found', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      resizeToAvoidBottomInset: true, // Keyboard handling
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Post', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
      ),
      // Fixed bottom comment input
      bottomNavigationBar: _buildCommentInput(),
      body: RefreshIndicator(
        onRefresh: () async => await _refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Card Area
              _buildHeroCard(post),

              // Caption
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  post.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Divider(color: AppColors.divider, height: 1),
              ),

              // Comments Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments (${_comments.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    if (_isLoadingComments)
                      const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              ),

              // Comments List
              if (_comments.isEmpty && !_isLoadingComments)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      'No comments yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Inter'),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _comments.map((c) => _buildCommentItem(c)).toList(),
                  ),
                ),
              
              const SizedBox(height: 20), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeroCard(Post post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Base Layer: Image
            if (post.photos.isNotEmpty)
              CachedNetworkImage(
                imageUrl: post.photos.first,
                width: double.infinity,
                height: 450,
                fit: BoxFit.cover,
              )
            else
              Container(height: 300, color: AppColors.slate),

            // SEMANTICS OVERLAY: Interactive elements in a clean sibling context
            Positioned.fill(
              child: Stack(
                children: [
                  // Top Left: Author
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Outfit'),
                          ),
                        ],
                      ),
                    ),
                  ),
  
                  // Bottom Left: Likes
                  Positioned(
                    bottom: 16,
                    left: 16,
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // PostCard-style: transparent background with subtle border
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter'),
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                  // NO background, NO border on TextField itself
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
              onPressed: _addComment,
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: comment.author.profile?.photoUrl != null
                ? NetworkImage(comment.author.profile!.photoUrl!)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.author.profile?.name ?? 'Nomad',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Outfit'),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      timeago.format(comment.createdAt),
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.text,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), height: 1.5, fontSize: 14, fontFamily: 'Inter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingPill({required Widget child, required EdgeInsets padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: RepaintBoundary(
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

  Future<void> _refresh() async {
    await Future.wait([_loadPost(), _loadComments()]);
  }

  @override void dispose() { _commentController.dispose(); super.dispose(); }
}
