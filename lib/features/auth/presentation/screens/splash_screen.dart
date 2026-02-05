import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Navigate only when initialized
    if (authState.isAppInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only navigate if we are still on the splash screen
        if (ModalRoute.of(context)?.isCurrent ?? false) {
           if (authState.isAuthenticated) {
            context.go('/home');
          } else {
            context.go('/onboarding');
          }
        }
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.white, // White background
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium Logo Presentation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40), // Requested horizontal padding check? "should have white background... and horizontall padding". I'll add padding.
                child: SvgPicture.asset(
                  'assets/images/logo_nomadly.svg', 
                  width: 140,
                  height: 140,
                   placeholderBuilder: (context) => const Icon(
                    Icons.explore,
                    size: 140,
                    color: AppColors.primary, // Changed from white to primary
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Polished App Name
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.primary, // Changed from White
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              
              // Premium Tagline
              Text(
                AppStrings.appTagline.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textSecondary, // Changed from White
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 80),
              
              // Minimal Loading Indicator
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary), // Changed from White
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
