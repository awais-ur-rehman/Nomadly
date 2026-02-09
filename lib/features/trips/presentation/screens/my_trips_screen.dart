import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../providers/trip_provider.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTrips = ref.watch(myTripsProvider);
    final joinedTrips = ref.watch(joinedTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'My Trips',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myTripsProvider);
          ref.invalidate(joinedTripsProvider);
        },
        color: AppColors.primary,
        backgroundColor: AppColors.slate,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Created Trips
              const Text(
                'Created by you',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              myTrips.when(
                loading: () => const Column(
                  children: [
                    TripCardSkeleton(),
                    SizedBox(height: 12),
                    TripCardSkeleton(),
                  ],
                ),
                error: (error, _) => _buildErrorState(
                  onRetry: () => ref.invalidate(myTripsProvider),
                ),
                data: (trips) {
                  if (trips.isEmpty) {
                    return _buildEmptyState(
                      context,
                      icon: Icons.explore_outlined,
                      message: 'No trips created yet',
                      subMessage: 'Plan your next adventure to find travel companions',
                      showCreateButton: true,
                    );
                  }
                  return Column(
                    children: trips.map((trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TripCard(
                        trip: trip,
                        isCreator: true,
                        onTap: () => context.push('/trip/${trip.id}', extra: trip),
                        onDelete: () => _showDeleteDialog(context, ref, trip),
                      ),
                    )).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Joined Trips
              const Text(
                'Joined as companion',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              joinedTrips.when(
                loading: () => const TripCardSkeleton(),
                error: (_, _) => const SizedBox.shrink(),
                data: (trips) {
                  if (trips.isEmpty) {
                    return _buildEmptyState(
                      context,
                      icon: Icons.people_outline,
                      message: 'No joined trips',
                      subMessage: 'Browse nearby trips to find travel companions',
                    );
                  }
                  return Column(
                    children: trips.map((trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TripCard(
                        trip: trip,
                        isCreator: false,
                        onTap: () => context.push('/trip/${trip.id}', extra: trip),
                      ),
                    )).toList(),
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-trip'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.obsidian,
        label: const Text(
          'Plan a Trip',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Trip trip) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Trip',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${trip.title}"? This action cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref.read(tripProvider.notifier).deleteTrip(trip.id);
              if (success) {
                ref.invalidate(myTripsProvider);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
    String? subMessage,
    bool showCreateButton = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              subMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
          if (showCreateButton) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.obsidian,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Plan a Trip',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState({required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'Failed to load trips',
            style: TextStyle(color: AppColors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.obsidian,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final bool isCreator;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _TripCard({
    required this.trip,
    required this.isCreator,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = trip.isActive
        ? AppColors.success
        : trip.isUpcoming
            ? AppColors.accent
            : AppColors.textSecondary;
    final statusText = trip.isActive
        ? 'Active'
        : trip.isUpcoming
            ? 'Upcoming'
            : 'Completed';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCreator && trip.pendingCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add, color: AppColors.primary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${trip.pendingCount}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (!isCreator) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'COMPANION',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (isCreator && onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete_outline, color: AppColors.error.withValues(alpha: 0.7), size: 20),
                  )
                else
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              trip.title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Origin → Destination
            Row(
              children: [
                const Icon(Icons.trip_origin, color: AppColors.primary, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    trip.origin.placeName ?? 'Origin',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 14),
                ),
                Expanded(
                  child: Text(
                    trip.destination.placeName ?? 'Destination',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 14),
                const SizedBox(width: 6),
                Text(
                  '${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d').format(trip.endDate)} • ${trip.durationDays} days',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
            if (trip.lookingForCompanions) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people_outline, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${trip.companions.length}/${trip.maxCompanions} companions',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  if (trip.availableSpots > 0) ...[
                    const Spacer(),
                    Text(
                      '${trip.availableSpots} spots left',
                      style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
