import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/chat_provider.dart';
import '../../../matches/providers/match_provider.dart';
import '../../../../shared/models/conversation.dart';
import '../../../../shared/models/match.dart'; // Import Match model
import '../../../../shared/models/user.dart'; // Import User model
import '../../../../shared/models/profile.dart'; // Import Profile model
import '../../../auth/providers/auth_provider.dart';
import '../../../safety/providers/safety_provider.dart';

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
      ref.read(safetyProvider.notifier).loadBlockedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatListProvider);
    final matchState = ref.watch(matchProvider);
    final currentUser = ref.watch(authProvider).user;
    final safety = ref.watch(safetyProvider);

    // Filter out blocked users from matches and conversations
    final filteredMatches = matchState.matches
        .where((m) => !safety.isBlocked(m.matchedUserId ?? ''))
        .toList();
    final filteredConversations = chatState.conversations.where((c) {
      final other = c.participants.firstWhere(
        (u) => u.id != currentUser?.id,
        orElse: () => c.participants.first,
      );
      return !safety.isBlocked(other.id ?? '');
    }).toList();

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
                    child: matchState.isLoading && filteredMatches.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : filteredMatches.isEmpty
                            ? _buildEmptyMatches()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: filteredMatches.length,
                                separatorBuilder: (context, index) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final match = filteredMatches[index];
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
          if (chatState.isLoading && filteredConversations.isEmpty)
             const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (filteredConversations.isEmpty)
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
                  final conversation = filteredConversations[index];
                  return _buildConversationItem(context, conversation, currentUser?.id);
                },
                childCount: filteredConversations.length,
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

  Widget _buildMatchAvatar(BuildContext context, Match match, WidgetRef ref) {
    final user = match.matchedUser;
    
    return GestureDetector(
      onTap: () async {
        final conversation = await ref.read(chatListProvider.notifier).createConversation(match.matchedUserId ?? '');

        if (conversation != null && context.mounted) {
             final otherUser = user ??
                User(
                  id: match.matchedUserId ?? '',
                  email: '',
                  profile: Profile(name: 'Match'), // Fallback
                );
             context.push('/chat/${conversation.id}', extra: otherUser);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.greyExtraLight,
            backgroundImage: user?.profile?.photoUrl != null
                ? NetworkImage(user!.profile!.photoUrl!)
                : null,
            child: user?.profile?.photoUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            user?.profile?.name ?? 'Match',
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
        backgroundImage: otherUser.profile?.photoUrl != null
            ? NetworkImage(otherUser.profile!.photoUrl!)
            : null,
        child: otherUser.profile?.photoUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(
        otherUser.profile?.name ?? 'Unknown Nomad',
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
