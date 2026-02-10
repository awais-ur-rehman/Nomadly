import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/compatibility_score.dart';
import '../../../../shared/models/recommended_user.dart';

class MatchingCard extends StatelessWidget {
  final RecommendedUser recommended;
  final VoidCallback? onReport;
  final VoidCallback? onTap;

  const MatchingCard({super.key, required this.recommended, this.onReport, this.onTap});

  @override
  Widget build(BuildContext context) {
    final user = recommended.user;
    final photoUrl = user.profile?.photoUrl;
    final compatibility = recommended.compatibility;
    final distanceKm = recommended.distanceKm;

    return Semantics(
      container: true,
      label: 'Recommended Match: ${user.profile?.name ?? 'Nomad'}',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), 
        decoration: BoxDecoration(
          color: Colors.black, // Fallback
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 1. Main Photo
              Positioned.fill(
                child: GestureDetector(
                  onTap: onTap,
                  child: photoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: AppColors.slate),
                          errorWidget: (context, url, error) => Container(
                              color: AppColors.slate,
                              child: const Icon(Icons.person, size: 80, color: Colors.white24)),
                        )
                      : Container(
                          color: AppColors.slate,
                          child: const Icon(Icons.person, size: 80, color: Colors.white24),
                        ),
                ),
              ),

              // 2. Gradient Overlay (Bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 200,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Info Content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Match Score & Distance Row
                      Row(
                        children: [
                          if (compatibility != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _compatibilityColor(compatibility.total).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _compatibilityColor(compatibility.total), width: 1),
                              ),
                              child: Text(
                                '${compatibility.total}% Match',
                                style: TextStyle(
                                  color: _compatibilityColor(compatibility.total),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (distanceKm != null)
                             Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDistance(distanceKm),
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Name & Age
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.profile?.name ?? user.username ?? 'Nomad',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (user.profile?.age != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${user.profile!.age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      // Bio
                      if (user.profile?.bio != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          user.profile!.bio!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // 4. Report Button (Top Left)
              if (onReport != null)
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: onReport,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_horiz, color: Colors.white70, size: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _compatibilityColor(int total) {
    if (total >= 75) return AppColors.primary; // Greenish/teal usually better for high match
    if (total >= 50) return Colors.amber;
    return Colors.orange;
  }

  String _formatDistance(double km) {
    if (km < 1) return '<1 km';
    if (km >= 1000) return '${(km / 1000).toStringAsFixed(0)}k km';
    return '${km.round()} km';
  }
}
