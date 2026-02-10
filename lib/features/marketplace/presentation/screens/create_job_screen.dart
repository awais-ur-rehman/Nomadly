import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/features/marketplace/providers/marketplace_provider.dart';
import 'package:nomadly/features/subscription/presentation/widgets/upgrade_dialog.dart';
import 'package:nomadly/shared/providers/revenue_cat_provider.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  String _selectedCategory = 'mechanical';
  String _budgetType = 'fixed';
  bool _isRemote = false;
  bool _isLoading = false;

  // Location state
  double? _latitude;
  double? _longitude;
  String? _locationName;

  final List<Map<String, dynamic>> _categories = [
    {'value': 'mechanical', 'label': 'Mechanical', 'icon': '🔧'},
    {'value': 'electrical', 'label': 'Electrical', 'icon': '⚡'},
    {'value': 'solar', 'label': 'Solar', 'icon': '☀️'},
    {'value': 'plumbing', 'label': 'Plumbing', 'icon': '🔧'},
    {'value': 'woodwork', 'label': 'Woodwork', 'icon': '🪵'},
    {'value': 'general', 'label': 'General', 'icon': '🛠️'},
    {'value': 'cleaning', 'label': 'Cleaning', 'icon': '🧹'},
    {'value': 'remote_work', 'label': 'Remote Work', 'icon': '💻'},
  ];

  @override
  void initState() {
    super.initState();
    _checkProStatus();
  }

  Future<void> _checkProStatus() async {
    final isPro = await ref.read(revenueCatServiceProvider).isPro();
    if (!isPro && mounted) {
      // Show a subtle hint that they have limited posts on free tier
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await context.push<Map<String, dynamic>>('/location-picker');
    if (result != null && mounted) {
      setState(() {
        _latitude = result['lat'] as double?;
        _longitude = result['lng'] as double?;
        _locationName = result['name'] as String? ?? 'Selected Location';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final jobData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'budget': double.parse(_budgetController.text),
        'budget_type': _budgetType,
        'is_remote': _isRemote,
        'location': {
          'lat': _latitude ?? 40.7128,
          'lng': _longitude ?? -74.0060,
        }
      };

      await ref.read(marketplaceProvider.notifier).createJob(jobData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job posted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('limit') || errorMsg.contains('Upgrade') || errorMsg.contains('403')) {
        // Show upgrade dialog for limit errors
        if (mounted) {
          final upgraded = await showUpgradeDialog(
            context,
            ref,
            title: 'Weekly Limit Reached',
            message: 'You\'ve used all 3 free job posts this week. Upgrade to Vantage Pro for unlimited posting.',
            feature: 'job posts',
          );
          if (upgraded) {
            // Retry after successful upgrade
            _submit();
          }
        }
      } else {
        // Show generic error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to post job: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    String? prefixText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      alignLabelWithHint: alignLabelWithHint,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7)),
      prefixStyle: const TextStyle(color: AppColors.white),
      filled: true,
      fillColor: AppColors.slate,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'Post a Need',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.white),
              decoration: _buildInputDecoration(
                label: 'Job Title',
                hint: 'e.g. Solar Panel Installation Help',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 5) return 'Min 5 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Category
            Text(
              'Category',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat['value'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['value']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.slate,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat['icon'], style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(
                          cat['label'],
                          style: TextStyle(
                            color: isSelected ? AppColors.obsidian : AppColors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Budget Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _budgetController,
                    style: const TextStyle(color: AppColors.white),
                    decoration: _buildInputDecoration(
                      label: 'Budget',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _budgetType, // Using value for controlled state
                    style: const TextStyle(color: AppColors.white),
                    dropdownColor: AppColors.slate,
                    decoration: _buildInputDecoration(label: 'Type'),
                    items: const [
                      DropdownMenuItem(value: 'fixed', child: Text('Fixed Price')),
                      DropdownMenuItem(value: 'hourly', child: Text('Hourly Rate')),
                    ],
                    onChanged: (v) => setState(() => _budgetType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location
            Text(
              'Location',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _isRemote ? null : _pickLocation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.slate,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(
                      _locationName != null ? Icons.location_on : Icons.add_location_alt,
                      color: _isRemote ? AppColors.textSecondary : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isRemote
                            ? 'Remote - No location needed'
                            : _locationName ?? 'Tap to select location',
                        style: TextStyle(
                          color: _isRemote
                              ? AppColors.textSecondary
                              : (_locationName != null ? AppColors.white : AppColors.textSecondary),
                        ),
                      ),
                    ),
                    if (!_isRemote)
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Remote Toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.slate,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Remote Work',
                  style: TextStyle(color: AppColors.white),
                ),
                subtitle: Text(
                  'Can be done from anywhere',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                value: _isRemote,
                onChanged: (v) => setState(() => _isRemote = v),
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                thumbColor: WidgetStatePropertyAll(AppColors.primary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: AppColors.white),
              decoration: _buildInputDecoration(
                label: 'Description',
                hint: 'Describe what you need help with...',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (v) => v == null || v.length < 20 ? 'Min 20 characters' : null,
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.obsidian,
                disabledBackgroundColor: AppColors.slate,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.obsidian),
                      ),
                    )
                  : const Text(
                      'Post Job',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
