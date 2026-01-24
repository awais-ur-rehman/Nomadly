import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/profile_setup_screen.dart';
import '../features/discovery/presentation/screens/home_screen.dart';
import '../features/chat/presentation/screens/inbox_screen.dart'; // Add this if not present
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/profile/presentation/screens/user_profile_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../shared/models/user.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isOnAuthPage = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up' ||
          state.matchedLocation == '/otp';

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isOnAuthPage) {
        return '/onboarding';
      }

      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated && isOnAuthPage && state.matchedLocation != '/') {
        return '/home';
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return OTPScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Other User Profile
      GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          final user = state.extra as User?;
          return UserProfileScreen(userId: userId, preloadedUser: user);
        },
      ),
      
      // Chat
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;
          final otherUser = state.extra as User;
          return ChatScreen(conversationId: conversationId, otherUser: otherUser);
        },
      ),
    ],
  );
});
