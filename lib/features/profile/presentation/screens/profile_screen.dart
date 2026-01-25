import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = user.profile;
    final rig = user.rig;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Settings screen
            },
          ),
          IconButton(
             icon: const Icon(Icons.logout, color: AppColors.error),
             onPressed: () {
               ref.read(authProvider.notifier).logout();
               // Navigation handled by router redirect usually, or force it:
               context.go('/onboarding');
             },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.paddingL),
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profile.photoUrl != null
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child: profile.photoUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),

            // Name & Age
            Text(
              '${profile.name}, ${profile.age}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user.nomadId?.verified == true) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Nomad',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: AppDimensions.paddingL),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Vouches', '${user.nomadId?.vouchCount ?? 0}'),
                _buildStatItem('Friends', '0'), // Placeholder
                _buildStatItem('Trips', '0'), // Placeholder
              ],
            ),

            const SizedBox(height: AppDimensions.paddingL),
            const Divider(),

            // Rig Info
            ListTile(
              leading: const Icon(Icons.directions_car), // Use custom rig icon
              title: const Text('My Rig'),
              subtitle: Text(rig != null 
                  ? '${rig.type.toUpperCase()} • ${rig.crewType.toUpperCase()}'
                  : 'Add rig info'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Edit rig
              },
            ),
            
            // Bio
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    'About Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio ?? 'No bio yet',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Hobbies
            if (profile.hobbies.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text(
                      'Hobbies',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.hobbies.map((hobby) {
                        return Chip(label: Text(hobby));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
            ],
            
            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to edit profile
                    context.push('/profile-setup'); // Reuse setup screen for update? 
                    // Better to have separate or mode. For now re-use is okay 
                    // provided we pre-fill data which ProfileSetupScreen does.
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
