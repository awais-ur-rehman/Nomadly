import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../providers/marketplace_provider.dart';
import '../widgets/builder_card.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.obsidian,
        appBar: AppBar(
          backgroundColor: AppColors.obsidian,
          elevation: 0,
          title: const Text(
            'Nomad Marketplace',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.white),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Find Talent'),
              Tab(text: 'Job Board'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TalentTab(),
            _JobBoardTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/marketplace/create-job'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.obsidian,
          label: const Text(
            'Post a Need',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TalentTab extends ConsumerStatefulWidget {
  const _TalentTab();

  @override
  ConsumerState<_TalentTab> createState() => _TalentTabState();
}

class _TalentTabState extends ConsumerState<_TalentTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(marketplaceProvider.notifier).loadMoreBuilders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(marketplaceProvider.notifier).searchBuilders(refresh: true),
      color: AppColors.primary,
      backgroundColor: AppColors.slate,
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: TextField(
              onChanged: (val) => ref.read(marketplaceProvider.notifier).updateSearch(val),
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search van builders, solar specialists...',
                hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: AppColors.white.withValues(alpha: 0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.slate),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.slate),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.slate,
              ),
            ),
          ),
          // Specialties Filter
          SizedBox(
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                'van', 'electrical', 'solar', 'plumbing', 'woodwork', 'consultation'
              ].map((s) {
                final isSelected = state.selectedSpecialties.contains(s);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      s.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? AppColors.obsidian : AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => ref.read(marketplaceProvider.notifier).toggleSpecialty(s),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.slate,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.slate,
                    ),
                    checkmarkColor: AppColors.obsidian,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Builder List
          Expanded(
            child: state.error != null && state.builders.isEmpty
                ? _buildErrorState(
                    message: 'Failed to load builders',
                    onRetry: () => ref.read(marketplaceProvider.notifier).searchBuilders(refresh: true),
                  )
                : state.isLoading && state.builders.isEmpty
                    ? const BuilderListSkeleton()
                    : state.builders.isEmpty
                        ? _buildEmptyState(
                            icon: Icons.people_outline,
                            message: 'No builders found',
                            subMessage: 'Try adjusting your filters',
                          )
                        : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppDimensions.paddingM),
                        itemCount: state.builders.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.builders.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            );
                          }
                          final builder = state.builders[index];
                          return BuilderCard(
                            builder: builder,
                            onTap: () {
                              context.push('/builder/${builder.id}', extra: builder);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subMessage,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.slate,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              subMessage,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.slate,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.obsidian,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class _JobBoardTab extends ConsumerStatefulWidget {
  const _JobBoardTab();

  @override
  ConsumerState<_JobBoardTab> createState() => _JobBoardTabState();
}

class _JobBoardTabState extends ConsumerState<_JobBoardTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketplaceProvider.notifier).fetchJobs();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(marketplaceProvider.notifier).loadMoreJobs();
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electrical':
      case 'solar':
        return '⚡';
      case 'mechanical':
      case 'diesel':
        return '🔧';
      case 'plumbing':
        return '🔧';
      case 'woodwork':
        return '🪵';
      case 'general':
        return '🛠️';
      case 'cleaning':
        return '🧹';
      case 'remote_work':
        return '💻';
      default:
        return '💼';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    // Error state
    if (state.error != null && state.jobs.isEmpty) {
      return _buildErrorState(
        message: 'Failed to load jobs',
        onRetry: () => ref.read(marketplaceProvider.notifier).fetchJobs(refresh: true),
      );
    }

    if (state.isLoading && state.jobs.isEmpty) {
      return const JobListSkeleton();
    }

    if (state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.slate,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.work_outline,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No active jobs found',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to post a need!',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/marketplace/create-job'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.obsidian,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Post a Need',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(marketplaceProvider.notifier).fetchJobs(refresh: true),
      color: AppColors.primary,
      backgroundColor: AppColors.slate,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: state.jobs.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.jobs.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          final job = state.jobs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.slate,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/job/${job.id}', extra: job),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _getCategoryIcon(job.category),
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  job.category.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  ' • ',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                Expanded(
                                  child: Text(
                                    job.author.username ?? 'Unknown',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // Budget badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '\$${job.budget.toStringAsFixed(0)}${job.budgetType == 'hourly' ? '/hr' : ''}',
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Location badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: job.isRemote
                                        ? AppColors.accent.withValues(alpha: 0.15)
                                        : AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        job.isRemote ? Icons.public : Icons.location_on,
                                        size: 12,
                                        color: job.isRemote ? AppColors.accent : AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        job.isRemote ? 'Remote' : 'On-site',
                                        style: TextStyle(
                                          color: job.isRemote ? AppColors.accent : AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Arrow indicator
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.slate,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.obsidian,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
