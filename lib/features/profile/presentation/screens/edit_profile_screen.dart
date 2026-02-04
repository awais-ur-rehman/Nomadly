import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/services/api_client.dart';
import 'package:latlong2/latlong.dart';
import '../../../auth/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _newProfileImage;
  String? _currentPhotoUrl;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;

  late String _selectedGender;
  late List<String> _selectedHobbies;
  late String _selectedIntent;

  late String _selectedRigType;
  late String _selectedCrewType;
  late bool _isPetFriendly;

  // Travel route
  late TextEditingController _originNameController;
  double? _originLat;
  double? _originLng;
  late TextEditingController _destNameController;
  double? _destLat;
  double? _destLng;
  DateTime? _startDate;
  late TextEditingController _durationController;
  double _maxDistanceKm = 150;

  // Options
  final _genders = ['male', 'female', 'non-binary', 'other'];
  final _intents = ['friends', 'dating', 'both'];
  final _rigTypes = [
    'sprinter', 'skoolie', 'suv', 'truck_camper', 'rv', 'car', 'other'
  ];
  final _crewTypes = ['solo', 'couple', 'family', 'friends'];
  final _hobbies = [
    'Hiking', 'Surfing', 'Yoga', 'Climbing', 'Photography', 'Music',
    'Cooking', 'Reading', 'Gaming', 'Coding', 'Art', 'Travel', 'Vanlife',
    'Fishing', 'Kayaking', 'Biking', 'Running', 'Camping',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    final profile = user?.profile;
    final rig = user?.rig;
    final route = user?.travelRoute;

    _currentPhotoUrl = profile?.photoUrl;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _ageController = TextEditingController(text: profile?.age?.toString() ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');

    _selectedGender = profile?.gender ?? 'male';
    _selectedHobbies = List.from(profile?.hobbies ?? []);
    _selectedIntent = profile?.intent ?? 'friends';

    _selectedRigType = rig?.type ?? 'sprinter';
    _selectedCrewType = rig?.crewType ?? 'solo';
    _isPetFriendly = rig?.petFriendly ?? false;

    // Travel route
    _originNameController = TextEditingController();
    _destNameController = TextEditingController();
    _durationController = TextEditingController();
    if (route != null) {
      if (route.origin != null) {
        _originLat = route.origin!.coordinates[1];
        _originLng = route.origin!.coordinates[0];
        _originNameController.text =
            '${_originLat!.toStringAsFixed(2)}, ${_originLng!.toStringAsFixed(2)}';
      }
      if (route.destination != null) {
        _destLat = route.destination!.coordinates[1];
        _destLng = route.destination!.coordinates[0];
        _destNameController.text =
            '${_destLat!.toStringAsFixed(2)}, ${_destLng!.toStringAsFixed(2)}';
      }
      _startDate = route.startDate;
      if (route.durationDays != null) {
        _durationController.text = route.durationDays.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _originNameController.dispose();
    _destNameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImageUploadService().pickFromGallery(crop: true);
    if (image != null) setState(() => _newProfileImage = image);
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
      setState(() {
        if (isOrigin) {
          _originLat = result['lat'] as double;
          _originLng = result['lng'] as double;
          _originNameController.text =
              '${_originLat!.toStringAsFixed(2)}, ${_originLng!.toStringAsFixed(2)}';
        } else {
          _destLat = result['lat'] as double;
          _destLng = result['lng'] as double;
          _destNameController.text =
              '${_destLat!.toStringAsFixed(2)}, ${_destLng!.toStringAsFixed(2)}';
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHobbies.isEmpty) {
      ToastService.showError('Please select at least one hobby');
      return;
    }

    // 1. Upload new image if changed
    String? photoUrl = _currentPhotoUrl;
    if (_newProfileImage != null) {
      ToastService.showInfo('Uploading new photo...');
      final url = await ImageUploadService().uploadProfilePhoto(_newProfileImage!);
      if (url != null) photoUrl = url;
    }

    // 2. Update profile + rig
    final profileData = {
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text) ?? 18,
      'gender': _selectedGender,
      'hobbies': _selectedHobbies,
      'intent': _selectedIntent,
      'bio': _bioController.text.trim(),
      'photo_url': photoUrl,
    };

    final rigData = {
      'type': _selectedRigType,
      'crew_type': _selectedCrewType,
      'pet_friendly': _isPetFriendly,
    };

    final success = await ref.read(authProvider.notifier).completeProfile(
      profileData: profileData,
      rigData: rigData,
    );

    if (!success || !mounted) return;

    // 3. Update travel route if filled
    if (_originLat != null && _destLat != null && _startDate != null) {
      final duration = int.tryParse(_durationController.text) ?? 7;
      try {
        await ApiClient().patch(
          '${AppConfig.usersEndpoint}/route',
          data: {
            'origin': {'lat': _originLat, 'lng': _originLng},
            'destination': {'lat': _destLat, 'lng': _destLng},
            'start_date': _startDate!.toIso8601String(),
            'duration_days': duration,
          },
        );
      } catch (_) {}
    }

    // 4. Update distance preference
    try {
      await ApiClient().patch(
        '${AppConfig.usersEndpoint}/me',
        data: {
          'matching_profile': {
            'preferences': {
              'max_distance_km': _maxDistanceKm.round(),
            },
          },
        },
      );
    } catch (_) {}

    if (mounted) {
      ToastService.showSuccess('Profile updated!');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveProfile,
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.greyExtraLight,
                        backgroundImage: _newProfileImage != null
                            ? FileImage(_newProfileImage!)
                            : (_currentPhotoUrl != null
                                    ? CachedNetworkImageProvider(_currentPhotoUrl!)
                                    : null)
                                as ImageProvider?,
                        child: (_newProfileImage == null &&
                                _currentPhotoUrl == null)
                            ? const Icon(Icons.camera_alt,
                                size: 40, color: AppColors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.edit,
                              size: 16, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              // ─── Basic Info
              _sectionTitle('Basic Info'),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                    labelText: 'Age', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter age' : null,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                    labelText: 'Gender', border: OutlineInputBorder()),
                items: _genders
                    .map((g) => DropdownMenuItem(
                        value: g, child: Text(g.toUpperCase())))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val!),
              ),

              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Bio'),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'About Me',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              // ─── Rig
              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Rig & Crew'),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                value: _selectedRigType,
                decoration: const InputDecoration(
                    labelText: 'Rig Type', border: OutlineInputBorder()),
                items: _rigTypes
                    .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.replaceAll('_', ' ').toUpperCase())))
                    .toList(),
                onChanged: (val) => setState(() => _selectedRigType = val!),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                value: _selectedCrewType,
                decoration: const InputDecoration(
                    labelText: 'Crew Type', border: OutlineInputBorder()),
                items: _crewTypes
                    .map((c) => DropdownMenuItem(
                        value: c, child: Text(c.toUpperCase())))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCrewType = val!),
              ),
              SwitchListTile(
                title: const Text('Pet Friendly'),
                contentPadding: EdgeInsets.zero,
                value: _isPetFriendly,
                onChanged: (val) => setState(() => _isPetFriendly = val),
              ),

              // ─── Travel Route
              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Travel Route'),
              const SizedBox(height: AppDimensions.paddingS),
              TextField(
                controller: _originNameController,
                decoration: InputDecoration(
                  labelText: 'Current location',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.my_location),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () => _openLocationPicker(isOrigin: true),
                  ),
                ),
                readOnly: true,
                onTap: () => _openLocationPicker(isOrigin: true),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              TextField(
                controller: _destNameController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.place),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () => _openLocationPicker(isOrigin: false),
                  ),
                ),
                readOnly: true,
                onTap: () => _openLocationPicker(isOrigin: false),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _startDate != null
                      ? 'Starts ${DateFormat.yMMMd().format(_startDate!)}'
                      : 'Start date',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickStartDate,
              ),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Trip duration (days)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timelapse),
                ),
                keyboardType: TextInputType.number,
              ),

              // ─── Distance
              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Search Distance'),
              Slider(
                value: _maxDistanceKm,
                min: 25,
                max: 500,
                divisions: 19,
                label: '${_maxDistanceKm.round()} km',
                onChanged: (val) => setState(() => _maxDistanceKm = val),
              ),
              Center(
                child: Text('${_maxDistanceKm.round()} km',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),

              // ─── Intent
              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Intent'),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                value: _selectedIntent,
                decoration: const InputDecoration(
                    labelText: 'Looking for', border: OutlineInputBorder()),
                items: _intents
                    .map((i) => DropdownMenuItem(
                        value: i, child: Text(i.toUpperCase())))
                    .toList(),
                onChanged: (val) => setState(() => _selectedIntent = val!),
              ),

              // ─── Hobbies
              const SizedBox(height: AppDimensions.paddingL),
              _sectionTitle('Hobbies'),
              const SizedBox(height: AppDimensions.paddingS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _hobbies.map((hobby) {
                  final isSelected = _selectedHobbies.contains(hobby);
                  return FilterChip(
                    label: Text(hobby),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedHobbies.add(hobby);
                        } else {
                          _selectedHobbies.remove(hobby);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
