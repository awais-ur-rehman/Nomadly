import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/matching_provider.dart';

class DistanceFilterSheet extends ConsumerWidget {
  const DistanceFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exploration Zone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'How far are you willing to travel?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildZoneOption(
            context,
            ref,
            title: 'Town',
            distance: 50,
            icon: Icons.home_work_outlined,
            subtitle: 'Local vibes (~50km)',
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
                    
          _buildZoneOption(
            context,
            ref,
            title: 'Region',
            distance: 100,
            icon: Icons.location_city_outlined,
            subtitle: 'Day trip (~100km)',
            color: AppColors.info,
          ),
          const SizedBox(height: 12),

          _buildZoneOption(
            context,
            ref,
            title: 'State',
            distance: 500,
            icon: Icons.map_outlined,
            subtitle: 'Weekend getaway (~500km)',
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),

          _buildZoneOption(
            context,
            ref,
            title: 'Global',
            distance: 10000,
            icon: Icons.public,
            subtitle: 'Nomad everywhere',
            color: AppColors.secondary,
            isLast: true,
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildZoneOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required int distance,
    required IconData icon,
    required String subtitle,
    required Color color,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () async {
        // Set distance and close
        context.pop(); // Close first to feel responsive
        await ref.read(matchingProvider.notifier).updateDistance(distance);
        
        // Optional: Show toast or indicator
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Switched to $title Zone ($distance km)'),
               behavior: SnackBarBehavior.floating,
               backgroundColor: AppColors.secondary,
               duration: const Duration(seconds: 2),
             ),
           );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
