import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/shared/models/user.dart';

class ProfileDetailsSection extends StatelessWidget {
  final Rig? rig;
  final TravelRoute? route;
  final List<String> hobbies;

  const ProfileDetailsSection({
    super.key,
    this.rig,
    this.route,
    this.hobbies = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rig one-liner
        if (rig != null && (rig!.type != null || rig!.crewType != null)) ...[
          _buildOneLiner(
            Icons.directions_car,
            _rigSummary(rig!),
          ),
          const SizedBox(height: 4),
        ],

        // Trip one-liner
        if (route != null && route!.destination != null) ...[
          _buildOneLiner(
            Icons.place,
            _tripSummary(route!),
          ),
        ],

        // Hobby chips (max 3)
        if (hobbies.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...hobbies.take(3).map<Widget>((h) => Chip(
                label: Text(h, style: const TextStyle(fontSize: 12)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: AppColors.primaryExtraLight,
                labelStyle: const TextStyle(color: AppColors.primary),
              )),
              if (hobbies.length > 3)
                Chip(
                  label: Text('+${hobbies.length - 3}', style: const TextStyle(fontSize: 12)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppColors.greyExtraLight,
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOneLiner(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _rigSummary(Rig rig) {
    final parts = <String>[];
    if (rig.type != null) {
      parts.add(rig.type![0].toUpperCase() + rig.type!.substring(1));
    }
    if (rig.crewType != null) {
      final crew = (rig.crewType as String).replaceAll('_', ' ');
      parts.add(crew[0].toUpperCase() + crew.substring(1));
    }
    if (rig.petFriendly) parts.add('+ Pet');
    return parts.join(' · ');
  }

  String _tripSummary(TravelRoute route) {
    String text = 'On the Road';
    if (route.startDate != null) {
      text += ' · ${DateFormat.MMMd().format(route.startDate!)}';
      if (route.durationDays != null) {
        final end = route.startDate!.add(Duration(days: route.durationDays!));
        text += ' - ${DateFormat.MMMd().format(end)}';
      }
    }
    return text;
  }
}
