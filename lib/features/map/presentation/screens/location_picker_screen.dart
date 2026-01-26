import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  LatLng _currentCenter = const LatLng(37.7749, -122.4194); // Default SF

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLocation != null) {
      _currentCenter = widget.initialLocation!;
    } else {
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentCenter, 13);
    } catch (e) {
      // Handle permission errors or disabled location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _currentCenter);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 13,
              onPositionChanged: (position, hasGesture) {
                if (position.center != null) {
                  setState(() {
                    _currentCenter = position.center!;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.nomadly.app',
              ),
            ],
          ),
          const Center(
            child: Icon(Icons.location_on, size: 50, color: AppColors.primary),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
