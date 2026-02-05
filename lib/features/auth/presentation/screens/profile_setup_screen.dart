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
  final int _totalSteps = 4;

  // Form State
  File? _profileImage;
  String? _uploadedImageUrl;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedGender = 'male';
  final List<String> _selectedHobbies = [];
  String _selectedIntent = 'friends';
  String _selectedRigType = 'van';
  String _selectedCrewType = 'solo';
  bool _isPetFriendly = false;

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
  
  final Map<String, IconData> _rigTypeOptions = {
    'van': Icons.directions_bus_outlined,
    'bus': Icons.airport_shuttle_outlined,
    'truck': Icons.local_shipping_outlined,
    'car': Icons.directions_car_outlined,
    'rv': Icons.rv_hookup_outlined,
    'other': Icons.more_horiz_outlined,
  };

  final List<String> _crewTypes = ['solo', 'couple', 'family', 'friends'];
  final List<String> _hobbies = [
    'Hiking', 'Surfing', 'Yoga', 'Climbing', 'Photography', 'Music',
    'Cooking', 'Reading', 'Gaming', 'Coding', 'Art', 'Travel', 'Vanlife',
    'Fishing', 'Kayaking', 'Biking', 'Running', 'Camping',
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
    super.dispose();
  }

  void _nextStep() {
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
      case 0: // Essentials
        if (_profileImage == null) {
          ToastService.showError('Please upload a profile photo');
          return false;
        }
        if (_ageController.text.isEmpty) {
          ToastService.showError('Please enter your age');
          return false;
        }
        return true;
      case 1: // Social Identity
        if (_bioController.text.isEmpty) {
          ToastService.showError('Please write a short bio');
          return false;
        }
        if (_selectedHobbies.isEmpty) {
          ToastService.showError('Select at least one hobby');
          return false;
        }
        return true;
      case 2: // Nomad Setup
        return true;
      case 3: // Discovery
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

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Back'),
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
                  _buildEssentialsSection(), // 0
                  _buildSocialIdentitySection(), // 1
                  _buildNomadSetupSection(), // 2
                  _buildDiscoverySection(), // 3
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightL,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _nextStep,
                  child: authState.isLoading && _currentStep == _totalSteps - 1
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(_currentStep == _totalSteps - 1 ? 'Start Exploring' : 'Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Builders ──────────────────────────────────────────

  Widget _buildEssentialsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('The Face', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Let the community see who you are.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: AppColors.greyExtraLight,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 50, color: AppColors.grey)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'How old are you?'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          const Text('Gender Identity', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: _genders.map((g) => ChoiceChip(
              label: Text(g.toUpperCase()),
              selected: _selectedGender == g,
              onSelected: (val) => setState(() => _selectedGender = g),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIdentitySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('The Vibe', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('What are you into?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          const Text('Short Bio', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'I love vanlife and campfires...',
            ),
          ),
          const SizedBox(height: 24),
          
          const Text('Hobbies', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
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
                    if (selected) _selectedHobbies.add(hobby);
                    else _selectedHobbies.remove(hobby);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          const Text('Matching Intent', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: _intents.map((intent) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(intent.toUpperCase()),
                  selected: _selectedIntent == intent,
                  onSelected: (val) => setState(() => _selectedIntent = intent),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNomadSetupSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('The Rig', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tell us about your home on wheels.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          const Text('Rig Type', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _rigTypeOptions.entries.map((entry) {
              final isSelected = _selectedRigType == entry.key;
              return InkWell(
                onTap: () => setState(() => _selectedRigType = entry.key),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(entry.value, color: isSelected ? AppColors.primary : Colors.grey),
                      const SizedBox(height: 4),
                      Text(entry.key.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          const Text('Crew Type', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: _crewTypes.map((c) => ChoiceChip(
              label: Text(c.toUpperCase()),
              selected: _selectedCrewType == c,
              onSelected: (val) => setState(() => _selectedCrewType = c),
            )).toList(),
          ),
          
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pet Friendly'),
            subtitle: const Text('Do you travel with furry friends?'),
            value: _isPetFriendly,
            onChanged: (val) => setState(() => _isPetFriendly = val),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('The Journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Where are you headed?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          TextField(
            controller: _originNameController,
            decoration: InputDecoration(
              labelText: 'Where are you now?',
              prefixIcon: const Icon(Icons.my_location),
              suffixIcon: IconButton(icon: const Icon(Icons.map_outlined), onPressed: () => _openLocationPicker(isOrigin: true)),
            ),
            readOnly: true,
            onTap: () => _openLocationPicker(isOrigin: true),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _destNameController,
            decoration: InputDecoration(
              labelText: 'Where are you heading?',
              prefixIcon: const Icon(Icons.place),
              suffixIcon: IconButton(icon: const Icon(Icons.map_outlined), onPressed: () => _openLocationPicker(isOrigin: false)),
            ),
            readOnly: true,
            onTap: () => _openLocationPicker(isOrigin: false),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(_startDate != null ? DateFormat.yMMMd().format(_startDate!) : 'Departure Date'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _pickStartDate,
          ),
          
          const SizedBox(height: 48),
          const Text('Search Distance', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${_maxDistanceKm.round()} km radius', style: const TextStyle(color: AppColors.primary)),
          Slider(
            value: _maxDistanceKm,
            min: 25,
            max: 500,
            divisions: 19,
            onChanged: (val) => setState(() => _maxDistanceKm = val),
          ),
        ],
      ),
    );
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
          _originNameController.text = name ?? '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
        } else {
          _destLat = lat;
          _destLng = lng;
          _destNameController.text = name ?? '${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}';
        }
      });
    }
  }
}
