import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/core/utils/address_resolver.dart';
import 'package:nomadly/shared/models/activity.dart';
import 'package:nomadly/features/activities/providers/activity_provider.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  final String activityId;
  final Activity? preloadedActivity;

  const ActivityDetailScreen({
    super.key,
    required this.activityId,
    this.preloadedActivity,
  });

  @override
  ConsumerState<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {
  Activity? _activity;
  bool _isLoading = false;
  bool _isRequestLoading = false;

  @override
  void initState() {
    super.initState();
    _activity = widget.preloadedActivity;
    // Always load fresh data from API, preloaded is just for instant display
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    setState(() => _isLoading = true);
    try {
      final activity = await ref.read(activityRepositoryProvider).getActivity(widget.activityId);
      if (mounted) {
        setState(() => _activity = activity);
      }
    } catch (e) {
      if (mounted) {
        // Fallback or error UI
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  String _getRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = time.difference(now);
    if (diff.isNegative) {
      final absDiff = diff.abs();
      if (absDiff.inMinutes < 60) return 'Started ${absDiff.inMinutes}m ago';
      if (absDiff.inHours < 24) return 'Started ${absDiff.inHours}h ago';
      return 'Started ${absDiff.inDays}d ago';
    }
    if (diff.inMinutes < 60) return 'Starts in ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Starts in ${diff.inHours}h';
    if (diff.inDays < 7) return 'Starts in ${diff.inDays}d';
    return DateFormat('MMM d').format(time);
  }

  void _openInMaps(double lat, double lng, String label) {
    final encodedLabel = Uri.encodeComponent(label);
    if (Platform.isIOS) {
      // Show choice between Apple Maps and Google Maps
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.obsidian,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Open in Maps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.white),
                  title: const Text('Apple Maps', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(ctx);
                    launchUrl(Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&q=$encodedLabel'));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions, color: Colors.white),
                  title: const Text('Google Maps', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(ctx);
                    launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'), mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Android - open Google Maps directly
      launchUrl(
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _activity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final activity = _activity;
    if (activity == null) {
      return const Scaffold(body: Center(child: Text('Activity not found')));
    }

    final currentUser = ref.watch(authProvider).user;
    final isParticipant = activity.participants.any((u) => u.uid == currentUser?.uid);
    final isCreator = activity.creator.uid == currentUser?.uid;
    final isPending = activity.pendingRequests.any((u) => u.uid == currentUser?.uid);

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
        actions: isCreator
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () => _showEditSheet(activity),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () => _showDeleteConfirmation(activity),
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Header Image
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                activity.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: activity.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getActivityColor(activity.type),
                              _getActivityColor(activity.type).withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Icon(_getActivityIcon(activity.type), size: 80, color: Colors.white.withValues(alpha: 0.3)),
                      ),
                // Bottom gradient for readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getActivityColor(activity.type).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getActivityIcon(activity.type), size: 14, color: _getActivityColor(activity.type)),
                            const SizedBox(width: 4),
                            Text(
                              activity.type.toUpperCase(),
                              style: TextStyle(color: _getActivityColor(activity.type), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Host Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: activity.creator.profile?.photoUrl != null
                            ? NetworkImage(activity.creator.profile!.photoUrl!)
                            : null,
                        child: activity.creator.profile?.photoUrl == null
                            ? const Icon(Icons.person, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hosted by ${activity.creator.profile?.name ?? activity.creator.username}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Time & Location
                  _buildInfoRow(
                    Icons.access_time,
                    '${DateFormat('EEEE, MMM d • h:mm a').format(activity.startTime.toLocal())}  •  ${_getRelativeTime(activity.startTime)}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.location_on,
                    null,
                    future: AddressResolver.getAddressFromLatLng(
                        activity.location.latitude, activity.location.longitude),
                    fallback: '${activity.location.latitude}, ${activity.location.longitude}',
                  ),
                  const SizedBox(height: 12),

                  // Open in Maps button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openInMaps(
                        activity.location.latitude,
                        activity.location.longitude,
                        activity.title,
                      ),
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Get Directions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
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

                  // Pending Requests (Host View Only)
                  if (isCreator && activity.pendingRequests.isNotEmpty) ...[
                    _buildPendingRequestsSection(activity, ref),
                    const SizedBox(height: 24),
                  ],

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
                  if (activity.maxParticipants > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: activity.participants.length / activity.maxParticipants,
                        backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          activity.participants.length >= activity.maxParticipants
                              ? Colors.red
                              : AppColors.primary,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (activity.participants.isEmpty)
                    const Text(
                      'No one has joined yet. Be the first!',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: activity.participants.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final user = activity.participants[index];
                            return GestureDetector(
                              onTap: () => context.push('/profile/${user.uid}'),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: user.profile?.photoUrl != null
                                        ? NetworkImage(user.profile!.photoUrl!)
                                        : null,
                                    child: user.profile?.photoUrl == null
                                        ? const Icon(Icons.person, size: 18)
                                        : null,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.profile?.name?.split(' ').first ?? user.username ?? '',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ),
                ],
              ),
            ),
          ),
          
          // Action Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: SizedBox(
                 width: double.infinity,
                 height: 50,
                 child: ElevatedButton(
                   onPressed: _isRequestLoading ? null : _getButtonOnPressed(isCreator, isParticipant, isPending, activity),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: _getButtonColor(isCreator, isParticipant, isPending),
                     disabledBackgroundColor: _getButtonColor(isCreator, isParticipant, isPending).withValues(alpha: 0.7),
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(14),
                     ),
                   ),
                   child: _isRequestLoading
                       ? const SizedBox(
                           width: 24,
                           height: 24,
                           child: CircularProgressIndicator(
                             strokeWidth: 2.5,
                             color: Colors.white,
                           ),
                         )
                       : FittedBox(
                           fit: BoxFit.scaleDown,
                           child: Text(
                             _getButtonText(isCreator, isParticipant, isPending),
                             style: TextStyle(
                               color: isCreator || isParticipant || isPending ? Colors.white : AppColors.obsidian,
                               fontSize: 16,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                         ),
                 ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(bool isCreator, bool isParticipant, bool isPending) {
    if (isCreator) return "You're Hosting";
    if (isParticipant) return 'Leave Activity';
    if (isPending) return 'Request Pending';
    return 'Request to Join';
  }

  Color _getButtonColor(bool isCreator, bool isParticipant, bool isPending) {
    if (isCreator) return AppColors.grey;
    if (isParticipant) return Colors.red.withValues(alpha: 0.8);
    if (isPending) return AppColors.accent;
    return AppColors.primary;
  }

  VoidCallback? _getButtonOnPressed(bool isCreator, bool isParticipant, bool isPending, Activity activity) {
    if (isCreator || isPending) return null;
    if (isParticipant) {
      return () => _showLeaveConfirmation(activity);
    }
    return () async {
      setState(() => _isRequestLoading = true);
      final updated = await ref.read(activityProvider.notifier).joinActivity(activity.id);
      if (mounted) {
        setState(() {
          if (updated != null) _activity = updated;
          _isRequestLoading = false;
        });
      }
    };
  }

  void _showLeaveConfirmation(Activity activity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Leave Activity',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to leave "${activity.title}"?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Stay',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'Inter',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final updated = await ref.read(activityProvider.notifier).leaveActivity(activity.id);
              if (updated != null && mounted) {
                setState(() => _activity = updated);
              }
            },
            child: const Text(
              'Leave',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsSection(Activity activity, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'PENDING REQUESTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
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
                '${activity.pendingRequests.length}',
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
        ...activity.pendingRequests.map((user) => _buildPendingRequestCard(user, activity, ref)),
      ],
    );
  }

  Widget _buildPendingRequestCard(dynamic user, Activity activity, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
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
            child: GestureDetector(
              onTap: () => context.push('/profile/${user.uid}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.profile?.name ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '@${user.username ?? 'user'}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Approve Button
          IconButton(
            onPressed: _isRequestLoading
                ? null
                : () async {
                    setState(() => _isRequestLoading = true);
                    final updated = await ref
                        .read(activityProvider.notifier)
                        .approveRequest(activity.id, user.uid);
                    if (updated != null && mounted) {
                      setState(() {
                        _activity = updated;
                        _isRequestLoading = false;
                      });
                    } else {
                      setState(() => _isRequestLoading = false);
                    }
                  },
            style: IconButton.styleFrom(
              backgroundColor: Colors.green.withValues(alpha: 0.15),
              foregroundColor: Colors.green,
            ),
            icon: const Icon(Icons.check, size: 20),
          ),
          const SizedBox(width: 4),
          // Reject Button
          IconButton(
            onPressed: _isRequestLoading
                ? null
                : () async {
                    setState(() => _isRequestLoading = true);
                    final updated = await ref
                        .read(activityProvider.notifier)
                        .rejectRequest(activity.id, user.uid);
                    if (updated != null && mounted) {
                      setState(() {
                        _activity = updated;
                        _isRequestLoading = false;
                      });
                    } else {
                      setState(() => _isRequestLoading = false);
                    }
                  },
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.15),
              foregroundColor: Colors.red,
            ),
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? text, {Future<String>? future, String? fallback}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: future != null
              ? FutureBuilder<String>(
                  future: future,
                  initialData: fallback ?? 'Loading location...',
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? fallback ?? '',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                )
              : Text(
                  text ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }

  void _showEditSheet(Activity activity) {
    final titleController = TextEditingController(text: activity.title);
    final descriptionController = TextEditingController(text: activity.description);
    final maxParticipantsController = TextEditingController(text: activity.maxParticipants.toString());
    DateTime selectedTime = activity.startTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.obsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxParticipantsController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Participants',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final sheetContext = context;
                  final date = await showDatePicker(
                    context: sheetContext,
                    initialDate: selectedTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null && sheetContext.mounted) {
                    final time = await showTimePicker(
                      context: sheetContext,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (time != null) {
                      setSheetState(() {
                        selectedTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.6)),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEE, MMM d • h:mm a').format(selectedTime),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final updated = await ref.read(activityProvider.notifier).updateActivity(
                      activity.id,
                      {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'max_participants': int.tryParse(maxParticipantsController.text) ?? activity.maxParticipants,
                        'event_time': selectedTime.toIso8601String(),
                      },
                    );
                    if (updated != null && mounted) {
                      setState(() => _activity = updated);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Activity activity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Activity',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel "${activity.title}"? This action cannot be undone.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Keep Activity',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'Inter',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              Navigator.pop(dialogContext);
              final success = await ref.read(activityProvider.notifier).deleteActivity(activity.id);
              if (success && mounted) {
                router.pop();
              }
            },
            child: const Text(
              'Cancel Activity',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
