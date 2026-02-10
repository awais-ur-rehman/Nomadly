import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/services/api_client.dart';
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

  // Options - must match backend enum values
  final _genders = ['male', 'female', 'non-binary', 'other'];
  final _intents = ['friends', 'dating', 'both'];
  final _rigTypes = [
    'van', 'bus', 'truck', 'car', 'rv', 'sprinter', 'skoolie', 'suv', 'truck_camper', 'other'
  ];
  final _crewTypes = ['solo', 'couple', 'family', 'friends', 'with_pets'];
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

    // Validate dropdown values exist in options list
    final gender = profile?.gender ?? 'male';
    _selectedGender = _genders.contains(gender) ? gender : 'other';

    _selectedHobbies = List.from(profile?.hobbies ?? []);

    final intent = profile?.intent ?? 'friends';
    _selectedIntent = _intents.contains(intent) ? intent : 'friends';

    final rigType = rig?.type ?? 'van';
    _selectedRigType = _rigTypes.contains(rigType) ? rigType : 'other';

    final crewType = rig?.crewType ?? 'solo';
    _selectedCrewType = _crewTypes.contains(crewType) ? crewType : 'solo';

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
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
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

  InputDecoration _inputDecoration(String label, {IconData? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontFamily: 'Inter'),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.white.withValues(alpha: 0.5)) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.slate,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

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
          'Edit Profile',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: isLoading ? null : _saveProfile,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3),
                        ),
                        child: ClipOval(
                          child: _newProfileImage != null
                              ? Image.file(_newProfileImage!, fit: BoxFit.cover)
                              : (_currentPhotoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: _currentPhotoUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(color: AppColors.slate),
                                    )
                                  : Container(
                                      color: AppColors.slate,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.white.withValues(alpha: 0.5),
                                      ),
                                    )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 18, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Basic Info Section
              _buildSectionTitle('Basic Info'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Name'),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Age'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter age' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                dropdownColor: AppColors.slate,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Gender'),
                items: _genders.map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(_capitalize(g)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedGender = val!),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Bio'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('About Me'),
              ),

              // Rig Section
              const SizedBox(height: 24),
              _buildSectionTitle('Rig & Crew'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedRigType,
                dropdownColor: AppColors.slate,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Rig Type'),
                items: _rigTypes.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(_capitalize(t.replaceAll('_', ' '))),
                )).toList(),
                onChanged: (val) => setState(() => _selectedRigType = val!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCrewType,
                dropdownColor: AppColors.slate,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Crew Type'),
                items: _crewTypes.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(_capitalize(c)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedCrewType = val!),
              ),
              const SizedBox(height: 12),
              _buildSwitchRow(
                title: 'Pet Friendly',
                value: _isPetFriendly,
                onChanged: (val) => setState(() => _isPetFriendly = val),
              ),

              // Travel Route Section
              const SizedBox(height: 24),
              _buildSectionTitle('Travel Route'),
              const SizedBox(height: 12),
              TextField(
                controller: _originNameController,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration(
                  'Current Location',
                  prefixIcon: Icons.my_location,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map_outlined, color: Colors.white.withValues(alpha: 0.5)),
                    onPressed: () => _openLocationPicker(isOrigin: true),
                  ),
                ),
                readOnly: true,
                onTap: () => _openLocationPicker(isOrigin: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _destNameController,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration(
                  'Destination',
                  prefixIcon: Icons.place,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map_outlined, color: Colors.white.withValues(alpha: 0.5)),
                    onPressed: () => _openLocationPicker(isOrigin: false),
                  ),
                ),
                readOnly: true,
                onTap: () => _openLocationPicker(isOrigin: false),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickStartDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.slate,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white.withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _startDate != null
                              ? 'Starts ${DateFormat.yMMMd().format(_startDate!)}'
                              : 'Select start date',
                          style: TextStyle(
                            color: _startDate != null ? AppColors.white : Colors.white.withValues(alpha: 0.6),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _durationController,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Trip duration (days)', prefixIcon: Icons.timelapse),
                keyboardType: TextInputType.number,
              ),

              // Search Distance Section
              const SizedBox(height: 24),
              _buildSectionTitle('Search Distance'),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                  valueIndicatorColor: AppColors.primary,
                  valueIndicatorTextStyle: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                ),
                child: Slider(
                  value: _maxDistanceKm,
                  min: 25,
                  max: 500,
                  divisions: 19,
                  label: '${_maxDistanceKm.round()} km',
                  onChanged: (val) => setState(() => _maxDistanceKm = val),
                ),
              ),
              Center(
                child: Text(
                  '${_maxDistanceKm.round()} km',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                    fontSize: 16,
                  ),
                ),
              ),

              // Intent Section
              const SizedBox(height: 24),
              _buildSectionTitle('Looking For'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedIntent,
                dropdownColor: AppColors.slate,
                style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
                decoration: _inputDecoration('Intent'),
                items: _intents.map((i) => DropdownMenuItem(
                  value: i,
                  child: Text(_capitalize(i)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedIntent = val!),
              ),

              // Hobbies Section
              const SizedBox(height: 24),
              _buildSectionTitle('Hobbies'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _hobbies.map((hobby) {
                  final isSelected = _selectedHobbies.contains(hobby);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedHobbies.remove(hobby);
                        } else {
                          _selectedHobbies.add(hobby);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.slate,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        hobby,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'Inter',
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        fontFamily: 'Outfit',
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Inter',
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white.withValues(alpha: 0.5),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
