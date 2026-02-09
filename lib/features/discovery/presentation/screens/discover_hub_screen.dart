import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../trips/providers/trip_provider.dart';
import '../../../activities/providers/activity_provider.dart';

class DiscoverHubScreen extends ConsumerStatefulWidget {
  const DiscoverHubScreen({super.key});

  @override
  ConsumerState<DiscoverHubScreen> createState() => _DiscoverHubScreenState();
}

class _DiscoverHubScreenState extends ConsumerState<DiscoverHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Travelers'),
            Tab(text: 'Trips'),
            Tab(text: 'Activities'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Tab 1: Travelers (existing matching)
          MatchingScreen(),
          // Tab 2: Trips Discovery
          _TripsDiscoveryTab(),
          // Tab 3: Activities Hub
          _ActivitiesHubTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// TRIPS DISCOVERY TAB
// ============================================================================

class _TripsDiscoveryTab extends ConsumerWidget {
  const _TripsDiscoveryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrip = ref.watch(currentTripProvider);
    final nearbyTrips = ref.watch(nearbyTripsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentTripProvider);
        ref.invalidate(nearbyTripsProvider);
      },
      color: AppColors.primary,
      backgroundColor: AppColors.slate,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Current Trip Section
            _buildSectionHeader('Your Trip', onSeeAll: () => context.push('/my-trip')),
            const SizedBox(height: 12),
            currentTrip.when(
              loading: () => const TripCardSkeleton(),
              error: (_, __) => _buildCreateTripCard(context),
              data: (trip) {
                if (trip == null || trip.origin == null) {
                  return _buildCreateTripCard(context);
                }
                return _buildMyTripCard(context, trip);
              },
            ),

            const SizedBox(height: 24),

            // Discover Nearby Trips
            _buildSectionHeader('Nearby Trips', onSeeAll: () => context.push('/discover-trips')),
            const SizedBox(height: 12),
            nearbyTrips.when(
              loading: () => const Column(
                children: [
                  TripCardSkeleton(),
                  SizedBox(height: 12),
                  TripCardSkeleton(),
                ],
              ),
              error: (e, _) => _buildEmptyState(
                icon: Icons.error_outline,
                message: 'Failed to load trips',
                subMessage: 'Pull to refresh',
              ),
              data: (trips) {
                if (trips.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.explore_outlined,
                    message: 'No trips nearby',
                    subMessage: 'Check back later or expand your search',
                  );
                }
                return Column(
                  children: trips.take(3).map((trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNearbyTripCard(context, trip),
                  )).toList(),
                );
              },
            ),

            const SizedBox(height: 100), // Space for navbar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'See All',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildCreateTripCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_road,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Plan Your Adventure',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a trip to find travel companions',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
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
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Create Trip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTripCard(BuildContext context, dynamic trip) {
    return GestureDetector(
      onTap: () => context.push('/my-trip'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.trip_origin, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your current trip',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (trip.startDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d').format(trip.startDate),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  if (trip.durationDays != null) ...[
                    Text(
                      ' • ${trip.durationDays} days',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
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

  Widget _buildNearbyTripCard(BuildContext context, dynamic trip) {
    return GestureDetector(
      onTap: () => context.push('/trip/${trip.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: trip.creator?.profile?.photoUrl != null
                      ? NetworkImage(trip.creator.profile.photoUrl)
                      : null,
                  backgroundColor: AppColors.obsidian,
                  child: trip.creator?.profile?.photoUrl == null
                      ? const Icon(Icons.person, size: 20, color: AppColors.textSecondary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title ?? 'Untitled Trip',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@${trip.creator?.username ?? 'unknown'}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trip.spotsLeft != null && trip.spotsLeft > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${trip.spotsLeft} spot${trip.spotsLeft > 1 ? 's' : ''} left',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (trip.startDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM d').format(trip.startDate),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
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
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// ACTIVITIES HUB TAB
// ============================================================================

class _ActivitiesHubTab extends ConsumerWidget {
  const _ActivitiesHubTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyActivities = ref.watch(nearbyActivitiesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(nearbyActivitiesProvider);
      },
      color: AppColors.primary,
      backgroundColor: AppColors.slate,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.calendar_today,
                    label: 'My Activities',
                    onTap: () => context.push('/my-activities'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.add_circle_outline,
                    label: 'Create',
                    onTap: () => context.push('/create-activity'),
                    isPrimary: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Happening Now/Soon
            nearbyActivities.when(
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonCard(),
                  const SizedBox(height: 12),
                  _buildSkeletonCard(),
                ],
              ),
              error: (e, _) => _buildEmptyState(
                icon: Icons.error_outline,
                message: 'Failed to load activities',
              ),
              data: (activities) {
                final now = DateTime.now();
                final happeningNow = activities.where((a) =>
                  a.startTime.isBefore(now) &&
                  a.startTime.add(const Duration(hours: 2)).isAfter(now)
                ).toList();

                final happeningSoon = activities.where((a) {
                  final diff = a.startTime.difference(now);
                  return diff.inMinutes >= 0 && diff.inMinutes <= 60;
                }).toList();

                final upcoming = activities.where((a) {
                  final diff = a.startTime.difference(now);
                  return diff.inMinutes > 60 && diff.inDays < 7;
                }).toList();

                if (activities.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.event_busy,
                    message: 'No activities nearby',
                    subMessage: 'Create one or check back later',
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Happening Now
                    if (happeningNow.isNotEmpty || happeningSoon.isNotEmpty) ...[
                      _buildSectionHeader('Happening Now'),
                      const SizedBox(height: 12),
                      ...happeningNow.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityCard(context, a, isLive: true),
                      )),
                      ...happeningSoon.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityCard(context, a, isSoon: true),
                      )),
                      const SizedBox(height: 16),
                    ],

                    // Upcoming
                    if (upcoming.isNotEmpty) ...[
                      _buildSectionHeader('Upcoming'),
                      const SizedBox(height: 12),
                      ...upcoming.take(5).map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityCard(context, a),
                      )),
                    ],
                  ],
                );
              },
            ),

            const SizedBox(height: 100), // Space for navbar
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.slate,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? AppColors.obsidian : AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? AppColors.obsidian : AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    dynamic activity, {
    bool isLive = false,
    bool isSoon = false,
  }) {
    return GestureDetector(
      onTap: () => context.push('/activity/${activity.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          border: isLive
              ? Border.all(color: AppColors.error.withValues(alpha: 0.5))
              : isSoon
                  ? Border.all(color: AppColors.warning.withValues(alpha: 0.5))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Activity type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getActivityIcon(activity.activityType),
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title ?? 'Untitled',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'by ${activity.creator?.profile?.name ?? activity.creator?.username ?? 'Unknown'}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'SOON',
                      style: TextStyle(
                        color: AppColors.obsidian,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.textSecondary, size: 14),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE, MMM d • h:mm a').format(activity.startTime.toLocal()),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                if (activity.maxParticipants > 0)
                  Text(
                    '${activity.participants?.length ?? 0}/${activity.maxParticipants}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'hike':
        return Icons.terrain;
      case 'yoga':
        return Icons.self_improvement;
      case 'meal':
        return Icons.restaurant;
      case 'social':
        return Icons.people;
      case 'cowork':
        return Icons.computer;
      case 'surf':
        return Icons.surfing;
      default:
        return Icons.event;
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
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
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.obsidian,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.obsidian,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.obsidian,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: 180,
            decoration: BoxDecoration(
              color: AppColors.obsidian,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
