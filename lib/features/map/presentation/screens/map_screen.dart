import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomadly/features/discovery/data/repositories/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../activities/providers/activity_provider.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/beacon.dart';
import '../../../../shared/models/user.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  final Map<String, dynamic> _annotationData = {};
  final _logger = Logger();
  bool _locationPermissionGranted = false;

  final _userRepo = UserRepository();
  List<User> _travelers = [];

  // Category filter
  String? _selectedCategory;
  static const List<Map<String, dynamic>> _categories = [
    {'id': null, 'label': 'All', 'icon': Icons.apps},
    {'id': 'hike', 'label': 'Hike', 'icon': Icons.hiking},
    {'id': 'yoga', 'label': 'Yoga', 'icon': Icons.self_improvement},
    {'id': 'meal', 'label': 'Meal', 'icon': Icons.restaurant},
    {'id': 'social', 'label': 'Social', 'icon': Icons.people},
    {'id': 'cowork', 'label': 'Cowork', 'icon': Icons.laptop},
  ];

  // Preview card state
  Activity? _selectedActivity;
  Beacon? _selectedBeacon;
  User? _selectedTraveler;

  // Bottom sheet
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (token != null) {
      MapboxOptions.setAccessToken(token);
    }
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    setState(() {
      _locationPermissionGranted = status.isGranted;
    });

    if (status.isGranted) {
      _setupLocation();
      ref.read(activityProvider.notifier).loadNearbyActivities();
      _loadTravelers();
    }
  }

  Future<void> _loadTravelers() async {
    try {
      // Load travelers when map is ready
    } catch (e) {
      _logger.e('Failed to load travelers: $e');
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _setupLocation();
    _setupAnnotationManager();
    _fetchTravelersForCamera();
  }

  Future<void> _fetchTravelersForCamera() async {
    if (_mapboxMap == null) return;
    try {
      final camera = await _mapboxMap!.getCameraState();
      if (camera.center != null) {
        final travelers = await _userRepo.getTravelers(
          lat: camera.center!.coordinates.lat as double,
          lng: camera.center!.coordinates.lng as double,
          radius: 50000,
        );
        if (mounted) {
          setState(() => _travelers = travelers);
          _updateMarkers();
        }
      }
    } catch (e) {
      _logger.e("Error fetching travelers for map: $e");
    }
  }

  Future<void> _setupAnnotationManager() async {
    if (_mapboxMap == null) return;
    _pointAnnotationManager = await _mapboxMap!.annotations
        .createPointAnnotationManager();
    _pointAnnotationManager?.addOnPointAnnotationClickListener(
      _PointAnnotationClickListener(
        onAnnotationClick: (annotation) {
          final data = _annotationData[annotation.id];
          if (data != null && data is Map<String, dynamic>) {
            if (data.containsKey('title')) {
              // Activity - show preview card
              final activity = Activity.fromJson(data);
              setState(() {
                _selectedActivity = activity;
                _selectedBeacon = null;
                _selectedTraveler = null;
              });
            } else if (data.containsKey('message')) {
              // Beacon - show preview
              final beacon = Beacon.fromJson(data);
              setState(() {
                _selectedBeacon = beacon;
                _selectedActivity = null;
                _selectedTraveler = null;
              });
            } else if (data.containsKey('username')) {
              // Traveler - show preview
              final user = User.fromJson(data);
              setState(() {
                _selectedTraveler = user;
                _selectedActivity = null;
                _selectedBeacon = null;
              });
            }
          }
          return true;
        },
      ),
    );
    _updateMarkers();
  }

  void _clearSelection() {
    setState(() {
      _selectedActivity = null;
      _selectedBeacon = null;
      _selectedTraveler = null;
    });
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'hike':
        return Colors.green;
      case 'yoga':
        return Colors.purple;
      case 'meal':
        return Colors.orange;
      case 'social':
        return Colors.blue;
      case 'cowork':
        return Colors.teal;
      case 'surf':
        return Colors.cyan;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hike':
        return Icons.hiking;
      case 'yoga':
        return Icons.self_improvement;
      case 'meal':
        return Icons.restaurant;
      case 'social':
        return Icons.people;
      case 'cowork':
        return Icons.laptop;
      case 'surf':
        return Icons.surfing;
      default:
        return Icons.event;
    }
  }

  bool _isHappeningSoon(DateTime startTime) {
    final now = DateTime.now();
    final difference = startTime.difference(now);
    // Activity is "happening soon" if it starts within the next hour
    return difference.inMinutes >= 0 && difference.inMinutes <= 60;
  }

  bool _isHappeningNow(DateTime startTime, DateTime? endTime) {
    final now = DateTime.now();
    final end = endTime ?? startTime.add(const Duration(hours: 2));
    return now.isAfter(startTime) && now.isBefore(end);
  }

  void _updateMarkers() async {
    if (_pointAnnotationManager == null) return;

    final state = ref.read(activityProvider);
    await _pointAnnotationManager?.deleteAll();
    _annotationData.clear();

    final List<PointAnnotationOptions> annotations = [];

    // Filter activities by category
    final filteredActivities = _selectedCategory == null
        ? state.activities
        : state.activities.where((a) => a.type.toLowerCase() == _selectedCategory).toList();

    // Activities
    for (final activity in filteredActivities) {
      final color = _getCategoryColor(activity.type);
      final isHappeningNow = _isHappeningNow(activity.startTime, activity.endTime);
      final isHappeningSoon = _isHappeningSoon(activity.startTime);
      final isUrgent = isHappeningNow || isHappeningSoon;

      // Make urgent activities more prominent
      final iconSize = isUrgent ? 3.5 : 2.5;
      final textSize = isUrgent ? 13.0 : 11.0;
      final urgentColor = isHappeningNow ? Colors.red : (isHappeningSoon ? Colors.amber : color);

      final options = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            activity.location.longitude,
            activity.location.latitude,
          ),
        ),
        iconImage: 'marker-15',
        iconSize: iconSize,
        iconColor: urgentColor.value,
        textField: isUrgent ? '🔴 ${activity.title}' : activity.title,
        textOffset: [0, 1.5],
        textAnchor: TextAnchor.TOP,
        textSize: textSize,
        textColor: AppColors.obsidian.value,
        textHaloColor: Colors.white.value,
        textHaloWidth: isUrgent ? 2 : 1,
      );
      annotations.add(options);
    }

    // Beacons (only show if no category filter or "social" selected)
    if (_selectedCategory == null || _selectedCategory == 'social') {
      for (final beacon in state.beacons) {
        final options = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              beacon.location.longitude,
              beacon.location.latitude,
            ),
          ),
          iconImage: 'rocket-15',
          iconColor: Colors.orange.value,
          iconSize: 2.5,
          textField: beacon.message.length > 20 ? '${beacon.message.substring(0, 20)}...' : beacon.message,
          textMaxWidth: 10.0,
          textOffset: [0, -1.5],
          textAnchor: TextAnchor.BOTTOM,
          textSize: 10,
        );
        annotations.add(options);
      }
    }

    // Travelers (only show if no category filter)
    if (_selectedCategory == null) {
      for (final traveler in _travelers) {
        final route = traveler.travelRoute;
        if (route != null && route.origin != null) {
          final options = PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(
                route.origin!.longitude,
                route.origin!.latitude,
              ),
            ),
            iconImage: 'car-15',
            iconColor: Colors.blue.value,
            iconSize: 2.0,
            textField: traveler.username ?? traveler.profile?.name ?? 'Traveler',
            textOffset: [0, 1.5],
            textAnchor: TextAnchor.TOP,
            textSize: 10,
          );
          annotations.add(options);
        }
      }
    }

    final createdAnnotations = await _pointAnnotationManager?.createMulti(
      annotations,
    );
    if (createdAnnotations != null) {
      int activityCount = filteredActivities.length;
      int beaconCount = (_selectedCategory == null || _selectedCategory == 'social') ? state.beacons.length : 0;

      for (int i = 0; i < createdAnnotations.length; i++) {
        final annotation = createdAnnotations[i];
        if (annotation != null) {
          if (i < activityCount) {
            _annotationData[annotation.id] = filteredActivities[i].toJson();
          } else if (i < activityCount + beaconCount) {
            _annotationData[annotation.id] = state.beacons[i - activityCount].toJson();
          } else {
            final travelerIndex = i - (activityCount + beaconCount);
            if (travelerIndex < _travelers.length) {
              _annotationData[annotation.id] = _travelers[travelerIndex].toJson();
            }
          }
        }
      }
    }
  }

  Future<void> _setupLocation() async {
    if (_mapboxMap == null || !_locationPermissionGranted) return;

    try {
      await _mapboxMap!.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true),
      );
    } catch (e) {
      _logger.e('Error setting up location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    final activityState = ref.watch(activityProvider);

    // Listen for activity updates to refresh markers
    ref.listen(activityProvider, (previous, next) {
      if (previous?.activities != next.activities) {
        _updateMarkers();
      }
    });

    if (token == null || token.contains('placeholder')) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Mapbox Token Missing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please add a valid MAPBOX_ACCESS_TOKEN to your .env file to view the map.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map
          GestureDetector(
            onTap: _clearSelection,
            child: MapWidget(
              key: const ValueKey('mapWidget'),
              onMapCreated: _onMapCreated,
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(-122.4194, 37.7749),
                ),
                zoom: 12.0,
              ),
              styleUri: MapboxStyles.DARK,
            ),
          ),

          // Category Filter Chips
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['id'];
                  return FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          size: 16,
                          color: isSelected ? AppColors.obsidian : AppColors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(category['label'] as String),
                      ],
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.obsidian : AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: AppColors.slate,
                    selectedColor: AppColors.primary,
                    checkmarkColor: AppColors.obsidian,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category['id'] as String? : null;
                      });
                      _updateMarkers();
                    },
                  );
                },
              ),
            ),
          ),

          // Loading Indicator
          if (activityState.isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.slate,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

          // Location Permission Banner
          if (!_locationPermissionGranted)
            Positioned(
              bottom: 180,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.slate,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Location permission needed',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: _requestLocationPermission,
                      child: const Text('Allow'),
                    ),
                  ],
                ),
              ),
            ),

          // Activity Preview Card
          if (_selectedActivity != null)
            _buildActivityPreviewCard(_selectedActivity!),

          // Beacon Preview Card
          if (_selectedBeacon != null)
            _buildBeaconPreviewCard(_selectedBeacon!),

          // Traveler Preview Card
          if (_selectedTraveler != null)
            _buildTravelerPreviewCard(_selectedTraveler!),

          // Bottom Sheet - Nearby Activities
          _buildBottomSheet(activityState),

          // FAB
          Positioned(
            bottom: 180,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'createActivity',
              backgroundColor: AppColors.primary,
              onPressed: () => context.push('/create-activity'),
              child: const Icon(Icons.add, color: AppColors.obsidian),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityPreviewCard(Activity activity) {
    final isHappeningNow = _isHappeningNow(activity.startTime, activity.endTime);
    final isHappeningSoon = _isHappeningSoon(activity.startTime);

    return Positioned(
      bottom: 180,
      left: 16,
      right: 80,
      child: GestureDetector(
        onTap: () {
          _clearSelection();
          context.push('/activity/${activity.id}', extra: activity);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.slate,
            borderRadius: BorderRadius.circular(16),
            border: isHappeningNow
                ? Border.all(color: Colors.red, width: 2)
                : (isHappeningSoon ? Border.all(color: Colors.amber, width: 2) : null),
            boxShadow: [
              BoxShadow(
                color: isHappeningNow
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(activity.type).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(activity.type),
                      color: _getCategoryColor(activity.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activity.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isHappeningNow)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else if (isHappeningSoon)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SOON',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          DateFormat('EEE, MMM d • h:mm a').format(activity.startTime.toLocal()),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _clearSelection,
                    icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                    'by ${activity.creator.profile?.name ?? activity.creator.username}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const Spacer(),
                  if (activity.maxParticipants > 0)
                    Text(
                      '${activity.participants.length}/${activity.maxParticipants} going',
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _clearSelection();
                    context.push('/activity/${activity.id}', extra: activity);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.obsidian,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeaconPreviewCard(Beacon beacon) {
    return Positioned(
      bottom: 180,
      left: 16,
      right: 80,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: beacon.author.profile?.photoUrl != null
                      ? NetworkImage(beacon.author.profile!.photoUrl!)
                      : null,
                  child: beacon.author.profile?.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beacon.author.profile?.name ?? 'Unknown',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${beacon.author.username ?? 'user'}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _clearSelection,
                  icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              beacon.message,
              style: const TextStyle(color: AppColors.white, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _clearSelection();
                  context.push('/profile/${beacon.author.uid}', extra: beacon.author);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.obsidian,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('View Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelerPreviewCard(User traveler) {
    return Positioned(
      bottom: 180,
      left: 16,
      right: 80,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: traveler.profile?.photoUrl != null
                      ? NetworkImage(traveler.profile!.photoUrl!)
                      : null,
                  child: traveler.profile?.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        traveler.profile?.name ?? 'Unknown',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '@${traveler.username ?? 'user'}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car, color: Colors.blue, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Traveling',
                        style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _clearSelection,
                  icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                ),
              ],
            ),
            if (traveler.travelRoute != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.trip_origin, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  const Text('→', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 6),
                  const Icon(Icons.location_on, color: AppColors.success, size: 14),
                  const SizedBox(width: 6),
                  if (traveler.travelRoute?.startDate != null)
                    Text(
                      DateFormat('MMM d').format(traveler.travelRoute!.startDate!),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _clearSelection();
                  context.push('/profile/${traveler.uid}', extra: traveler);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.obsidian,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('View Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(ActivityState activityState) {
    final filteredActivities = _selectedCategory == null
        ? activityState.activities
        : activityState.activities.where((a) => a.type.toLowerCase() == _selectedCategory).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      controller: _sheetController,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.obsidian,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Activities (${filteredActivities.length})',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/activities'),
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: filteredActivities.isEmpty
                    ? const Center(
                        child: Text(
                          'No activities nearby',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = filteredActivities[index];
                          return _buildActivityListItem(activity);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityListItem(Activity activity) {
    final isHappeningNow = _isHappeningNow(activity.startTime, activity.endTime);
    final isHappeningSoon = _isHappeningSoon(activity.startTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => context.push('/activity/${activity.id}', extra: activity),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(activity.type).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: isHappeningNow
                            ? Border.all(color: Colors.red, width: 2)
                            : (isHappeningSoon ? Border.all(color: Colors.amber, width: 2) : null),
                      ),
                      child: Icon(
                        _getCategoryIcon(activity.type),
                        color: _getCategoryColor(activity.type),
                        size: 20,
                      ),
                    ),
                    if (isHappeningNow)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.slate, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity.title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isHappeningNow)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (isHappeningSoon)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'SOON',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE, MMM d • h:mm a').format(activity.startTime.toLocal()),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (activity.maxParticipants > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${activity.participants.length}/${activity.maxParticipants}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PointAnnotationClickListener extends OnPointAnnotationClickListener {
  final bool Function(PointAnnotation) onAnnotationClick;

  _PointAnnotationClickListener({required this.onAnnotationClick});

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    return onAnnotationClick(annotation);
  }
}
