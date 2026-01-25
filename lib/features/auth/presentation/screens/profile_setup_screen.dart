import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 6;

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

  // Options
  final List<String> _genders = ['male', 'female', 'non-binary', 'other'];
  final List<String> _intents = ['friends', 'dating', 'both'];
  final List<String> _rigTypes = ['sprinter', 'skoolie', 'suv', 'truck_camper', 'rv', 'car', 'other'];
  final List<String> _crewTypes = ['solo', 'couple', 'family', 'friends'];
  final List<String> _hobbies = [
    'Hiking', 'Surfing', 'Yoga', 'Climbing', 'Photography', 'Music', 
    'Cooking', 'Reading', 'Gaming', 'Coding', 'Art', 'Travel', 'Vanlife'
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill name if available via auth provider (if user just registered)
    final user = ref.read(authProvider).user;
    if (user != null) {
      _nameController.text = user.profile.name;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step
      if (!_validateStep(_currentStep)) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
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
      setState(() {
        _currentStep--;
      });
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
        if (_nameController.text.isEmpty) {
          ToastService.showError('Please enter your name');
          return false;
        }
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
      case 3: // Intent
        return true;
      case 4: // Rig
        return true;
      case 5: // Bio
        if (_bioController.text.isEmpty) {
          ToastService.showError('Please write a short bio');
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
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _completeProfile() async {
    // 1. Upload Image
    if (_profileImage != null && _uploadedImageUrl == null) {
        // Show loading or toast
        ToastService.showInfo('Uploading profile photo...');
        final url = await ImageUploadService().uploadProfilePhoto(_profileImage!);
        if (url == null) return; // Error handled in service
        _uploadedImageUrl = url;
    }

    // 2. Prepare Data
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

    // 3. Call API
    final success = await ref.read(authProvider.notifier).completeProfile(
      profileData: profileData,
      rigData: rigData,
    );

    if (success && mounted) {
      context.go('/home');
    }
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
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  _buildPhotoStep(),
                  _buildBasicInfoStep(),
                  _buildHobbiesStep(),
                  _buildIntentStep(),
                  _buildRigStep(),
                  _buildBioStep(),
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
                      : Text(_currentStep == _totalSteps - 1 ? AppStrings.finish : AppStrings.continue_),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Photo
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
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.camera_alt, size: 50, color: AppColors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Text('Tap to upload a profile photo'),
        ],
      ),
    );
  }

  // Step 2: Basic Info
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
              controller: _nameController,
              decoration: const InputDecoration(labelText: AppStrings.name),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g.toUpperCase()))).toList(),
              onChanged: (val) => setState(() => _selectedGender = val!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Hobbies
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

  // Step 4: Intent
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
          ..._intents.map((intent) => RadioListTile<String>(
            title: Text(intent.toUpperCase()),
            value: intent,
            groupValue: _selectedIntent,
            onChanged: (val) => setState(() => _selectedIntent = val!),
          )),
        ],
      ),
    );
  }

  // Step 5: Rig
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
              initialValue: _selectedRigType,
              items: _rigTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').toUpperCase()))).toList(),
              onChanged: (val) => setState(() => _selectedRigType = val!),
              decoration: const InputDecoration(labelText: 'Rig Type'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            DropdownButtonFormField<String>(
              initialValue: _selectedCrewType,
              items: _crewTypes.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
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

  // Step 6: Bio
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
}
