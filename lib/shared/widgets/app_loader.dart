import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final bool isOverlay;

  const AppLoader({
    super.key,
    this.message,
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOverlay) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: _buildLoader(),
      );
    }
    return Center(child: _buildLoader());
  }

  Widget _buildLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
