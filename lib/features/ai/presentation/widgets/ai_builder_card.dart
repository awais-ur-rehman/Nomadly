import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AiBuilderCard extends StatelessWidget {
  final String id;
  final String name;
  final double rating;
  final List<String> specialties;
  final String? imageUrl;
  final VoidCallback onTap;

  const AiBuilderCard({
    super.key,
    required this.id,
    required this.name,
    this.rating = 0.0,
    this.specialties = const [],
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.obsidian),
                    errorWidget: (_, __, ___) => const Icon(Icons.build, color: AppColors.textSecondary),
                  )
                : Container(color: AppColors.obsidian, child: const Icon(Icons.build, color: AppColors.textSecondary)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: specialties.take(2).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(s, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
