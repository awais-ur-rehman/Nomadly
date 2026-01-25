import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/geo_point.dart';
import '../../providers/activity_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class ActivityDetailScreen extends ConsumerWidget {
  final Activity activity;

  const ActivityDetailScreen({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider).user;
    final isParticipant = activity.participants.any((u) => u.id == currentUser?.id);
    final isCreator = activity.creator.id == currentUser?.id;

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
      body: Column(
        children: [
          // Header Image
          SizedBox(
            height: 250,
            width: double.infinity,
            child: activity.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: activity.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.primary,
                    child: const Icon(Icons.event, size: 80, color: Colors.white),
                  ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          activity.type.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Host Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: activity.creator.profile.photoUrl != null
                            ? NetworkImage(activity.creator.profile.photoUrl!)
                            : null,
                        child: activity.creator.profile.photoUrl == null
                            ? const Icon(Icons.person, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hosted by ${activity.creator.profile.name}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Time & Location
                  _buildInfoRow(
                    Icons.access_time,
                    DateFormat('EEEE, MMM d • h:mm a').format(activity.startTime.toLocal()),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.location_on,
                    '${activity.location.latitude}, ${activity.location.longitude}', // TODO: Reverse Geocoding
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 24),

                  // Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Going (${activity.participants.length})',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (activity.maxParticipants > 0)
                        Text(
                          '${activity.maxParticipants - activity.participants.length} spots left',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: activity.participants.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final user = activity.participants[index];
                          return CircleAvatar(
                             backgroundImage: user.profile.photoUrl != null
                                ? NetworkImage(user.profile.photoUrl!)
                                : null,
                             child: user.profile.photoUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          );
                        },
                      ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: SizedBox(
               width: double.infinity,
               height: 50,
               child: ElevatedButton(
                 onPressed: isParticipant || isCreator
                     ? null // Already joined or creator
                     : () => ref.read(activityProvider.notifier).joinActivity(activity.id),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: isParticipant ? Colors.green : AppColors.primary,
                 ),
                 child: Text(
                   isCreator ? 'You satisfy hosting this' : (isParticipant ? 'You are going' : 'Join Activity'),
                 ),
               ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
