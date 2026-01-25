import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/marketplace_provider.dart';
import '../widgets/builder_card.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomad Marketplace'),
      ),
      body: Column(
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
                    ? _buildEmptyState()
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          const Text('No builders found matching your search.'),
        ],
      ),
    );
  }
}
