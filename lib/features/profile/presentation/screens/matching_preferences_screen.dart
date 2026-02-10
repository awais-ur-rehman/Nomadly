import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/models/user.dart';
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
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Matching Preferences',
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
              onPressed: _isLoading ? null : _save,
              child: _isLoading
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Visibility toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.slate,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discovery',
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Show me to other nomads',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isDiscoverable,
                  onChanged: (val) => setState(() => _isDiscoverable = val),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return Colors.white.withValues(alpha: 0.5);
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary.withValues(alpha: 0.3);
                    }
                    return Colors.white.withValues(alpha: 0.1);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Intent section
          _buildSectionTitle('I want to find...'),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildIntentChip('friends', 'Friends', Icons.people),
              const SizedBox(width: 8),
              _buildIntentChip('dating', 'Dating', Icons.favorite),
              const SizedBox(width: 8),
              _buildIntentChip('both', 'Both', Icons.all_inclusive),
            ],
          ),
          const SizedBox(height: 28),

          // Distance section
          _buildSectionTitle('Maximum Distance'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_distance.round()} km',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
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
              value: _distance,
              min: 10,
              max: 500,
              divisions: 49,
              label: '${_distance.round()} km',
              onChanged: (val) => setState(() => _distance = val),
            ),
          ),
          const SizedBox(height: 20),

          // Age Range section
          _buildSectionTitle('Age Range'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
              valueIndicatorColor: AppColors.primary,
              valueIndicatorTextStyle: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
            ),
            child: RangeSlider(
              values: _ageRange,
              min: 18,
              max: 100,
              divisions: 82,
              labels: RangeLabels('${_ageRange.start.round()}', '${_ageRange.end.round()}'),
              onChanged: (val) => setState(() => _ageRange = val),
            ),
          ),
          const SizedBox(height: 28),

          // Gender Interest section
          _buildSectionTitle('Show me'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['male', 'female', 'non-binary', 'other'].map((gender) {
              final isSelected = _selectedGenders.contains(gender);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGenders.remove(gender);
                    } else {
                      _selectedGenders.add(gender);
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
                    gender[0].toUpperCase() + gender.substring(1),
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.white,
        fontFamily: 'Outfit',
      ),
    );
  }

  Widget _buildIntentChip(String value, String label, IconData icon) {
    final isSelected = _intent == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _intent = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.slate,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.6),
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
                  fontFamily: 'Inter',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
