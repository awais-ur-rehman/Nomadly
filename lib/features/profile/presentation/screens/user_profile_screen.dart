import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/user.dart';
import '../../providers/profile_provider.dart';
import '../../../chat/providers/chat_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final User? preloadedUser; // Optional for instant load

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.preloadedUser,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);
    final user = state.user ?? widget.preloadedUser;
    final isLoading = state.isLoading && user == null;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null && state.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    final profile = user.profile;
    if (profile == null) {
      return const Scaffold(body: Center(child: Text('User profile not found')));
    }
    final rig = user.rig;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header Image
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (profile.photoUrl != null)
                    CachedNetworkImage(
                      imageUrl: profile.photoUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: AppColors.grey),
                  
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),

                  // Name Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                             Text(
                              '${profile.name}, ${profile.age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.nomadId?.verified == true) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: AppColors.primary, size: 28),
                            ],
                          ],
                        ),
                        if (rig != null)
                           Text(
                            '${rig.type.toUpperCase()} • ${rig.crewType.toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Action Buttons
                  Row(
                    children: [
                       Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final conversation = await ref.read(chatListProvider.notifier).createConversation(user.id);
                            if (conversation != null && context.mounted) {
                               context.push('/chat/${conversation.id}', extra: user);
                            }
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                             backgroundColor: AppColors.primary,
                             foregroundColor: Colors.white,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Vouch Button (Placeholder)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: const Text('Vouch'),
                          style: OutlinedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sections
                  _buildSectionTitle('About'),
                  Text(
                    profile.bio ?? 'No bio available.',
                    style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textSecondary),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (profile.hobbies.isNotEmpty) ...[
                    _buildSectionTitle('Interests'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.hobbies.map((hobby) => Chip(
                        label: Text(hobby),
                        backgroundColor: AppColors.primaryExtraLight,
                        labelStyle: const TextStyle(color: AppColors.primary),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (rig != null) ...[
                     _buildSectionTitle('Rig Details'),
                     _buildInfoRow('Type', rig.type),
                     _buildInfoRow('Crew', rig.crewType),
                     _buildInfoRow('Pets', rig.petFriendly ? 'Pet Friendly' : 'No Pets'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
