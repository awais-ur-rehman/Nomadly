import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../features/profile/presentation/widgets/verification_badge.dart';

class ProfileBioSection extends StatelessWidget {
  final String? name;
  final String? username;
  final String? bio;
  final int verificationLevel;
  final bool isPrivate;

  const ProfileBioSection({
    super.key,
    this.name,
    this.username,
    this.bio,
    this.verificationLevel = 0,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + verification badge
        Row(
          children: [
            Text(
              name ?? 'User',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (verificationLevel > 0) ...[
              const SizedBox(width: 6),
              VerificationBadge(level: verificationLevel),
            ],
            if (isPrivate) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.lock,
                color: AppColors.grey,
                size: 16,
              ),
            ],
          ],
        ),

        // Username
        if (username != null)
          Text(
            '@$username',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

        // Bio
        if (bio != null && bio!.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            bio!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
