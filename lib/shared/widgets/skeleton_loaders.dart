import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Base shimmer wrapper for skeleton loading effects
class SkeletonShimmer extends StatelessWidget {
  final Widget child;

  const SkeletonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.slate,
      highlightColor: AppColors.slate.withValues(alpha: 0.5),
      child: child,
    );
  }
}

/// Skeleton box placeholder
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton circle placeholder
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.slate,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton for job card
class JobCardSkeleton extends StatelessWidget {
  const JobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 48, height: 48, borderRadius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 180, height: 18),
                  const SizedBox(height: 8),
                  const SkeletonBox(width: 120, height: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SkeletonBox(width: 60, height: 24, borderRadius: 6),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 80, height: 24, borderRadius: 6),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for builder card
class BuilderCardSkeleton extends StatelessWidget {
  const BuilderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SkeletonCircle(size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 140, height: 18),
                  const SizedBox(height: 6),
                  const SkeletonBox(width: 100, height: 14),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SkeletonBox(width: 50, height: 20, borderRadius: 10),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 50, height: 20, borderRadius: 10),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 50, height: 20, borderRadius: 10),
                    ],
                  ),
                ],
              ),
            ),
            const SkeletonBox(width: 60, height: 28, borderRadius: 6),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for application card
class ApplicationCardSkeleton extends StatelessWidget {
  const ApplicationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(width: 48, height: 48, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonBox(width: 160, height: 16),
                      const SizedBox(height: 6),
                      const SkeletonBox(width: 100, height: 12),
                    ],
                  ),
                ),
                const SkeletonBox(width: 70, height: 26, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.obsidian.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 80, height: 10),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 12),
                  const SizedBox(height: 4),
                  const SkeletonBox(width: 200, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton list builder
class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsets? padding;

  const SkeletonListView({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

/// Job list skeleton
class JobListSkeleton extends StatelessWidget {
  final int itemCount;

  const JobListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: itemCount,
      itemBuilder: (context, index) => const JobCardSkeleton(),
    );
  }
}

/// Builder list skeleton
class BuilderListSkeleton extends StatelessWidget {
  final int itemCount;

  const BuilderListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: itemCount,
      itemBuilder: (context, index) => const BuilderCardSkeleton(),
    );
  }
}

/// Application list skeleton
class ApplicationListSkeleton extends StatelessWidget {
  final int itemCount;

  const ApplicationListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: itemCount,
      itemBuilder: (context, index) => const ApplicationCardSkeleton(),
    );
  }
}

/// Skeleton for consultation card
class ConsultationCardSkeleton extends StatelessWidget {
  const ConsultationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(width: 48, height: 48, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonBox(width: 140, height: 16),
                      const SizedBox(height: 6),
                      const SkeletonBox(width: 80, height: 12),
                    ],
                  ),
                ),
                const SkeletonBox(width: 70, height: 26, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SkeletonBox(width: 120, height: 14),
                const Spacer(),
                const SkeletonBox(width: 50, height: 18, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Consultation list skeleton
class ConsultationListSkeleton extends StatelessWidget {
  final int itemCount;

  const ConsultationListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: itemCount,
      itemBuilder: (context, index) => const ConsultationCardSkeleton(),
    );
  }
}

/// Skeleton for my job card (with action buttons)
class MyJobCardSkeleton extends StatelessWidget {
  const MyJobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 48, height: 48, borderRadius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: SkeletonBox(height: 18)),
                            const SizedBox(width: 8),
                            const SkeletonBox(width: 50, height: 20, borderRadius: 6),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const SkeletonBox(width: 140, height: 12),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SkeletonBox(width: 100, height: 24, borderRadius: 6),
                            const SizedBox(width: 8),
                            const SkeletonBox(width: 70, height: 24, borderRadius: 6),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const SkeletonBox(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.obsidian.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Expanded(child: SkeletonBox(height: 40, borderRadius: 8)),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 40, height: 40, borderRadius: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// My job list skeleton
class MyJobListSkeleton extends StatelessWidget {
  final int itemCount;

  const MyJobListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: itemCount,
      itemBuilder: (context, index) => const MyJobCardSkeleton(),
    );
  }
}

/// Skeleton for trip card
class TripCardSkeleton extends StatelessWidget {
  const TripCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route header (origin -> destination)
            Row(
              children: [
                const SkeletonCircle(size: 24),
                const SizedBox(width: 8),
                const SkeletonBox(width: 100, height: 14),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, color: Colors.transparent, size: 16),
                const SizedBox(width: 12),
                const SkeletonCircle(size: 24),
                const SizedBox(width: 8),
                const Expanded(child: SkeletonBox(height: 14)),
              ],
            ),
            const SizedBox(height: 20),
            // Date info
            Row(
              children: [
                const SkeletonBox(width: 20, height: 20, borderRadius: 4),
                const SizedBox(width: 8),
                const SkeletonBox(width: 150, height: 14),
              ],
            ),
            const SizedBox(height: 12),
            // Status
            Row(
              children: [
                const SkeletonBox(width: 20, height: 20, borderRadius: 4),
                const SizedBox(width: 8),
                const SkeletonBox(width: 80, height: 14),
              ],
            ),
            const SizedBox(height: 20),
            // Action buttons
            Row(
              children: [
                const Expanded(child: SkeletonBox(height: 44, borderRadius: 12)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonBox(height: 44, borderRadius: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
