import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/providers/revenue_cat_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../marketplace/presentation/screens/my_jobs_screen.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isPro = user?.isPro ?? false;
    final revenueCatService = ref.watch(revenueCatServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        elevation: 0,
        title: const Text(
          'Subscription',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Plan Card
            _CurrentPlanCard(isPro: isPro),
            const SizedBox(height: 24),

            // Plan Comparison
            const Text(
              'Compare Plans',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Free Plan
            _PlanCard(
              title: 'Free',
              price: '\$0',
              period: 'forever',
              features: const [
                'Post up to 3 jobs per week',
                'Browse all talent',
                'Apply to unlimited jobs',
                'Basic profile',
              ],
              isCurrentPlan: !isPro,
              isPro: false,
            ),
            const SizedBox(height: 16),

            // Pro Plan
            _PlanCard(
              title: 'Vantage Pro',
              price: '\$9.99',
              period: '/month',
              features: const [
                'Unlimited job posts',
                'Priority in search results',
                'Verified Pro badge',
                'Advanced analytics',
                'Priority support',
              ],
              isCurrentPlan: isPro,
              isPro: true,
              onUpgrade: isPro
                  ? null
                  : () async {
                      await revenueCatService.showPaywall();
                      // Refresh user data after purchase
                      ref.invalidate(authProvider);
                    },
            ),
            const SizedBox(height: 24),

            // Jobs This Week (for free users)
            if (!isPro) ...[
              const _JobsRemainingCard(),
              const SizedBox(height: 24),
            ],

            // Manage Subscription (for pro users)
            if (isPro) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.slate,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manage Subscription',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your subscription renews on ${_formatDate(user?.subscription?.expiresAt)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // Open app store subscription management
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening subscription settings...'),
                            backgroundColor: AppColors.slate,
                          ),
                        );
                      },
                      child: const Text(
                        'Manage in App Store',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _CurrentPlanCard extends StatelessWidget {
  final bool isPro;

  const _CurrentPlanCard({required this.isPro});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPro
            ? LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPro ? null : AppColors.slate,
        borderRadius: BorderRadius.circular(20),
        border: isPro
            ? null
            : Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPro ? Icons.workspace_premium : Icons.person_outline,
                color: isPro ? AppColors.obsidian : AppColors.textSecondary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Current Plan',
                style: TextStyle(
                  color: isPro ? AppColors.obsidian.withValues(alpha: 0.7) : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isPro ? 'Vantage Pro' : 'Free',
            style: TextStyle(
              color: isPro ? AppColors.obsidian : AppColors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isPro) ...[
            const SizedBox(height: 4),
            Text(
              'Thank you for supporting Nomadly!',
              style: TextStyle(
                color: AppColors.obsidian.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isCurrentPlan;
  final bool isPro;
  final VoidCallback? onUpgrade;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isCurrentPlan,
    required this.isPro,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlan
              ? (isPro ? AppColors.primary : AppColors.accent)
              : AppColors.divider,
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCurrentPlan) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (isPro ? AppColors.primary : AppColors.accent)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'CURRENT',
                        style: TextStyle(
                          color: isPro ? AppColors.primary : AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (isPro)
                Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: isPro ? AppColors.primary : AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  period,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isPro ? AppColors.primary : AppColors.success,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (onUpgrade != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.obsidian,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JobsRemainingCard extends ConsumerWidget {
  const _JobsRemainingCard();

  int _getJobsPostedThisWeek(List<dynamic> jobs) {
    final now = DateTime.now();
    // Get the start of the current week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return jobs.where((job) => job.createdAt.isAfter(weekStart)).length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(myJobsProvider);
    const maxJobs = 3;

    // Calculate jobs posted this week from actual data
    final jobsPostedThisWeek = jobsAsync.when(
      data: (jobs) => _getJobsPostedThisWeek(jobs),
      loading: () => 0,
      error: (_, __) => 0,
    );

    final remaining = maxJobs - jobsPostedThisWeek;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline,
                color: remaining > 0 ? AppColors.accent : AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Jobs This Week',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: jobsPostedThisWeek / maxJobs,
              backgroundColor: AppColors.obsidian,
              valueColor: AlwaysStoppedAnimation(
                remaining > 0 ? AppColors.accent : AppColors.warning,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$jobsPostedThisWeek of $maxJobs jobs posted',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '$remaining remaining',
                style: TextStyle(
                  color: remaining > 0 ? AppColors.accent : AppColors.warning,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (remaining == 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.warning,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Upgrade to Pro for unlimited job posts',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
