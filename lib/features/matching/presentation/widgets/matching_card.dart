import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Main Photo
          if (photoUrl != null)
            CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 80, color: Colors.grey),
              ),
            )
          else
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
            ),

          // 2. Top-left: info/report button
          if (onReport != null)
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: onReport,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                ),
              ),
            ),

          // 3. Top-right: compatibility badge + distance
          if (compatibility != null || distanceKm != null)
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (compatibility != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _compatibilityColor(compatibility.total),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${compatibility.total}% Match',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  if (distanceKm != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            _formatDistance(distanceKm),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // 3. Gradient Overlay for Text Readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // 4. Info Content
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name & Age
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        user.profile?.name ?? user.username ?? 'Nomad',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.profile?.age != null) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${user.profile!.age}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Bio
                if (user.profile?.bio != null)
                  Text(
                    user.profile!.bio!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 10),

                // Score highlights (only when compatibility is available)
                if (compatibility != null) _buildScoreHighlights(compatibility),

                const SizedBox(height: 10),

                // Interests / Tags
                if (user.profile?.hobbies != null &&
                    user.profile!.hobbies.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.profile!.hobbies.take(3).map<Widget>((hobby) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          hobby,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// Build compact score highlight chips for strong dimensions.
  Widget _buildScoreHighlights(CompatibilityScore compatibility) {
    final highlights = <_Highlight>[];

    if (compatibility.routeOverlap >= 70) {
      highlights.add(_Highlight(Icons.place, 'Same destination'));
    }
    if (compatibility.temporalOverlap >= 70) {
      highlights.add(_Highlight(Icons.date_range, 'Same dates'));
    }
    if (compatibility.hobbyMatch >= 60) {
      highlights.add(_Highlight(Icons.interests, 'Shared hobbies'));
    }
    if (compatibility.proximity >= 80) {
      highlights.add(_Highlight(Icons.near_me, 'Nearby'));
    }

    if (highlights.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: highlights.take(2).map((h) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(h.icon, color: Colors.amber, size: 14),
            const SizedBox(width: 3),
            Text(
              h.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _compatibilityColor(int total) {
    if (total >= 75) return Colors.green.shade600;
    if (total >= 50) return AppColors.primary;
    return Colors.orange.shade700;
  }

  String _formatDistance(double km) {
    if (km < 1) return '<1 km';
    if (km >= 1000) return '${(km / 1000).toStringAsFixed(0)}k km';
    return '${km.round()} km';
  }
}

class _Highlight {
  final IconData icon;
  final String label;
  const _Highlight(this.icon, this.label);
}
