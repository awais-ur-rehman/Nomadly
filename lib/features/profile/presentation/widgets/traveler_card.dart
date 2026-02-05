import 'package:flutter/material.dart';
import '../../../../shared/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class TravelerCard extends StatelessWidget {
  final User user;
  final VoidCallback onConnect;

  const TravelerCard({
    super.key,
    required this.user,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final route = user.travelRoute;
    final hasRoute = route?.destination != null;
    
    String destination = 'Unknown';
    if (hasRoute) {
      final dest = route!.destination!;
      // Assuming coordinates is List<double> from GeoPoint
      if (dest.coordinates.isNotEmpty && dest.coordinates.length >= 2) {
         destination = '${dest.coordinates[1].toStringAsFixed(2)}, ${dest.coordinates[0].toStringAsFixed(2)}';
      }
    }

    final startDate = route?.startDate;
    final displayDate = startDate != null ? DateFormat('MMM d').format(startDate) : 'Soon';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image (User Photo or generic map)
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: user.profile?.photoUrl ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.username ?? 'Nomad',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasRoute) ...[
                  Row(
                    children: [
                      const Icon(Icons.flight_takeoff, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Heading to $destination',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        displayDate,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ] else
                   const Text('No upcoming trips', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Connect'),
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
