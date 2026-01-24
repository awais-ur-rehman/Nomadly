import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/match.dart';

class UserCard extends StatelessWidget {
  final DiscoveryUser discoveryUser;

  const UserCard({
    super.key,
    required this.discoveryUser,
  });

  @override
  Widget build(BuildContext context) {
    final user = discoveryUser.user;
    final profile = user.profile;
    final rig = user.rig;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo
          if (profile.photoUrl != null)
            CachedNetworkImage(
              imageUrl: profile.photoUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.greyExtraLight,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.greyExtraLight,
                child: const Icon(Icons.person, size: 50, color: AppColors.grey),
              ),
            )
          else
            Container(
              color: AppColors.greyExtraLight,
              child: const Icon(Icons.person, size: 80, color: AppColors.grey),
            ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.6, 0.8, 1.0],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Age
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${profile.age}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (user.nomadId?.verified == true) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Icon(
                          Icons.verified,
                          color: AppColors.primaryLight,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),
                
                // Rig Info
                if (rig != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car, // Replace with custom rig icon
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${rig.type.toUpperCase()} • ${rig.crewType.toUpperCase()}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Hobbies
                if (discoveryUser.commonHobbies.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: discoveryUser.commonHobbies.take(3).map((hobby) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hobby,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Bio
                if (profile.bio != null)
                  Text(
                    profile.bio!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
