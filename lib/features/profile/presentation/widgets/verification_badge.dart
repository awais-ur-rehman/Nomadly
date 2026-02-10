import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Displays a verification badge based on the user's verification level (0-5).
///
/// - Level 0: nothing
/// - Level 1: gray shield "Basic"
/// - Level 2: blue shield "Trusted"
/// - Level 3: blue check "Verified"
/// - Level 4: gold check "Super Verified"
/// - Level 5: gold star "Nomad Elite"
class VerificationBadge extends StatelessWidget {
  final int level;
  final double size;
  final bool showLabel;

  const VerificationBadge({
    super.key,
    required this.level,
    this.size = 18,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (level <= 0) return const SizedBox.shrink();

    final (IconData icon, Color color, String label) = switch (level) {
      1 => (Icons.shield_outlined, Colors.grey, 'Basic'),
      2 => (Icons.shield, Colors.blue, 'Trusted'),
      3 => (Icons.verified, Colors.blue, 'Verified'),
      4 => (Icons.verified, Colors.amber.shade700, 'Super Verified'),
      _ => (Icons.star, Colors.amber.shade700, 'Nomad Elite'),
    };

    if (!showLabel) {
      return Icon(icon, color: color, size: size);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: size),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: size * 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
