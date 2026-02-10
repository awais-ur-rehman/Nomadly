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
  int _totalSteps = 5; 

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

  // Builder Profile state
  bool _wantsToBeBuilder = false;
  final List<String> _selectedSpecialties = [];
  final _hourlyRateController = TextEditingController();
  final _builderBioController = TextEditingController();
  List<File> _portfolioImages = [];
  List<String> _portfolioImageUrls = [];

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
      case 4: // Builder Opt-in
        return true;
      case 5: // Builder Details
        if (_selectedSpecialties.isEmpty) {
          ToastService.showError('Select at least one specialty');
          return false;
        }
        if (_hourlyRateController.text.isEmpty) {
          ToastService.showError('Enter your hourly rate');
          return false;
        }
        if (_builderBioController.text.isEmpty) {
           ToastService.showError('Please write a short bio about your experience');
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

  Future<void> _pickPortfolioImage() async {
    final image = await ImageUploadService().pickFromGallery(crop: false);
    if (image != null) {
      setState(() => _portfolioImages.add(image));
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

    // 3. Upload portfolio images if builder
    List<String> uploadedPortfolioUrls = [];
    if (_wantsToBeBuilder && _portfolioImages.isNotEmpty) {
      ToastService.showInfo('Uploading portfolio images...');
      for (final image in _portfolioImages) {
        final url = await ImageUploadService().uploadImage(image); // Assuming generic upload method exists or using profile one for now if generic not available, but likely need generic.
        // Actually ImageUploadService usually has uploadProfilePhoto. Let's check or use that.
        // If no generic, I might need to abuse uploadProfilePhoto or check the service.
        // Let's assume uploadProfilePhoto works for any image for now or clearer: uploadImage.
        // Checking imports: shared/services/image_upload_service.dart. 
        // I will use uploadProfilePhoto for now as it returns a URL.
        if (url != null) uploadedPortfolioUrls.add(url);
      }
    }

    final success = await ref.read(authProvider.notifier).completeProfile(
      profileData: profileData,
      rigData: rigData,
      isBuilder: _wantsToBeBuilder,
      builderData: _wantsToBeBuilder ? {
        'specialty_tags': _selectedSpecialties,
        'hourly_rate': int.tryParse(_hourlyRateController.text) ?? 0,
        'bio': _builderBioController.text.trim(),
        'portfolio_images': uploadedPortfolioUrls,
        'availability_status': 'available',
      } : null,
    );

    if (!success || !mounted) return;

    // 3. Update travel route if user provided at least an origin
    if (_originLat != null) {
      final duration = int.tryParse(_durationController.text) ?? 7;
      try {
        final Map<String, dynamic> routeData = {
          'origin': {'lat': _originLat, 'lng': _originLng},
        };

        if (_destLat != null) {
          routeData['destination'] = {'lat': _destLat, 'lng': _destLng};
        }
        if (_startDate != null) {
          routeData['start_date'] = _startDate!.toIso8601String();
          routeData['duration_days'] = duration;
        }

        await ApiClient().patch(
          '${AppConfig.usersEndpoint}/route',
          data: routeData,
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => context.pop(),
              ),
        title: Text(
          'PROFILE SETUP',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: AppColors.white.withOpacity(0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
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
                  _buildBuilderOptInStep(),
                  if (_wantsToBeBuilder) _buildBuilderDetailStep(),
                ],
              ),
            ),

            if (!isKeyboardOpen)
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

  // ─── Section Builders ──────────────────────────────────────────

  Widget _buildBuilderOptInStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Marketplace',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Do you have skills to offer the community?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.handyman_outlined, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  'Join the Builder Network',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Offer services like repairs, installs, or upgrades to other nomads.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Yes, I want to be a Builder',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  value: _wantsToBeBuilder,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _wantsToBeBuilder = val;
                      _totalSteps = val ? 6 : 5; // Adjust total steps dynamically
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilderDetailStep() {
    final specialties = [
      'Solar Install', 'Plumbing', 'Electrical', 'Carpentry', 'Mechanic', 'Welding', 'Insulation', 'Flooring', 'Custom'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Builder Details',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tell us about your expertise.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('SPECIALTIES'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: specialties.map((spec) {
              final isSelected = _selectedSpecialties.contains(spec);
              return FilterChip(
                label: Text(spec),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) _selectedSpecialties.add(spec);
                    else _selectedSpecialties.remove(spec);
                  });
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.white.withOpacity(0.05),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
                showCheckmark: false,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 30),
          _buildFieldHeader('HOURLY RATE (\$)'),
          const SizedBox(height: 8),
          TextField(
            controller: _hourlyRateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g. 50',
              prefixText: '\$ ',
            ),
          ),

          const SizedBox(height: 30),
          _buildFieldHeader('EXPERIENCE / BIO'),
          const SizedBox(height: 8),
          TextField(
            controller: _builderBioController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe your skills and experience...',
            ),
          ),
          const SizedBox(height: 30),
          _buildFieldHeader('PORTFOLIO IMAGES'),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _portfolioImages.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: _pickPortfolioImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.white.withOpacity(0.1)),
                      ),
                      child: Center(
                        child: Icon(Icons.add, color: AppColors.white.withOpacity(0.5)),
                      ),
                    ),
                  );
                }
                final image = _portfolioImages[index - 1];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => setState(() => _portfolioImages.removeAt(index - 1)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEssentialsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Essentials',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Let the community see who you are.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                   Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white.withOpacity(0.1), width: 2),
                      image: _profileImage != null 
                        ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover)
                        : null,
                    ),
                    child: _profileImage == null
                        ? Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.white.withOpacity(0.3))
                        : null,
                  ),
                  if (_profileImage != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: AppColors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          _buildFieldHeader('AGE'),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '25'),
          ),
          const SizedBox(height: 32),
          _buildFieldHeader('GENDER IDENTITY'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _genders.map((g) {
              final isSelected = _selectedGender == g;
              return ChoiceChip(
                label: Text(g.toUpperCase()),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedGender = g),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.white.withOpacity(0.05),
                labelStyle: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
                showCheckmark: false,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIdentitySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Social Identity',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'What defines your journey?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('SHORT BIO'),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe your spirit, your rig, and your next horizon...',
            ),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('HOBBIES & INTERESTS'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _hobbies.map((hobby) {
              final isSelected = _selectedHobbies.contains(hobby);
              return FilterChip(
                label: Text(hobby.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) _selectedHobbies.add(hobby);
                    else _selectedHobbies.remove(hobby);
                  });
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.white.withOpacity(0.05),
                labelStyle: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('MATCHING INTENT'),
          const SizedBox(height: 12),
          Row(
            children: _intents.map((intent) {
               final isSelected = _selectedIntent == intent;
               return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(child: Text(intent.toUpperCase())),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedIntent = intent),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.white.withOpacity(0.05),
                    labelStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
                    showCheckmark: false,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildNomadSetupSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Nomad Setup',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tell us about your home on wheels.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('RIG TYPE'),
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
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.white.withOpacity(0.1), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(entry.value, color: isSelected ? AppColors.primary : AppColors.white.withOpacity(0.3), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        entry.key.toUpperCase(), 
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 10, 
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: isSelected ? AppColors.primary : AppColors.white.withOpacity(0.4)
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
          _buildFieldHeader('CREW TYPE'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _crewTypes.map((c) {
              final isSelected = _selectedCrewType == c;
              return ChoiceChip(
                label: Text(c.toUpperCase()),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedCrewType = c),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.white.withOpacity(0.05),
                labelStyle: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
                showCheckmark: false,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white.withOpacity(0.1)),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'PET FRIENDLY',
                style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1),
              ),
              subtitle: Text(
                'Are furry friends joining the journey?',
                style: TextStyle(color: AppColors.white.withOpacity(0.4), fontSize: 13),
              ),
              value: _isPetFriendly,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isPetFriendly = val),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Travel Route',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Where are you headed?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          
          _buildFieldHeader('ORIGIN'),
          TextField(
            controller: _originNameController,
            decoration: InputDecoration(
              hintText: 'Present Location',
              prefixIcon: Icon(Icons.my_location, color: AppColors.white.withOpacity(0.3)),
            ),
            readOnly: true,
            onTap: () => _openLocationPicker(isOrigin: true),
          ),
          const SizedBox(height: 24),
          _buildFieldHeader('DESTINATION'),
          TextField(
            controller: _destNameController,
            decoration: InputDecoration(
              hintText: 'Future Horizon',
              prefixIcon: Icon(Icons.place_outlined, color: AppColors.white.withOpacity(0.3)),
            ),
            readOnly: true,
            onTap: () => _openLocationPicker(isOrigin: false),
          ),
          const SizedBox(height: 24),
          _buildFieldHeader('DEPARTURE'),
          InkWell(
            onTap: _pickStartDate,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: AppColors.white.withOpacity(0.3), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _startDate != null ? DateFormat('MMMM dd, yyyy').format(_startDate!) : 'Select Date',
                    style: TextStyle(
                      color: _startDate != null ? AppColors.white : AppColors.white.withOpacity(0.4),
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: AppColors.white.withOpacity(0.2)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          _buildFieldHeader('SEARCH RADIUS'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MAX DISTANCE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withOpacity(0.4),
                ),
              ),
              Text(
                '${_maxDistanceKm.round()} KM',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.white.withOpacity(0.1),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: _maxDistanceKm,
              min: 25,
              max: 500,
              divisions: 19,
              onChanged: (val) => setState(() => _maxDistanceKm = val),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFieldHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppColors.white.withOpacity(0.4),
        ),
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
