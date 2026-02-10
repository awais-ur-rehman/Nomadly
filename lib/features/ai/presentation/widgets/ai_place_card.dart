import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AiPlaceCard extends StatelessWidget {
  final String id;
  final String name;
  final double rating;
  final String description;
  final VoidCallback onTap;

  const AiPlaceCard({
    super.key,
    required this.id,
    required this.name,
    this.rating = 0.0,
    this.description = '',
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (rating > 0)
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
