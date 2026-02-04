import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../activities/providers/activity_provider.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/models/beacon.dart';
import '../../../../shared/models/geo_point.dart';
import '../../../../shared/models/user.dart';
import '../../discovery/data/repositories/user_repository.dart';

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
      // Default to SF or get current location if possible
      // Since we don't have easy access to current location without map callback,
      // we'll wait for map or use a default.
      // If map is active, we can use its camera center.
      // For now, load default or mock.
      // Actually, if we have permission, we can try to get position from Geolocator?
      // But let's just use a wide radius search from a default point until map is ready,
      // OR better, call this after map is created and we have a location.
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
    _pointAnnotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();
    _pointAnnotationManager?.addOnPointAnnotationClickListener(
      _PointAnnotationClickListener(
        onAnnotationClick: (annotation) {
          final data = _annotationData[annotation.id];
          if (data != null && data is Map<String, dynamic>) {
            if (data.containsKey('title')) {
              final activity = Activity.fromJson(data);
              context.push('/activity/${activity.id}', extra: activity);
            } else if (data.containsKey('message')) {
              final beacon = Beacon.fromJson(data);
              _showBeaconDialog(beacon);
            } else if (data.containsKey('username')) {
               final user = User.fromJson(data);
               // Navigate to user profile
               context.push('/profile/${user.id}', extra: user);
            }
          }
          return true;
        },
      ),
    );
    _updateMarkers();
  }

  void _showBeaconDialog(Beacon beacon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
               radius: 16,
               backgroundImage: beacon.author.profile?.photoUrl != null 
                  ? NetworkImage(beacon.author.profile!.photoUrl!) 
                  : null,
               child: beacon.author.profile?.photoUrl == null ? const Icon(Icons.person, size: 16) : null,
            ),
            const SizedBox(width: 8),
            Text(beacon.author.profile?.name ?? 'Unknown Nomad'),
          ],
        ),
        content: Text(beacon.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
             onPressed: () {
                Navigator.pop(context);
                // Navigate to profile or chat
                context.push('/profile/${beacon.author.id}', extra: beacon.author);
             },
             child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }

  void _updateMarkers() async {
    if (_pointAnnotationManager == null) return;
    
    final state = ref.read(activityProvider);
    await _pointAnnotationManager?.deleteAll();
    _annotationData.clear();
    
    final List<PointAnnotationOptions> annotations = [];

    // Activities
    for (final activity in state.activities) {
      final options = PointAnnotationOptions(
        geometry: Point(coordinates: Position(activity.location.longitude, activity.location.latitude)),
        iconImage: 'marker-15',
        iconSize: 2.0,
        textField: activity.title,
        textOffset: [0, 1.5],
        textAnchor: TextAnchor.TOP,
      );
      annotations.add(options);
    }

    // Beacons
    for (final beacon in state.beacons) {
      final options = PointAnnotationOptions(
        geometry: Point(coordinates: Position(beacon.location.longitude, beacon.location.latitude)),
        iconImage: 'rocket-15',
        iconColor: Colors.orange.value,
        iconSize: 2.5,
        textField: beacon.message,
        textMaxWidth: 10.0,
        textOffset: [0, -1.5],
        textAnchor: TextAnchor.BOTTOM,
      );
      annotations.add(options);
    }
    
    // Travelers
    for (final traveler in _travelers) {
      // Use origin or destination? 'travel_route.origin' is current/start.
      // If we searched by destination, maybe show destination?
      // But typically markers show where people ARE.
      // So use origin.
      final route = traveler.travelRoute;
      if (route != null && route.origin != null) {
          final options = PointAnnotationOptions(
            geometry: Point(coordinates: Position(route.origin!.longitude, route.origin!.latitude)),
            iconImage: 'car-15', // or marker-15 with color
            iconColor: Colors.blue.value,
            iconSize: 2.0,
            textField: traveler.username ?? traveler.profile?.name ?? 'Traveler',
            textOffset: [0, 1.5],
            textAnchor: TextAnchor.TOP,
          );
          annotations.add(options);
      }
    }

    final createdAnnotations = await _pointAnnotationManager?.createMulti(annotations);
    if (createdAnnotations != null) {
      int activityCount = state.activities.length;
      int beaconCount = state.beacons.length;
      
      for (int i = 0; i < createdAnnotations.length; i++) {
        final annotation = createdAnnotations[i];
        if (annotation != null) {
          if (i < activityCount) {
             _annotationData[annotation.id] = state.activities[i].toJson();
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
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
        ),
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
          MapWidget(
            key: const ValueKey('mapWidget'),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(-122.4194, 37.7749)), // SF Default
              zoom: 12.0,
            ),
            styleUri: MapboxStyles.LIGHT,
          ),
          
          // Loading Indicator
          if (activityState.isLoading)
            const Positioned(
              top: 50,
              right: 20,
              child: CircularProgressIndicator(),
            ),

          // Request Permission Button (if needed)
          if (!_locationPermissionGranted)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Location permission is needed to show your position.'),
                    ),
                    TextButton(
                      onPressed: _requestLocationPermission,
                      child: const Text('Allow'),
                    ),
                  ],
                ),
              ),
            ),
          
          // Floating Action Buttons
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'createBeacon',
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.push('/create-activity'),
                  child: const Icon(Icons.rocket_launch, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
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
