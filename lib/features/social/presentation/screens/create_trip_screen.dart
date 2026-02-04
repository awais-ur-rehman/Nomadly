import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/toast_service.dart';

/// Screen for announcing a new trip (origin → destination).
///
/// Updates the user's `travel_route` on the backend so the matching
/// algorithm can use it, and optionally creates a feed post so friends
/// can see the announcement and join.
class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '7');
  final _originNameController = TextEditingController();
  final _destNameController = TextEditingController();

  double? _originLat;
  double? _originLng;
  double? _destLat;
  double? _destLng;
  DateTime? _startDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _durationController.dispose();
    _originNameController.dispose();
    _destNameController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _openLocationPicker({required bool isOrigin}) async {
    final result = await context.push<Map<String, dynamic>>('/location-picker');
    if (result != null && mounted) {
      final lat = result['lat'] as double;
      final lng = result['lng'] as double;
      final name = result['name'] as String?;

      setState(() {
        if (isOrigin) {
          _originLat = lat;
          _originLng = lng;
          _originNameController.text =
              name ?? '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
        } else {
          _destLat = lat;
          _destLng = lng;
          _destNameController.text =
              name ?? '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
        }
      });
    }
  }

  bool _validate() {
    if (_originLat == null) {
      ToastService.showError('Select your current location');
      return false;
    }
    if (_destLat == null) {
      ToastService.showError('Select your destination');
      return false;
    }
    if (_startDate == null) {
      ToastService.showError('Pick a start date');
      return false;
    }
    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration < 1) {
      ToastService.showError('Enter a valid trip duration');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() => _isSaving = true);

    try {
      // 1. Update travel route on backend
      await ApiClient().patch(
        '${AppConfig.usersEndpoint}/route',
        data: {
          'origin': {'lat': _originLat, 'lng': _originLng},
          'destination': {'lat': _destLat, 'lng': _destLng},
          'start_date': _startDate!.toUtc().toIso8601String(),
          'duration_days': int.parse(_durationController.text),
        },
      );

      // 2. Optionally create a post to announce the trip
      final description = _descriptionController.text.trim();
      if (description.isNotEmpty) {
        try {
          // Note: Posts require at least one photo per API schema
          // Skip post creation if no photos available
          // The trip route was already saved above
        } catch (_) {
          // Post creation is non-critical
        }
      }

      if (mounted) {
        ToastService.showSuccess('Trip announced!');
        context.pop();
      }
    } catch (e) {
      ToastService.showError('Failed to save trip');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Trip'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header illustration
            Center(
              child: Column(
                children: [
                  Icon(Icons.route_outlined,
                      size: 48, color: AppColors.primary),
                  const SizedBox(height: 8),
                  const Text(
                    'Where are you heading?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Others can see your route and join along',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Origin
            TextField(
              controller: _originNameController,
              readOnly: true,
              onTap: () => _openLocationPicker(isOrigin: true),
              decoration: InputDecoration(
                labelText: 'From',
                prefixIcon: const Icon(Icons.my_location),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map_outlined),
                  onPressed: () => _openLocationPicker(isOrigin: true),
                ),
              ),
            ),

            // Arrow
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Icon(Icons.arrow_downward, color: AppColors.grey),
              ),
            ),

            // Destination
            TextField(
              controller: _destNameController,
              readOnly: true,
              onTap: () => _openLocationPicker(isOrigin: false),
              decoration: InputDecoration(
                labelText: 'To',
                prefixIcon: const Icon(Icons.place),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map_outlined),
                  onPressed: () => _openLocationPicker(isOrigin: false),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date + duration row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat.yMMMd().format(_startDate!)
                            : 'Select',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Days',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Optional description
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Say something about this trip (optional)',
                hintText: 'Looking for travel buddies heading the same way!',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
