import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../trips/providers/trip_provider.dart';

/// Screen for creating a new trip (origin → destination).
///
/// Creates a Trip in the database that others can discover and join.
class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '7');
  final _originNameController = TextEditingController();
  final _destNameController = TextEditingController();
  final _maxCompanionsController = TextEditingController(text: '3');

  double? _originLat;
  double? _originLng;
  double? _destLat;
  double? _destLng;
  DateTime? _startDate;
  bool _lookingForCompanions = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _originNameController.dispose();
    _destNameController.dispose();
    _maxCompanionsController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.slate,
            ),
          ),
          child: child!,
        );
      },
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
    if (_titleController.text.trim().isEmpty) {
      ToastService.showError('Enter a title for your trip');
      return false;
    }
    if (_originLat == null) {
      ToastService.showError('Select your starting location');
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
      final tripData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'origin': {
          'lat': _originLat,
          'lng': _originLng,
          'place_name': _originNameController.text,
        },
        'destination': {
          'lat': _destLat,
          'lng': _destLng,
          'place_name': _destNameController.text,
        },
        'start_date': _startDate!.toUtc().toIso8601String(),
        'duration_days': int.parse(_durationController.text),
        'looking_for_companions': _lookingForCompanions,
        'max_companions': int.tryParse(_maxCompanionsController.text) ?? 3,
        'visibility': 'public',
      };

      final trip = await ref.read(tripProvider.notifier).createTrip(tripData);

      if (trip != null && mounted) {
        // Invalidate trip providers so they refresh
        ref.invalidate(myTripsProvider);
        ref.invalidate(nearbyTripsProvider);
        context.pop();
      }
    } catch (e) {
      ToastService.showError('Failed to create trip');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        title: const Text(
          'Create Trip',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Text(
                    'Create',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.route_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Plan Your Adventure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Others can discover your trip and join along',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title
            _buildLabel('Trip Title'),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.white),
              decoration: _inputDecoration('e.g., Road trip to Joshua Tree'),
            ),
            const SizedBox(height: 20),

            // Origin
            _buildLabel('Starting From'),
            GestureDetector(
              onTap: () => _openLocationPicker(isOrigin: true),
              child: AbsorbPointer(
                child: TextField(
                  controller: _originNameController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration('Tap to select location').copyWith(
                    prefixIcon: const Icon(Icons.trip_origin, color: AppColors.success),
                    suffixIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Destination
            _buildLabel('Destination'),
            GestureDetector(
              onTap: () => _openLocationPicker(isOrigin: false),
              child: AbsorbPointer(
                child: TextField(
                  controller: _destNameController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration('Tap to select location').copyWith(
                    prefixIcon: const Icon(Icons.location_on, color: AppColors.error),
                    suffixIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Start Date & Duration Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Date'),
                      GestureDetector(
                        onTap: _pickStartDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.slate,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                _startDate == null
                                    ? 'Select'
                                    : DateFormat('MMM d, yyyy').format(_startDate!),
                                style: TextStyle(
                                  color: _startDate == null ? AppColors.textSecondary : AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Duration (days)'),
                      TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.white),
                        decoration: _inputDecoration('7'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            _buildLabel('Description (optional)'),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.white),
              decoration: _inputDecoration('Tell others about your trip...'),
            ),
            const SizedBox(height: 24),

            // Looking for companions toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.slate,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Looking for companions',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Let others request to join your trip',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _lookingForCompanions,
                    onChanged: (v) => setState(() => _lookingForCompanions = v),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            if (_lookingForCompanions) ...[
              const SizedBox(height: 16),
              _buildLabel('Max Companions'),
              TextField(
                controller: _maxCompanionsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.white),
                decoration: _inputDecoration('3'),
              ),
            ],

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.slate,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
