import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/chat_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../safety/providers/safety_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final User? otherUser; // Passing minimal user info for app bar

  const ChatScreen({
    super.key,
    required this.conversationId,
    this.otherUser,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  bool _isSendingImage = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid state modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeChatProvider.notifier).setActiveConversation(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    if (_selectedImage != null) {
      _sendSelectedImage();
    } else {
      ref.read(activeChatProvider.notifier).sendMessage(text);
      _messageController.clear();
    }
  }

  Future<void> _sendSelectedImage() async {
    if (_selectedImage == null || _isSendingImage) return;

    setState(() => _isSendingImage = true);

    try {
      await ref.read(activeChatProvider.notifier).sendImageMessage(_selectedImage!.path);
      if (mounted) {
        setState(() {
          _selectedImage = null;
          _isSendingImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSendingImage = false);
        ToastService.showError('Failed to send image');
      }
    }
  }

  void _clearSelectedImage() {
    setState(() => _selectedImage = null);
  }

  void _showSafetySheet(BuildContext context) {
    final otherUserId = widget.otherUser?.id;
    if (otherUserId == null || otherUserId.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User'),
              subtitle: const Text('They won\'t be able to contact you'),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Block User?'),
                    content: const Text(
                      'They won\'t be able to see your profile or message you. You can unblock them later from settings.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Block', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  final success = await ref.read(safetyProvider.notifier).blockUser(otherUserId);
                  if (success && mounted) {
                    ToastService.showSuccess('User blocked');
                    context.pop();
                  } else if (mounted) {
                    ToastService.showError('Failed to block user');
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Report User'),
              subtitle: const Text('Let us know what\'s wrong'),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog(context, otherUserId);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, String userId) {
    const reasons = [
      ('harassment', 'Harassment'),
      ('fake_profile', 'Fake Profile'),
      ('inappropriate_content', 'Inappropriate Content'),
      ('spam', 'Spam'),
      ('threatening_behavior', 'Threatening Behavior'),
      ('scam', 'Scam'),
      ('other', 'Other'),
    ];

    String? selectedReason;
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Report User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a reason:'),
                const SizedBox(height: 8),
                ...reasons.map((r) => RadioListTile<String>(
                  value: r.$1,
                  groupValue: selectedReason,
                  title: Text(r.$2, style: const TextStyle(fontSize: 14)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setDialogState(() => selectedReason = v),
                )),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Additional details (optional)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                if (selectedReason == null) {
                  ToastService.showError('Select a reason');
                  return;
                }
                Navigator.pop(ctx);
                final success = await ref.read(safetyProvider.notifier).reportUser(
                  userId,
                  selectedReason!,
                  description: descController.text.trim(),
                );
                if (mounted) {
                  success
                      ? ToastService.showSuccess('Report submitted')
                      : ToastService.showError('Failed to submit report');
                }
              },
              child: const Text('Submit', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeChatProvider);
    final currentUser = ref.watch(authProvider).user;
    
    // Only show messages for this conversation
    if (state.conversationId != widget.conversationId) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.otherUser?.profile?.photoUrl != null
                  ? NetworkImage(widget.otherUser!.profile!.photoUrl!)
                  : null,
              child: widget.otherUser?.profile?.photoUrl == null
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser?.profile?.name ?? 'Nomad',
                  style: const TextStyle(fontSize: 16),
                ),
                if (state.isTyping)
                  const Text(
                    'typing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.isLoading && state.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.sender.uid == currentUser?.uid;
                      return MessageBubble(message: message, isMe: isMe);
                    },
                  ),
          ),
          
          // Image Preview (if selected)
          if (_selectedImage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.obsidian,
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: _clearSelectedImage,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                      if (_isSendingImage)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ready to send',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.obsidian,
              border: _selectedImage == null
                  ? Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))
                  : null,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() => _selectedImage = File(image.path));
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.primary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                        decoration: InputDecoration(
                          hintText: _selectedImage != null ? 'Add a caption...' : 'Type a message...',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            ref.read(activeChatProvider.notifier).sendTyping(true);
                          } else {
                            ref.read(activeChatProvider.notifier).sendTyping(false);
                          }
                        },
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isSendingImage ? null : _sendMessage,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
