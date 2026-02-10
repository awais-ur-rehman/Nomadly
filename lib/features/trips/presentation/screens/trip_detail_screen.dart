import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/trip.dart';
import '../../providers/trip_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;
  final Trip? preloadedTrip;

  const TripDetailScreen({
    super.key,
    required this.tripId,
    this.preloadedTrip,
  });

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  Trip? _trip;
  bool _isLoading = false;
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    _trip = widget.preloadedTrip;
    if (_trip == null) {
      _loadTrip();
    }
  }

  Future<void> _loadTrip() async {
    setState(() => _isLoading = true);
    try {
      final trip = await ref.read(tripRepositoryProvider).getTrip(widget.tripId);
      if (mounted) {
        setState(() => _trip = trip);
      }
    } catch (e) {
      // Error handled in UI
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _trip == null) {
      return const Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final rawTrip = _trip;
    if (rawTrip == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        appBar: AppBar(
          backgroundColor: AppColors.obsidian,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        body: const Center(
          child: Text('Trip not found', style: TextStyle(color: AppColors.white)),
        ),
      );
    }

    final currentUser = ref.watch(authProvider).user;
    String? myStatus;
    try {
      final interest = rawTrip.interestedUsers.firstWhere((i) => i.user.uid == currentUser?.uid);
      myStatus = interest.status;
    } catch (_) {}

    final trip = rawTrip.copyWith(
      isCreator: rawTrip.creator.uid == currentUser?.uid,
      isCompanion: rawTrip.companions.any((u) => u.uid == currentUser?.uid),
      myInterestStatus: myStatus,
    );

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: Text(
          trip.title,
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          if (trip.isCreator)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              color: AppColors.slate,
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Trip', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTrip,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route Card
              _buildRouteCard(trip),
              const SizedBox(height: 16),

              // Trip Info Card
              _buildInfoCard(trip),
              const SizedBox(height: 16),

              // Description
              if (trip.description.isNotEmpty) ...[
                _buildDescriptionCard(trip),
                const SizedBox(height: 16),
              ],

              // Creator Card
              _buildCreatorCard(trip),
              const SizedBox(height: 16),

              // Pending Interests (for trip owner)
              if (trip.isCreator && trip.interestedUsers.isNotEmpty)
                _buildPendingInterestsSection(trip),

              // Companions
              if (trip.companions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildCompanionsSection(trip),
              ],

              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(trip),
    );
  }

  Widget _buildRouteCard(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Origin
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trip_origin, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trip.origin.placeName ?? 'Origin',
                  style: const TextStyle(color: AppColors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          // Connector
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Container(
              width: 2,
              height: 20,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          // Destination
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: AppColors.success, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trip.destination.placeName ?? 'Destination',
                  style: const TextStyle(color: AppColors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Trip trip) {
    final statusColor = trip.isActive
        ? AppColors.success
        : (trip.isUpcoming ? AppColors.accent : AppColors.textSecondary);
    final statusText = trip.isActive
        ? 'Active'
        : (trip.isUpcoming ? 'Upcoming' : 'Completed');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.calendar_today,
            '${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.schedule,
            '${trip.durationDays} days',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                trip.isActive ? Icons.play_circle : Icons.schedule,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (trip.lookingForCompanions) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.people_outline,
              '${trip.availableSpots} spots available',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(color: AppColors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(Trip trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this trip',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trip.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(Trip trip) {
    return GestureDetector(
      onTap: () => context.push('/profile/${trip.creator.uid}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: trip.creator.profile?.photoUrl != null
                  ? NetworkImage(trip.creator.profile!.photoUrl!)
                  : null,
              child: trip.creator.profile?.photoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.creator.profile?.name ?? 'Unknown',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '@${trip.creator.username ?? 'user'}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInterestsSection(Trip trip) {
    final pendingInterests = trip.interestedUsers.where((i) => i.status == 'pending').toList();
    if (pendingInterests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'PENDING INTERESTS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${pendingInterests.length}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...pendingInterests.map((interest) => _buildInterestCard(interest, trip)),
      ],
    );
  }

  Widget _buildInterestCard(TripInterest interest, Trip trip) {
    final user = interest.user;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push('/profile/${user.uid}'),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: user.profile?.photoUrl != null
                      ? NetworkImage(user.profile!.photoUrl!)
                      : null,
                  child: user.profile?.photoUrl == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.profile?.name ?? 'Unknown',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '@${user.username ?? 'user'}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _isActionLoading ? null : () => _acceptInterest(trip.id, user.uid),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green.withValues(alpha: 0.15),
                  foregroundColor: Colors.green,
                ),
                icon: const Icon(Icons.check, size: 20),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: _isActionLoading ? null : () => _declineInterest(trip.id, user.uid),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.15),
                  foregroundColor: Colors.red,
                ),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          if (interest.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.obsidian.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                interest.message,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompanionsSection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMPANIONS (${trip.companions.length})',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 75,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trip.companions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final user = trip.companions[index];
              return GestureDetector(
                onTap: () => context.push('/profile/${user.uid}'),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: user.profile?.photoUrl != null
                          ? NetworkImage(user.profile!.photoUrl!)
                          : null,
                      child: user.profile?.photoUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: Text(
                        user.profile?.name?.split(' ').first ?? 'User',
                        style: const TextStyle(color: AppColors.white, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildActionButton(trip),
      ),
    );
  }

  Widget _buildActionButton(Trip trip) {
    if (trip.isCreator) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.grey,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('You created this trip'),
        ),
      );
    }

    if (trip.isCompanion) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isActionLoading ? null : () => _leaveTrip(trip.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('You are going!', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    if (trip.myInterestStatus == 'pending') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Interest Pending...', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _isActionLoading ? null : () => _cancelInterest(trip.id),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.15),
              foregroundColor: AppColors.error,
            ),
            icon: const Icon(Icons.close),
          ),
        ],
      );
    }

    if (trip.myInterestStatus == 'declined') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showInterestSheet(trip.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.obsidian,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Request Again'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showInterestSheet(trip.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.obsidian,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.waving_hand),
        label: const Text('Show Interest'),
      ),
    );
  }

  void _showInterestSheet(String tripId) {
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.slate,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send a message',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Introduce yourself to the trip creator',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Hey! I would love to join...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                filled: true,
                fillColor: AppColors.obsidian,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showInterest(tripId, messageController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.obsidian,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Send Interest'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> _showInterest(String tripId, String message) async {
    setState(() => _isActionLoading = true);
    final updated = await ref.read(tripProvider.notifier).showInterest(tripId, message: message);
    if (updated != null && mounted) {
      setState(() {
        _trip = updated;
        _isActionLoading = false;
      });
    } else {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _cancelInterest(String tripId) async {
    setState(() => _isActionLoading = true);
    final updated = await ref.read(tripProvider.notifier).cancelInterest(tripId);
    if (updated != null && mounted) {
      setState(() {
        _trip = updated;
        _isActionLoading = false;
      });
    } else {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _acceptInterest(String tripId, String userId) async {
    setState(() => _isActionLoading = true);
    final updated = await ref.read(tripProvider.notifier).acceptInterest(tripId, userId);
    if (updated != null && mounted) {
      setState(() {
        _trip = updated;
        _isActionLoading = false;
      });
    } else {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _declineInterest(String tripId, String userId) async {
    setState(() => _isActionLoading = true);
    final updated = await ref.read(tripProvider.notifier).declineInterest(tripId, userId);
    if (updated != null && mounted) {
      setState(() {
        _trip = updated;
        _isActionLoading = false;
      });
    } else {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _leaveTrip(String tripId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Trip', style: TextStyle(color: AppColors.white)),
        content: const Text(
          'Are you sure you want to leave this trip?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isActionLoading = true);
      final success = await ref.read(tripProvider.notifier).leaveTrip(tripId);
      if (success && mounted) {
        await _loadTrip();
      }
      setState(() => _isActionLoading = false);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Trip', style: TextStyle(color: AppColors.white)),
        content: const Text(
          'Are you sure you want to delete this trip? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final router = GoRouter.of(context);
              navigator.pop();
              final success = await ref.read(tripProvider.notifier).deleteTrip(widget.tripId);
              if (success && mounted) {
                router.pop();
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
}
