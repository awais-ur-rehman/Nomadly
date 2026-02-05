import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/matching_profile.dart'; // Import created model
import '../../../../core/config/app_config.dart';
import '../../../auth/providers/auth_provider.dart';

class MatchingPreferencesScreen extends ConsumerStatefulWidget {
  const MatchingPreferencesScreen({super.key});

  @override
  ConsumerState<MatchingPreferencesScreen> createState() => _MatchingPreferencesScreenState();
}

class _MatchingPreferencesScreenState extends ConsumerState<MatchingPreferencesScreen> {
  bool _isLoading = false;
  bool _isDiscoverable = true;
  RangeValues _ageRange = const RangeValues(18, 50);
  double _distance = 50;
  List<String> _selectedGenders = [];
  String _intent = 'friends';

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user?.matchingProfile != null) {
      final p = user!.matchingProfile!;
      _isDiscoverable = p.isDiscoverable;
      _intent = p.intent;
      _distance = p.preferences.maxDistanceKm.toDouble().clamp(10, 500);
      double minAge = p.preferences.minAge.toDouble().clamp(18, 100);
      double maxAge = p.preferences.maxAge.toDouble().clamp(18, 100);
      if (minAge > maxAge) minAge = maxAge;
      _ageRange = RangeValues(minAge, maxAge);
      _selectedGenders = List.from(p.preferences.genderInterest);
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final data = {
        'matching_profile': {
          'is_discoverable': _isDiscoverable,
          'intent': _intent,
          'preferences': {
            'min_age': _ageRange.start.round(),
            'max_age': _ageRange.end.round(),
            'max_distance_km': _distance.round(),
            'gender_interest': _selectedGenders,
          }
        }
      };

      final response = await ApiClient().patch('${AppConfig.usersEndpoint}/me', data: data);
      
      // Update local user state
      if (response != null) {
        final updatedUser = User.fromJson(response.data);
        ref.read(authProvider.notifier).updateUser(updatedUser);
        ToastService.showSuccess('Preferences saved');
        if (mounted) context.pop();
      }
    } catch (e) {
      ToastService.showError('Failed to save preferences');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Preferences'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) 
              : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          // Visibility
          SwitchListTile(
            title: const Text('Discovery'),
            subtitle: const Text('Show me to other nomads'),
            value: _isDiscoverable,
            onChanged: (val) => setState(() => _isDiscoverable = val),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Intent
          const Text('I want to find...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'friends', label: Text('Friends'), icon: Icon(Icons.people)),
              ButtonSegment(value: 'dating', label: Text('Dating'), icon: Icon(Icons.favorite)),
              ButtonSegment(value: 'both', label: Text('Both')),
            ],
            selected: {_intent},
            onSelectionChanged: (val) {
              setState(() => _intent = val.first);
            },
          ),
          
          const SizedBox(height: 24),

          // Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Maximum Distance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${_distance.round()} km', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _distance,
            min: 10,
            max: 500,
            divisions: 49,
            label: '${_distance.round()} km',
            onChanged: (val) => setState(() => _distance = val),
          ),
          
          const SizedBox(height: 16),

          // Age Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Age Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${_ageRange.start.round()} - ${_ageRange.end.round()}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 100,
            divisions: 82, // 100-18
            labels: RangeLabels('${_ageRange.start.round()}', '${_ageRange.end.round()}'),
            onChanged: (val) => setState(() => _ageRange = val),
          ),

          const SizedBox(height: 24),

          // Gender Interest
          const Text('Show me', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['male', 'female', 'non-binary', 'other'].map((gender) {
              final isSelected = _selectedGenders.contains(gender);
              return FilterChip(
                label: Text(gender[0].toUpperCase() + gender.substring(1)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedGenders.add(gender);
                    } else {
                      _selectedGenders.remove(gender);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
