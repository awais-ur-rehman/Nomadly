import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/features/marketplace/providers/marketplace_provider.dart';
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

  final List<String> _categories = [
    'mechanical', 'electrical', 'solar', 'plumbing', 'woodwork', 'general', 'cleaning', 'remote_work'
  ];

  @override
  void initState() {
    super.initState();
    _checkProStatus();
  }

  Future<void> _checkProStatus() async {
    // Proactive check: If user isn't pro, they might need to see the paywall
    // This is a "Soft check" to guide the user before they fill a whole form
    final isPro = await ref.read(revenueCatServiceProvider).isPro();
    if (!isPro) {
      // We could show a banner or snackbar here instead of a hard blocking paywall
      // to allow them to fill the form but know they'll need to upgrade.
      // For now, let's just log or show a minor hint.
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Get current location or allow user to pick
      // For MVP, use hardcoded or current user location if available in provider
      // Simulating location for now
      final jobData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'budget': double.parse(_budgetController.text),
        'budget_type': _budgetType,
        'is_remote': _isRemote,
        'location': {
          'lat': 40.7128, // Mock NY
          'lng': -74.0060,
        }
      };

      try {
        await ref.read(marketplaceProvider.notifier).createJob(jobData);
        if (mounted) context.pop();
      } catch (e) {
        // Check for 403 or specific message
        if (e.toString().contains("Upgrade to Pro") || e.toString().contains("403")) {
          // Show Paywall
          await ref.read(revenueCatServiceProvider).showPaywallIfNeeded();
        }
        // Provider already shows error toast
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Need'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Job Title', hintText: 'e.g. Solar Panel Installation Help'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 5) return 'Min 5 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(labelText: 'Budget', prefixText: '\$'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Invalid amount';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _budgetType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: const [
                      DropdownMenuItem(value: 'fixed', child: Text('Fixed Price')),
                      DropdownMenuItem(value: 'hourly', child: Text('Hourly Rate')),
                    ],
                    onChanged: (v) => setState(() => _budgetType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Remote Work?'),
              value: _isRemote,
              onChanged: (v) => setState(() => _isRemote = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
              maxLines: 5,
              validator: (v) => v == null || v.length < 20 ? 'Min 20 chars' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }
}
