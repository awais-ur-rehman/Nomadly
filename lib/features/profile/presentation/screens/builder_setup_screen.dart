import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/toast_service.dart';
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

  final List<String> _specialties = [
    'van', 'electrical', 'solar', 'plumbing', 'woodwork', 'consultation', 'mechanic', 'design'
  ];

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _bioController.dispose();
    super.dispose();
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
      await ApiClient().patch(
        '${AppConfig.usersEndpoint}/me',
        data: {
          'is_builder': true,
          'builder_profile': {
            'specialty_tags': _selectedSpecialties,
            'hourly_rate': int.tryParse(_hourlyRateController.text) ?? 0,
            'bio': _bioController.text.trim(),
            'availability_status': 'available',
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Marketplace Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Join the Marketplace',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Offer your specialist skills to other nomads and earn while you travel.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
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
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'About Your Services',
                hintText: 'Describe your experience with van electrical, solar setups, etc...',
                alignLabelWithHint: true,
              ),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveBuilderProfile,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text('Publish Builder Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
