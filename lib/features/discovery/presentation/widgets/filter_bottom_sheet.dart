import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String _selectedIntent = 'all';
  String _selectedRigType = 'all';
  bool _verifiedOnly = false;

  final List<String> _intents = ['all', 'friends', 'dating', 'both'];
  final List<String> _rigTypes = ['all', 'sprinter', 'skoolie', 'suv', 'truck_camper', 'rv', 'car'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Intent
          const Text(
            'Looking for',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: _intents.map((intent) {
                final isSelected = _selectedIntent == intent;
                return ChoiceChip(
                  label: Text(intent == 'all' ? 'All' : intent.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedIntent = intent);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Rig Type
          const Text(
            'Rig Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: _rigTypes.map((type) {
                final isSelected = _selectedRigType == type;
                return ChoiceChip(
                  label: Text(type == 'all' ? 'All' : type.replaceAll('_', ' ').toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedRigType = type);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Verified Only
          SwitchListTile(
            title: const Text('Verified Profiles Only'),
            value: _verifiedOnly,
            onChanged: (val) => setState(() => _verifiedOnly = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Apply Button
          SizedBox(
            height: AppDimensions.buttonHeightL,
            child: ElevatedButton(
              onPressed: () {
                // Apply filters
                final filters = {
                  if (_selectedIntent != 'all') 'intent': _selectedIntent,
                  if (_selectedRigType != 'all') 'rigType': _selectedRigType,
                  if (_verifiedOnly) 'verified': true,
                };
                
                // TODO: Update provider with filters
                // For now just close, assume provider has a method (need to add it)
                // ref.read(discoveryProvider.notifier).updateFilters(filters);
                
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
      ),
    );
  }
}
