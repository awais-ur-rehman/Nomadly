import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/providers/revenue_cat_provider.dart';

/// Shows an upgrade dialog when users hit their free tier limits.
/// Returns true if user upgraded, false otherwise.
Future<bool> showUpgradeDialog(
  BuildContext context,
  WidgetRef ref, {
  String title = 'Upgrade to Pro',
  String message = 'You\'ve reached your free tier limit. Upgrade to Vantage Pro for unlimited access.',
  String feature = 'job posts',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _UpgradeDialog(
      title: title,
      message: message,
      feature: feature,
    ),
  );

  if (result == true) {
    final revenueCatService = ref.read(revenueCatServiceProvider);
    await revenueCatService.showPaywall();
    // Check if upgrade was successful
    final isPro = await revenueCatService.isPro();
    return isPro;
  }
  return false;
}

class _UpgradeDialog extends StatelessWidget {
  final String title;
  final String message;
  final String feature;

  const _UpgradeDialog({
    required this.title,
    required this.message,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.slate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Benefits
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.obsidian.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildBenefit('Unlimited $feature'),
                  const SizedBox(height: 8),
                  _buildBenefit('Priority in search results'),
                  const SizedBox(height: 8),
                  _buildBenefit('Verified Pro badge'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Upgrade Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.obsidian,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Upgrade to Pro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // View Plans Link
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                context.push('/subscription');
              },
              child: const Text(
                'View all plans',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),

            // Not Now
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Not now',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: AppColors.primary,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

/// A banner widget to show upgrade prompts inline
class UpgradeBanner extends ConsumerWidget {
  final String message;
  final VoidCallback? onUpgrade;

  const UpgradeBanner({
    super.key,
    this.message = 'Upgrade to Pro for unlimited access',
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.accent.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vantage Pro',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUpgrade ?? () => context.push('/subscription'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.obsidian,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
