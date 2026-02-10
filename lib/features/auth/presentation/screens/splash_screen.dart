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
      backgroundColor: AppColors.obsidian,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOutSine,
          builder: (context, value, child) {
            // Breathing pulse effect: scale 1.0 to 1.05
            final scale = 1.0 + (0.05 * (1.0 - (1.0 - value).abs()));
            final opacity = 0.8 + (0.2 * value);
            
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo_mark_white.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
