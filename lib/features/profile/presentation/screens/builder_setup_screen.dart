import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../core/config/app_config.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';

class BuilderSetupScreen extends ConsumerStatefulWidget {
  const BuilderSetupScreen({super.key});

  @override
  ConsumerState<BuilderSetupScreen> createState() => _BuilderSetupScreenState();
}

class _BuilderSetupScreenState extends ConsumerState<BuilderSetupScreen> {
  final List<String> _selectedSpecialties = [];
  final _hourlyRateController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  // Portfolio images
  final List<File> _portfolioFiles = [];
  final List<String> _portfolioUrls = [];
  bool _isUploadingImage = false;
  static const int _maxPortfolioImages = 6;

  final List<String> _specialties = [
    'van', 'electrical', 'solar', 'plumbing', 'woodwork', 'consultation', 'mechanic', 'design'
  ];

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _addPortfolioImage() async {
    if (_portfolioFiles.length >= _maxPortfolioImages) {
      ToastService.showError('Maximum $_maxPortfolioImages images allowed');
      return;
    }

    final imageService = ImageUploadService();
    final file = await imageService.pickFromGallery(crop: false);

    if (file != null && mounted) {
      setState(() {
        _portfolioFiles.add(file);
      });
    }
  }

  void _removePortfolioImage(int index) {
    setState(() {
      _portfolioFiles.removeAt(index);
      if (index < _portfolioUrls.length) {
        _portfolioUrls.removeAt(index);
      }
    });
  }

  Future<List<String>> _uploadPortfolioImages() async {
    final imageService = ImageUploadService();
    final urls = <String>[];

    for (final file in _portfolioFiles) {
      final url = await imageService.uploadImage(file, type: 'portfolio');
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  Future<void> _saveBuilderProfile() async {
    if (_selectedSpecialties.isEmpty) {
      ToastService.showError('Please select at least one specialty');
      return;
    }
    if (_hourlyRateController.text.isEmpty) {
      ToastService.showError('Please enter your hourly rate');
      return;
    }
    if (_bioController.text.isEmpty) {
      ToastService.showError('Please describe your services');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload portfolio images first
      List<String> portfolioUrls = [];
      if (_portfolioFiles.isNotEmpty) {
        ToastService.showInfo('Uploading portfolio images...');
        portfolioUrls = await _uploadPortfolioImages();
      }

      await ApiClient().patch(
        '${AppConfig.usersEndpoint}/me',
        data: {
          'is_builder': true,
          'builder_profile': {
            'specialty_tags': _selectedSpecialties,
            'hourly_rate': int.tryParse(_hourlyRateController.text) ?? 0,
            'bio': _bioController.text.trim(),
            'availability_status': 'available',
            if (portfolioUrls.isNotEmpty) 'portfolio_images': portfolioUrls,
          },
        },
      );

      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        ToastService.showSuccess('Builder profile set up successfully!');
        context.pop();
      }
    } catch (e) {
      ToastService.showError('Failed to set up builder profile');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'MARKETPLACE',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Join the Convoy',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Offer your specialist skills to other nomads and earn while you travel.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50),
            
            _buildFieldHeader('YOUR SPECIALTIES'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
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
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  labelStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.white : Colors.white.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 40),
            _buildFieldHeader('HOURLY RATE'),
            TextField(
              controller: _hourlyRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '50',
                suffixText: 'USD / HR',
                prefixIcon: Icon(Icons.attach_money_outlined, size: 20),
              ),
            ),
            
            const SizedBox(height: 32),
            _buildFieldHeader('SERVICES BIO'),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe your experience with van electrical, solar setups, etc...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 40),
            _buildFieldHeader('PORTFOLIO IMAGES'),
            const SizedBox(height: 8),
            Text(
              'Showcase your best work (up to $_maxPortfolioImages images)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildPortfolioGrid(),

            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveBuilderProfile,
                child: _isLoading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                  : const Text('PUBLISH BUILDER IDENTITY', style: TextStyle(letterSpacing: 2)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
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
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildPortfolioGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: _portfolioFiles.length + (_portfolioFiles.length < _maxPortfolioImages ? 1 : 0),
      itemBuilder: (context, index) {
        // Add button
        if (index == _portfolioFiles.length) {
          return _buildAddImageButton();
        }

        // Image tile
        return _buildPortfolioTile(index);
      },
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _isUploadingImage ? null : _addPortfolioImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: _isUploadingImage
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ADD',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPortfolioTile(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_portfolioFiles[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePortfolioImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
