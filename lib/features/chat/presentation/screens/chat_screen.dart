import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/user.dart';
import '../../providers/chat_provider.dart';
import '../../../auth/providers/auth_provider.dart';
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
    if (text.isEmpty) return;

    ref.read(activeChatProvider.notifier).sendMessage(text);
    _messageController.clear();
    // Scroll to bottom
    // _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
                      final isMe = message.sender.id == currentUser?.id;
                      return MessageBubble(message: message, isMe: isMe);
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    onPressed: () {
                      // TODO: Add attachment
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: AppColors.greyExtraLight,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                         // Send typing indicator logic (throttle)
                         if (text.isNotEmpty) {
                           ref.read(activeChatProvider.notifier).sendTyping(true);
                         } else {
                           ref.read(activeChatProvider.notifier).sendTyping(false);
                         }
                      },
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _sendMessage,
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
