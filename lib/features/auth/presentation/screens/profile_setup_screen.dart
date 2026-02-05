import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../core/config/app_config.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  int _totalSteps = 10;

  // Form State
  File? _profileImage;
  String? _uploadedImageUrl;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedGender = 'male';
  final List<String> _selectedHobbies = [];
  String _selectedIntent = 'friends';
  String _selectedRigType = 'sprinter';
  String _selectedCrewType = 'solo';
  bool _isPetFriendly = false;

  // Builder Profile state
  bool _wantsToBeBuilder = false;
  final List<String> _selectedSpecialties = [];
  final _hourlyRateController = TextEditingController();
  final _builderBioController = TextEditingController();

  // Travel Route state
  final _originNameController = TextEditingController();
  double? _originLat;
  double? _originLng;
  final _destNameController = TextEditingController();
  double? _destLat;
  double? _destLng;
  DateTime? _startDate;
  final _durationController = TextEditingController();

  // Distance preference
  double _maxDistanceKm = 150;

  // Options
  final List<String> _genders = ['male', 'female', 'non-binary', 'other'];
  final List<String> _intents = ['friends', 'dating', 'both'];
  final List<String> _rigTypes = [
    'sprinter', 'skoolie', 'suv', 'truck_camper', 'rv', 'car', 'other'
  ];
  final List<String> _crewTypes = ['solo', 'couple', 'family', 'friends'];
  final List<String> _hobbies = [
    'Hiking', 'Surfing', 'Yoga', 'Climbing', 'Photography', 'Music',
    'Cooking', 'Reading', 'Gaming', 'Coding', 'Art', 'Travel', 'Vanlife',
    'Fishing', 'Kayaking', 'Biking', 'Running', 'Camping',
  ];
  final List<String> _specialties = [
    'van', 'electrical', 'solar', 'plumbing', 'woodwork', 'consultation'
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      _nameController.text = user.profile?.name ?? '';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _originNameController.dispose();
    _destNameController.dispose();
    _durationController.dispose();
    _hourlyRateController.dispose();
    _builderBioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // If it's the builder opt-in step and they say "No", we can finish early
    if (_currentStep == 8 && !_wantsToBeBuilder) {
      _completeProfile();
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      if (!_validateStep(_currentStep)) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _completeProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0: // Photo
        if (_profileImage == null) {
          ToastService.showError('Please upload a profile photo');
          return false;
        }
        return true;
      case 1: // Basic Info
        if (_ageController.text.isEmpty) {
          ToastService.showError('Please enter your age');
          return false;
        }
        return true;
      case 2: // Hobbies
        if (_selectedHobbies.isEmpty) {
          ToastService.showError('Please select at least one hobby');
          return false;
        }
        return true;
      case 3: // Rig
        return true;
      case 4: // Travel Route
        // Travel route is optional during setup — users can set it later
        return true;
      case 5: // Distance
        return true;
      case 6: // Intent
        return true;
      case 7: // Bio
        if (_bioController.text.isEmpty) {
          ToastService.showError('Please write a short bio');
          return false;
        }
        return true;
      case 9: // Builder Details
        if (_selectedSpecialties.isEmpty) {
          ToastService.showError('Please select at least one specialty');
          return false;
        }
        if (_hourlyRateController.text.isEmpty) {
          ToastService.showError('Please enter your hourly rate');
          return false;
        }
        if (_builderBioController.text.isEmpty) {
          ToastService.showError('Please write a short builder bio');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _pickImage() async {
    final image = await ImageUploadService().pickFromGallery(crop: true);
    if (image != null) {
      setState(() => _profileImage = image);
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _completeProfile() async {
    // 1. Upload image
    if (_profileImage != null && _uploadedImageUrl == null) {
      ToastService.showInfo('Uploading profile photo...');
      final url = await ImageUploadService().uploadProfilePhoto(_profileImage!);
      if (url == null) return;
      _uploadedImageUrl = url;
    }

    // 2. Complete profile (profile + rig)
    final profileData = {
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text) ?? 18,
      'gender': _selectedGender,
      'hobbies': _selectedHobbies,
      'intent': _selectedIntent,
      'bio': _bioController.text.trim(),
      'photo_url': _uploadedImageUrl,
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

    // 2.5 Update Builder Profile if opted in
    if (_wantsToBeBuilder) {
      try {
        await ApiClient().patch(
          '${AppConfig.usersEndpoint}/me',
          data: {
            'is_builder': true,
            'builder_profile': {
              'specialty_tags': _selectedSpecialties,
              'hourly_rate': int.tryParse(_hourlyRateController.text) ?? 0,
              'bio': _builderBioController.text.trim(),
              'availability_status': 'available',
            },
          },
        );
      } catch (e) {
        // Non-blocking
      }
    }

    // 3. Update travel route if user provided origin + destination
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
      } catch (_) {
        // Non-blocking — travel route can be set later
      }
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
    } catch (_) {
      // Non-blocking
    }

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.completeProfile),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: AppColors.greyExtraLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPhotoStep(),       // 0
                  _buildBasicInfoStep(),   // 1
                  _buildHobbiesStep(),     // 2
                  _buildRigStep(),         // 3
                  _buildTravelRouteStep(), // 4 — NEW
                  _buildDistanceStep(),    // 5 — NEW
                  _buildIntentStep(),      // 6
                  _buildBioStep(),         // 7
                  _buildBuilderOptInStep(), // 8
                  _buildBuilderDetailStep(), // 9
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightL,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _nextStep,
                  child: authState.isLoading && _currentStep == _totalSteps - 1
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(
                          (_currentStep == _totalSteps - 1 || (_currentStep == 8 && !_wantsToBeBuilder))
                              ? AppStrings.finish
                              : AppStrings.continue_,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step Builders ─────────────────────────────────────────────

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.uploadPhoto,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: AppColors.greyExtraLight,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.camera_alt,
                      size: 50, color: AppColors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Text('Tap to upload a profile photo'),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: _genders
                  .map((g) =>
                      DropdownMenuItem(value: g, child: Text(g.toUpperCase())))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGender = val!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHobbiesStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppStrings.selectHobbies,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRigStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.rigInfo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            DropdownButtonFormField<String>(
              value: _selectedRigType,
              items: _rigTypes
                  .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.replaceAll('_', ' ').toUpperCase())))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRigType = val!),
              decoration: const InputDecoration(labelText: 'Rig Type'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            DropdownButtonFormField<String>(
              value: _selectedCrewType,
              items: _crewTypes
                  .map((c) => DropdownMenuItem(
                      value: c, child: Text(c.toUpperCase())))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCrewType = val!),
              decoration: const InputDecoration(labelText: 'Crew Type'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            SwitchListTile(
              title: const Text('Pet Friendly'),
              value: _isPetFriendly,
              onChanged: (val) => setState(() => _isPetFriendly = val),
            ),
          ],
        ),
      ),
    );
  }

  // NEW — Step 5: Travel Route
  Widget _buildTravelRouteStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Travel Route',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'This helps us match you with nomads heading the same way',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            // Origin
            TextField(
              controller: _originNameController,
              decoration: InputDecoration(
                labelText: 'Where are you now?',
                prefixIcon: const Icon(Icons.my_location),
                hintText: 'e.g. Denver, CO',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map_outlined),
                  onPressed: () => _openLocationPicker(isOrigin: true),
                ),
              ),
              readOnly: true,
              onTap: () => _openLocationPicker(isOrigin: true),
            ),
            if (_originLat != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  '${_originLat!.toStringAsFixed(4)}, ${_originLng!.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),

            const SizedBox(height: AppDimensions.paddingM),

            // Destination
            TextField(
              controller: _destNameController,
              decoration: InputDecoration(
                labelText: 'Where are you heading?',
                prefixIcon: const Icon(Icons.place),
                hintText: 'e.g. Moab, UT',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map_outlined),
                  onPressed: () => _openLocationPicker(isOrigin: false),
                ),
              ),
              readOnly: true,
              onTap: () => _openLocationPicker(isOrigin: false),
            ),
            if (_destLat != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  '${_destLat!.toStringAsFixed(4)}, ${_destLng!.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),

            const SizedBox(height: AppDimensions.paddingM),

            // Start date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _startDate != null
                    ? 'Starts ${DateFormat.yMMMd().format(_startDate!)}'
                    : 'When do you start?',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickStartDate,
            ),

            // Duration
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Trip duration (days)',
                prefixIcon: Icon(Icons.timelapse),
                hintText: '7',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: AppDimensions.paddingL),
            Text(
              'You can skip this and set it later from your profile.',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // NEW — Step 6: Distance Preference
  Widget _buildDistanceStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Search Distance',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'How far should we look for other nomads?',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const Spacer(),
          Center(
            child: Text(
              '${_maxDistanceKm.round()} km',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Slider(
            value: _maxDistanceKm,
            min: 25,
            max: 500,
            divisions: 19,
            label: '${_maxDistanceKm.round()} km',
            onChanged: (val) => setState(() => _maxDistanceKm = val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('25 km', style: TextStyle(color: Colors.grey[500])),
              Text('500 km', style: TextStyle(color: Colors.grey[500])),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildIntentStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppStrings.selectIntent,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          ..._intents.map((intent) {
            final label = switch (intent) {
              'friends' => 'Find Friends',
              'dating' => 'Find a Date',
              'both' => 'Both',
              _ => intent,
            };
            final icon = switch (intent) {
              'friends' => Icons.people_outline,
              'dating' => Icons.favorite_outline,
              'both' => Icons.explore_outlined,
              _ => Icons.circle,
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: _selectedIntent == intent
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey[100],
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _selectedIntent = intent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Icon(icon,
                            color: _selectedIntent == intent
                                ? AppColors.primary
                                : Colors.grey),
                        const SizedBox(width: 16),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedIntent == intent
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _selectedIntent == intent
                                ? AppColors.primary
                                : null,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedIntent == intent)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBioStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppStrings.bio,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          TextField(
            controller: _bioController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Tell us about yourself...',
              hintText: 'I love traveling and meeting new people!',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilderOptInStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Marketplace',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Would you like to offer your skills as a builder or specialist on the Nomad Marketplace?',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('I want to register as a builder/specialist'),
            subtitle: const Text('Only toggle this if you want to provide services to other nomads.'),
            value: _wantsToBeBuilder,
            onChanged: (val) => setState(() => _wantsToBeBuilder = val),
            activeColor: AppColors.primary,
          ),
          if (_wantsToBeBuilder)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Great! In the next step, we will ask for your service details.',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBuilderDetailStep() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: ListView(
        children: [
          const Text(
            'Service Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tell us what you specialize in and how much you charge.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          const Text('YOUR SPECIALTIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _specialties.map((s) {
              final isSelected = _selectedSpecialties.contains(s);
              return FilterChip(
                label: Text(s.toUpperCase()),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) _selectedSpecialties.add(s);
                    else _selectedSpecialties.remove(s);
                  });
                },
                selectedColor: AppColors.primaryExtraLight,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          TextField(
            controller: _hourlyRateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'What is your hourly rate?',
              suffixText: 'USD / hr',
              prefixText: '\$ ',
            ),
          ),
          
          const SizedBox(height: 24),
          TextField(
            controller: _builderBioController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'About Your Services',
              hintText: 'Describe your experience with van electrical, solar setups, etc...',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Location Picker ─────────────────────────────────────────

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
              name ?? '${_originLat!.toStringAsFixed(2)}, ${_originLng!.toStringAsFixed(2)}';
        } else {
          _destLat = lat;
          _destLng = lng;
          _destNameController.text =
              name ?? '${_destLat!.toStringAsFixed(2)}, ${_destLng!.toStringAsFixed(2)}';
        }
      });
    }
  }
}
