import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/chat_provider.dart';
import '../../../matches/providers/match_provider.dart';
import '../../../../shared/models/conversation.dart';
import '../../../auth/providers/auth_provider.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListProvider.notifier).loadConversations();
      ref.read(matchProvider.notifier).loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatListProvider);
    final matchState = ref.watch(matchProvider);
    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Matches Header (Horizontal Scroll)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    'New Matches',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: matchState.isLoading && matchState.matches.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : matchState.matches.isEmpty
                            ? _buildEmptyMatches()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: matchState.matches.length,
                                separatorBuilder: (context, index) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final match = matchState.matches[index];
                                  return _buildMatchAvatar(context, match, ref);
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),

          // Messages Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              child: const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Conversations List
          if (chatState.isLoading && chatState.conversations.isEmpty)
             const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (chatState.conversations.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.grey),
                    const SizedBox(height: 16),
                    const Text('No messages yet'),
                    TextButton(
                      onPressed: () => ref.read(chatListProvider.notifier).loadConversations(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final conversation = chatState.conversations[index];
                  return _buildConversationItem(context, conversation, currentUser?.id);
                },
                childCount: chatState.conversations.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyMatches() {
    return Center(
      child: Text(
        'Go swipe to find matches!',
        style: TextStyle(color: AppColors.grey, fontSize: 12),
      ),
    );
  }

  Widget _buildMatchAvatar(BuildContext context, dynamic match, WidgetRef ref) {
    // Ideally we have match.user populated
    // Helper to start chat
    return GestureDetector(
      onTap: () async {
        // Create conversation if doesn't exist, then navigate
        // Assuming we have matchedUserId
        final matchedUserId = match.matchedUserId; // From Match model (check definition)
        // If we don't have user object, we can't show photo properly yet without fetching
        // Assuming optimistic UI or placeholder
        
        final conversation = await ref.read(chatListProvider.notifier).createConversation(matchedUserId);
        if (conversation != null && context.mounted) {
             // We need 'otherUser' object for ChatScreen
             // Phase 1 shortcut: fetch user details or pass minimal
             // Let's assume we can navigate.
             // For now, let's create a dummy user or fetch it
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.greyExtraLight,
            // backgroundImage: NetworkImage(...)
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 4),
          Text(
            'Name', // Placeholder
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(BuildContext context, Conversation conversation, String? currentUserId) {
    // Find other participant
    final otherUser = conversation.participants.firstWhere(
      (u) => u.id != currentUserId,
      orElse: () => conversation.participants.first, // Fallback
    );

    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: otherUser.profile.photoUrl != null
            ? NetworkImage(otherUser.profile.photoUrl!)
            : null,
        child: otherUser.profile.photoUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(
        otherUser.profile.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conversation.lastMessage ?? 'Started a conversation',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.normal, // Add read/unread logic here
        ),
      ),
      trailing: conversation.lastMessageTime != null
          ? Text(
              DateFormat('MMM d').format(conversation.lastMessageTime!.toLocal()), // Simple format
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            )
          : null,
      onTap: () {
        context.push('/chat/${conversation.id}', extra: otherUser);
      },
    );
  }
}
