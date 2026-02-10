import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../providers/activity_provider.dart';

class MyActivitiesScreen extends ConsumerStatefulWidget {
  const MyActivitiesScreen({super.key});

  @override
  ConsumerState<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends ConsumerState<MyActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myActivitiesProvider.notifier).loadMyActivities();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(myActivitiesProvider.notifier).loadMyActivities();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myActivitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Activities',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
          labelStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              text: 'Hosting${state.upcomingHosted.isNotEmpty ? ' (${state.upcomingHosted.length})' : ''}',
            ),
            Tab(
              text: 'Joined${state.upcomingJoined.isNotEmpty ? ' (${state.upcomingJoined.length})' : ''}',
            ),
            const Tab(text: 'Past'),
          ],
        ),
      ),
      body: state.isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActivityList(state.upcomingHosted, isHosting: true),
                _buildActivityList(state.upcomingJoined, isHosting: false),
                _buildPastActivitiesList(state),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-activity'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ActivityCardSkeleton(),
      ),
    );
  }

  Widget _buildActivityList(List<Activity> activities, {required bool isHosting}) {
    if (activities.isEmpty) {
      return _buildEmptyState(isHosting);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ActivityCard(
              activity: activity,
              isHosting: isHosting,
              onTap: () => context.push('/activity/${activity.id}', extra: activity),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPastActivitiesList(MyActivitiesState state) {
    final pastActivities = [...state.pastHosted, ...state.pastJoined];
    pastActivities.sort((a, b) => b.startTime.compareTo(a.startTime));

    if (pastActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No past activities',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastActivities.length,
        itemBuilder: (context, index) {
          final activity = pastActivities[index];
          final isHosting = state.pastHosted.contains(activity);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Opacity(
              opacity: 0.6,
              child: _ActivityCard(
                activity: activity,
                isHosting: isHosting,
                isPast: true,
                onTap: () => context.push('/activity/${activity.id}', extra: activity),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isHosting) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isHosting ? Icons.event_available : Icons.event_busy,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            isHosting ? 'You haven\'t hosted any activities' : 'You haven\'t joined any activities',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          if (isHosting) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-activity'),
              icon: const Icon(Icons.add),
              label: const Text('Create Activity'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isHosting;
  final bool isPast;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.activity,
    required this.isHosting,
    this.isPast = false,
    required this.onTap,
  });

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hike':
        return Icons.hiking;
      case 'yoga':
        return Icons.self_improvement;
      case 'surf':
        return Icons.surfing;
      case 'meal':
        return Icons.restaurant;
      case 'social':
        return Icons.people;
      case 'cowork':
        return Icons.laptop;
      case 'camping':
        return Icons.cabin;
      default:
        return Icons.event;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'hike':
        return Colors.green;
      case 'yoga':
        return Colors.purple;
      case 'surf':
        return Colors.blue;
      case 'meal':
        return Colors.orange;
      case 'social':
        return Colors.pink;
      case 'cowork':
        return Colors.teal;
      case 'camping':
        return Colors.brown;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');
    final pendingCount = activity.pendingRequests.length;

    return Material(
      color: AppColors.slate,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getActivityColor(activity.type).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getActivityIcon(activity.type),
                      color: _getActivityColor(activity.type),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dateFormat.format(activity.startTime)} • ${timeFormat.format(activity.startTime)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isHosting && pendingCount > 0 && !isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_add,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$pendingCount',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${activity.participants.length}/${activity.maxParticipants} participants',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isHosting
                          ? Colors.blue.withValues(alpha: 0.2)
                          : Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isHosting ? 'Hosting' : 'Joined',
                      style: TextStyle(
                        color: isHosting ? Colors.blue : Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Skeleton loader for activity cards
class ActivityCardSkeleton extends StatelessWidget {
  const ActivityCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
              const SkeletonBox(width: 44, height: 44, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(width: 150, height: 16),
                    SizedBox(height: 8),
                    SkeletonBox(width: 100, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonBox(width: 120, height: 12),
        ],
      ),
    );
  }
}
