import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../auth/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Data
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
    final user = ref.read(authProvider).user;
    final profile = user?.profile;
    final rig = user?.rig;

    _currentPhotoUrl = profile?.photoUrl;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    
    _selectedGender = profile?.gender ?? 'male';
    _selectedHobbies = List.from(profile?.hobbies ?? []);
    _selectedIntent = profile?.intent ?? 'friends';
    
    _selectedRigType = rig?.type ?? 'sprinter';
    _selectedCrewType = rig?.crewType ?? 'solo';
    _isPetFriendly = rig?.petFriendly ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImageUploadService().pickFromGallery(crop: true);
    if (image != null) {
      setState(() {
        _newProfileImage = image;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHobbies.isEmpty) {
      ToastService.showError('Please select at least one hobby');
      return;
    }

    // 1. Upload Image (if changed)
    String? photoUrl = _currentPhotoUrl;
    if (_newProfileImage != null) {
      ToastService.showInfo('Uploading new photo...');
      final url = await ImageUploadService().uploadProfilePhoto(_newProfileImage!);
      if (url != null) photoUrl = url;
    }

    // 2. Prepare Data
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

    // 3. Call API
    // Using completeProfile method or updateProfile? 
    // AuthNotifier has completeProfile which calls API. 
    // We should probably check if AuthNotifier has generic updateProfile or use ProfileRepository directly?
    // AuthProvider holds the user state, so updating via AuthProvider is best to keep local state in sync.
    // I'll use authProvider.notifier.completeProfile (it calls updateProfile internally usually)
    // Or check if I can add updateProfile to AuthNotifier if completeProfile is specific to onboarding.
    // completeProfile uses `_repository.updateProfile`. So it is same.
    
    final success = await ref.read(authProvider.notifier).completeProfile(
      profileData: profileData,
      rigData: rigData,
    );

    if (success && mounted) {
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
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
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
                            : (_currentPhotoUrl != null ? CachedNetworkImageProvider(_currentPhotoUrl!) : null) as ImageProvider?,
                        child: (_newProfileImage == null && _currentPhotoUrl == null)
                            ? const Icon(Icons.camera_alt, size: 40, color: AppColors.grey)
                            : null,
                      ),
                       Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.edit, size: 16, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              _buildSectionTitle('Basic Info'),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter age' : null,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedGender = val!),
              ),

              const SizedBox(height: AppDimensions.paddingL),
              _buildSectionTitle('Bio'),
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

              const SizedBox(height: AppDimensions.paddingL),
              _buildSectionTitle('Rig & Travel'),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                initialValue: _selectedRigType,
                decoration: const InputDecoration(labelText: 'Rig Type', border: OutlineInputBorder()),
                items: _rigTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedRigType = val!),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              DropdownButtonFormField<String>(
                initialValue: _selectedCrewType,
                decoration: const InputDecoration(labelText: 'Crew Type', border: OutlineInputBorder()),
                items: _crewTypes.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedCrewType = val!),
              ),
              SwitchListTile(
                title: const Text('Pet Friendly'),
                contentPadding: EdgeInsets.zero,
                value: _isPetFriendly,
                onChanged: (val) => setState(() => _isPetFriendly = val),
              ),

              const SizedBox(height: AppDimensions.paddingL),
              _buildSectionTitle('Intent'),
              const SizedBox(height: AppDimensions.paddingS),
               DropdownButtonFormField<String>(
                initialValue: _selectedIntent,
                decoration: const InputDecoration(labelText: 'Looking for', border: OutlineInputBorder()),
                items: _intents.map((i) => DropdownMenuItem(value: i, child: Text(i.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedIntent = val!),
              ),

              const SizedBox(height: AppDimensions.paddingL),
              _buildSectionTitle('Hobbies'),
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

  Widget _buildSectionTitle(String title) {
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
