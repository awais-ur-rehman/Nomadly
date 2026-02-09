import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/address_resolver.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../providers/trip_provider.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(currentTripProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'My Trip',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(currentTripProvider.future),
        color: AppColors.primary,
        backgroundColor: AppColors.slate,
        child: tripAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: TripCardSkeleton(),
          ),
          error: (error, _) => _buildErrorState(
            onRetry: () => ref.refresh(currentTripProvider),
          ),
          data: (trip) {
            if (trip == null ||
                trip.origin == null ||
                trip.destination == null) {
              return _buildEmptyState(context);
            }
            return _TripContent(
              trip: trip,
              onDelete: () => _showDeleteDialog(context, ref),
              onEdit: () => context.push('/create-trip'),
            );
          },
        ),
      ),
      floatingActionButton: tripAsync.when(
        loading: () => null,
        error: (_, _) => null,
        data: (trip) {
          if (trip == null || trip.origin == null) {
            return FloatingActionButton.extended(
              onPressed: () => context.push('/create-trip'),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.obsidian,
              label: const Text(
                'Plan a Trip',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.add),
            );
          }
          return null;
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Trip',
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          'Are you sure you want to delete your trip? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await ref.read(tripProvider.notifier).deleteUserRoute();
              if (success) {
                ref.invalidate(currentTripProvider);
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.slate,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No trip planned yet',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Plan your next adventure to find\nfellow travelers along the way',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.obsidian,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        ),
      ),
    );
  }

  Widget _buildErrorState({required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load trip',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
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

class _TripContent extends StatelessWidget {
  final dynamic trip;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TripContent({
    required this.trip,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = trip.startDate;
    final durationDays = trip.durationDays ?? 1;
    final endDate = startDate?.add(Duration(days: durationDays - 1));

    final isActive = startDate != null &&
        startDate.isBefore(DateTime.now()) &&
        (endDate?.isAfter(DateTime.now()) ?? false);
    final isUpcoming = startDate != null && startDate.isAfter(DateTime.now());

    String status = 'Completed';
    Color statusColor = AppColors.textSecondary;
    if (isActive) {
      status = 'Active';
      statusColor = AppColors.success;
    } else if (isUpcoming) {
      status = 'Upcoming';
      statusColor = AppColors.accent;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trip_origin,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationText(
                    lat: trip.origin!.latitude,
                    lng: trip.origin!.longitude,
                    fallback: 'Origin',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Container(
                width: 2,
                height: 24,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.success,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationText(
                    lat: trip.destination!.latitude,
                    lng: trip.destination!.longitude,
                    fallback: 'Destination',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.obsidian),
            const SizedBox(height: 16),

            // Date Info
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 10),
                Text(
                  startDate != null
                      ? '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d').format(endDate!)} ($durationDays days)'
                      : 'No dates set',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status
            Row(
              children: [
                Icon(
                  isActive
                      ? Icons.play_circle_outline
                      : (isUpcoming
                          ? Icons.schedule
                          : Icons.check_circle_outline),
                  color: statusColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      'Edit Trip',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text(
                      'Delete',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationText extends StatelessWidget {
  final double lat;
  final double lng;
  final String fallback;

  const _LocationText({
    required this.lat,
    required this.lng,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AddressResolver.getAddressFromLatLng(lat, lng),
      initialData: fallback,
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? fallback,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
