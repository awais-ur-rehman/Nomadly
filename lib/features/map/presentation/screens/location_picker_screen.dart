import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart' as geo; // Keep for initial position
import '../../../../core/constants/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  final Map<String, double>? initialLocation; // Changed to simple map to avoid latlong2 dependency mismatch if possible

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  MapboxMap? _mapboxMap;
  // Default SF
  double _lat = 37.7749;
  double _lng = -122.4194;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (token != null) {
      MapboxOptions.setAccessToken(token);
    }

    if (widget.initialLocation != null) {
      _lat = widget.initialLocation!['lat']!;
      _lng = widget.initialLocation!['lng']!;
    } else {
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) return;
      }
      
      if (permission == geo.LocationPermission.deniedForever) return;

      final position = await geo.Geolocator.getCurrentPosition();
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });
      
      _mapboxMap?.setCamera(CameraOptions(
        center: Point(coordinates: Position(_lng, _lat)),
        zoom: 13,
      ));
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  void _onCameraChangeListener(CameraChangedEventData event) {
    // We need to get the center from the map logic
    // But mapbox_maps_flutter implies we should ask the map for its camera state
    // Or simpler: Just rely on the "pointer" being in center?
    // Doing async getCameraState might be heavy on every frame.
    // Usually we update on "Idle" or just when user clicks confirm.
  }

  Future<Map<String, dynamic>> _reverseGeocode(double lat, double lng) async {
    try {
      final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
      if (token == null) return {'name': null};

      final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json';
      final response = await Dio().get(
        url,
        queryParameters: {
          'access_token': token,
          'types': 'poi,address,neighborhood,place',
          'limit': 1,
        },
      );

      if (response.statusCode == 200 && response.data['features'] != null) {
        final features = response.data['features'] as List;
        if (features.isNotEmpty) {
          return {'name': features[0]['place_name']}; // or 'text' for shorter name
        }
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
    return {'name': null};
  }

  Future<void> _confirmSelection() async {
    setState(() => _isLoading = true);
    
    // Get exact center from map
    if (_mapboxMap != null) {
      final cameraState = await _mapboxMap!.getCameraState();
      final center = cameraState.center;
      if (center != null) {
        _lng = center.coordinates.lng as double;
        _lat = center.coordinates.lat as double;
      }
    }

    // Reverse Geocode
    final geo = await _reverseGeocode(_lat, _lng);
    final placeName = geo['name'];

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context, {
        'lat': _lat,
        'lng': _lng,
        'name': placeName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PICK LOCATION',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isLoading ? null : _confirmSelection,
              child: _isLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('locationPickerMap'),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(_lng, _lat)),
              zoom: 13.0,
            ),
            styleUri: MapboxStyles.DARK, // Vantage Theme
          ),
          
          // Center Marker (Fixed)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24), // Offset for pin point
              child: Icon(Icons.location_on, size: 48, color: AppColors.primary),
            ),
          ),
          
          // My Location Button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              backgroundColor: AppColors.obsidian,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
