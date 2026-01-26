import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/user.dart';

class MatchingCard extends StatelessWidget {
  final User user;

  const MatchingCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.profile?.photoUrl;
    
    return Container(
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

          // 2. Gradient Overlay for Text Readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
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

          // 3. Info Content
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                const SizedBox(height: 12),
                
                // Interests / Tags
                if (user.profile?.hobbies != null && user.profile!.hobbies!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.profile!.hobbies!.take(3).map((hobby) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
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
    );
  }
}
