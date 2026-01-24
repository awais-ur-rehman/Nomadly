import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/match_provider.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.matches.isEmpty) {
      return Center(
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
              onPressed: () => ref.read(matchProvider.notifier).loadMatches(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      itemCount: state.matches.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final match = state.matches[index];
        // TODO: Ensure we have user details. For now showing placeholders if data missing.
        // Assuming we need to fetch user separately or it's expanded in listing.
        // Let's assume we have a way to display at least ID or fetch on demand.
        // In a real scenario, the match object should have an expanded 'matchedUser' field.
        // For Phase 1, I'll display a generic item connecting to the Chat.
        
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.greyExtraLight,
            child: Icon(Icons.person),
            // backgroundImage: NetworkImage(match.user?.profile.photoUrl ?? ''), 
          ),
          title: Text('Match ${index + 1}'), // Placeholder name
          subtitle: const Text('New match!'),
          trailing: IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to chat with this match
            },
          ),
          onTap: () {
            // TODO: View profile
          },
        );
      },
    );
  }
}
