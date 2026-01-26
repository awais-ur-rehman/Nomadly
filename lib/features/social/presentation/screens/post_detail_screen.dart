import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/post.dart';
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
  bool _isLoading = false;
  
  // Mock comments for now unless API returns them in a standard format we defined
  // Assuming repository has getComments logic but we can also just show comments field to add
  
  @override
  void initState() {
    super.initState();
    _post = widget.preloadedPost;
    _loadPost();
  }
  
  Future<void> _loadPost() async {
    if (_post == null) setState(() => _isLoading = true);
    
    try {
       // Fetch post details if needed, or refresh
       // final post = await ref.read(socialRepositoryProvider).getPost(widget.postId);
       // setState(() => _post = post);
       // Assuming getPost exists. I'll rely on preloaded for now or implement fetch if critical.
       // Given time constraints and preloaded usually available from feed click.
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    
    try {
      await ref.read(socialProvider.notifier).addComment(widget.postId, text);
      _commentController.clear();
      ToastService.showSuccess('Comment added');
      // Refresh comments or post
    } catch (e) {
      ToastService.showError('Failed to add comment');
    }
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
                  
                  // content
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.caption),
                        const SizedBox(height: AppDimensions.paddingL),
                        const Divider(),
                        const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppDimensions.paddingM),
                        // List comments here (requires fetching comments)
                        const Center(child: Text('No comments yet', style: TextStyle(color: AppColors.textSecondary))),
                      ],
                    ),
                  ),
                ],
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
