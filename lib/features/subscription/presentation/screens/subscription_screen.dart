import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/providers/revenue_cat_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../marketplace/presentation/screens/my_jobs_screen.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  Package? _selectedPackage;
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final service = ref.read(revenueCatServiceProvider);
    try {
      final offerings = await service.getOfferings();
      if (offerings != null && offerings.current != null) {
        setState(() {
          _packages = offerings.current!.availablePackages;
          // Default to monthly if available, otherwise first available
          if (_packages.isNotEmpty) {
             _selectedPackage = _packages.firstWhere(
              (p) => p.packageType == PackageType.monthly,
              orElse: () => _packages.first,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performPurchase(Package package) async {
    setState(() => _isLoading = true);
    final service = ref.read(revenueCatServiceProvider);
    
    final success = await service.purchasePackage(package);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        // Refresh user data without resetting auth state to avoid router redirect
        await ref.read(authProvider.notifier).refreshUser();
        ref.invalidate(isProProvider); 
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome to Vantage Pro!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        // Try to check if it's because of entitlement issue or actual error
        // Note: For a real app we might want to be more specific, but for debugging this is good.
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Payment successful but validation failed. Check system logs.'),
            backgroundColor: AppColors.warning,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    final service = ref.read(revenueCatServiceProvider);
    
    final success = await service.restorePurchases();
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ref.invalidate(authProvider);
        ref.invalidate(isProProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No active subscriptions found to restore'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final backendIsPro = user?.isPro ?? false;
    
    final revenueCatAsync = ref.watch(isProProvider);
    final localIsPro = revenueCatAsync.value ?? false;
    
    final isPro = backendIsPro || localIsPro;

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
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _restorePurchases,
            child: const Text(
              'Restore',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CurrentPlanCard(isPro: isPro),
                  const SizedBox(height: 24),

                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!isPro && _packages.isNotEmpty) ...[
                    // Plan Selection List
                    ..._packages.map((package) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PlanSelectionCard(
                        package: package,
                        isSelected: _selectedPackage == package,
                        onTap: () => setState(() => _selectedPackage = package),
                      ),
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Upgrade Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedPackage != null 
                            ? () => _performPurchase(_selectedPackage!)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.obsidian,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _selectedPackage != null
                              ? 'Buy Now ${_selectedPackage!.storeProduct.priceString}'
                              : 'Select a Plan',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ] else if (isPro)
                   _PlanCard(
                      title: 'Vantage Pro Active',
                      price: 'Active',
                      period: '',
                      features: const [
                        'Unlimited job posts',
                        'Priority in search results',
                        'Verified Pro badge',
                        'Advanced analytics',
                      ],
                      isCurrentPlan: true,
                      isPro: true,
                    )
                  else
                    // Fallback / Loading Error
                     const Center(
                       child: Text(
                         'No plans available at the moment.',
                         style: TextStyle(color: AppColors.textSecondary),
                       ),
                     ),

                  const SizedBox(height: 24),
                  
                  if (!isPro) ...[
                     const _JobsRemainingCard(),
                     const SizedBox(height: 24),
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

class _PlanSelectionCard extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanSelectionCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final product = package.storeProduct;
    // Simple title cleanup if needed, or use as is
    final title = product.title.replaceAll(RegExp(r'\(.*\)'), '').trim(); 

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: package.identifier,
              groupValue: isSelected ? package.identifier : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
              fillColor: MaterialStateProperty.resolveWith(
                (states) => isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.priceString,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (package.packageType == PackageType.monthly)
                   const Text('/mo', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                if (package.packageType == PackageType.annual)
                   const Text('/yr', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                 if (package.packageType == PackageType.weekly)
                   const Text('/wk', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
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
                  AppColors.primary.withOpacity(0.7),
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
                  color: isPro ? AppColors.obsidian.withOpacity(0.7) : AppColors.textSecondary,
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
                color: AppColors.obsidian.withOpacity(0.7),
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
                            .withOpacity(0.15),
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
                const Icon(
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
