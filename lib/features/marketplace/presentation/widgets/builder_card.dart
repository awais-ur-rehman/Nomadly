import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/builder.dart';

class BuilderCard extends StatelessWidget {
  final BuilderProfile builder;
  final VoidCallback onTap;

  const BuilderCard({
    super.key,
    required this.builder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image / Portfolio
            SizedBox(
              height: 150,
              width: double.infinity,
              child: builder.portfolioImageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: builder.portfolioImageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.primaryExtraLight,
                      child: const Icon(Icons.build, size: 50, color: AppColors.primary),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          builder.businessName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (builder.isVerified)
                        const Icon(Icons.verified, color: AppColors.primary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${builder.rating} (${builder.reviewCount} reviews)',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Specialties
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: builder.specialty.map((s) => Chip(
                      label: Text(s.toUpperCase(), style: const TextStyle(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    builder.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  if (builder.locationBase != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Text(builder.locationBase!, style: const TextStyle(fontSize: 12)),
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
