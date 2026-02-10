import 'package:logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/match_provider.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    // Refresh matches whenever this screen is built/mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchProvider.notifier).loadMatches();
    });
  }

  Future<void> _refresh() async {
    await ref.read(matchProvider.notifier).loadMatches();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchProvider);

    if (state.isLoading && state.matches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.matches.isEmpty) {
      return Center(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: AppColors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No matches yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start swiping to find your tribe!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        itemCount: state.matches.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final match = state.matches[index];
          final matchedUser = match.matchedUser;
          final name = matchedUser?.profile?.name ?? matchedUser?.username ?? 'Nomad';
          final photoUrl = matchedUser?.profile?.photoUrl;
          final conversationId = match.safeConversationId;

          _logger.d('👥 [MatchesUI] Rendering match: $name, ConvID: $conversationId');

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.greyExtraLight,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null ? const Icon(Icons.person) : null,
            ),
            title: Text(name),
            subtitle: const Text('Matched!'),
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              onPressed: () {
                 if (conversationId != null) {
                    context.push('/chat/$conversationId');
                 } else {
                    // Fallback to profile if something is wrong
                    context.push('/profile/${matchedUser?.id ?? match.matchedUserId}');
                 }
              },
            ),
            onTap: () {
              if (conversationId != null) {
                 context.push('/chat/$conversationId');
              } else {
                 context.push('/profile/${matchedUser?.id ?? match.matchedUserId}');
              }
            },
          );
        },
      ),
    );
  }
}
