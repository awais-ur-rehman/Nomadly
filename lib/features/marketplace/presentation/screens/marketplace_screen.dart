import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/marketplace_provider.dart';
import '../widgets/builder_card.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nomad Marketplace'),
          bottom: const TabBar(
            tabs: [
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
        floatingActionButton: _buildFab(context, ref),
      ),
    );
  }

  Widget _buildFab(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.push('/marketplace/create-job');
      },
      label: const Text('Post a Need'),
      icon: const Icon(Icons.add),
    );
  }
}

class _TalentTab extends ConsumerWidget {
  const _TalentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: TextField(
            onChanged: (val) => ref.read(marketplaceProvider.notifier).updateSearch(val),
            decoration: InputDecoration(
              hintText: 'Search van builders, solar specialists...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: AppColors.greyExtraLight,
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
                  label: Text(s.toUpperCase()),
                  selected: isSelected,
                  onSelected: (_) => ref.read(marketplaceProvider.notifier).toggleSpecialty(s),
                  selectedColor: AppColors.primaryExtraLight,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Builder List
        Expanded(
          child: state.isLoading && state.builders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.builders.isEmpty
                  ? Center(child: Text("No builders found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      itemCount: state.builders.length,
                      itemBuilder: (context, index) {
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
    );
  }
}

class _JobBoardTab extends ConsumerStatefulWidget {
  const _JobBoardTab();

  @override
  ConsumerState<_JobBoardTab> createState() => _JobBoardTabState();
}

class _JobBoardTabState extends ConsumerState<_JobBoardTab> {
  @override
  void initState() {
    super.initState();
    // Fetch jobs on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketplaceProvider.notifier).fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);

    if (state.isLoading && state.jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "No active jobs found.",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Link to create job
            TextButton(
              onPressed: () => context.push('/marketplace/create-job'),
              child: const Text("Post a Need"),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: state.jobs.length,
      itemBuilder: (context, index) {
        final job = state.jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(job.author.profile?.photoUrl ?? 'https://via.placeholder.com/150'),
            ),
            title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${job.category} • ${job.author.username ?? 'Unknown'}"),
                if (job.isRemote)
                  const Text("Remote", style: TextStyle(color: Colors.green, fontSize: 12))
                else if (job.location.type == 'Point') // Simple check
                  Text("Nearby", style: TextStyle(color: Colors.blue, fontSize: 12)),
              ],
            ),
            trailing: Text(
              "${job.budgetType == 'fixed' ? '\$' : ''}${job.budget}${job.budgetType == 'hourly' ? '/hr' : ''}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            onTap: () {
              context.push('/job/${job.id}', extra: job);
            },
          ),
        );
      },
    );
  }
}
