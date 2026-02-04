import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/followers_list_screen.dart';
import '../../features/profile/presentation/screens/matching_preferences_screen.dart';
import '../../features/discovery/presentation/screens/home_screen.dart';
import '../../features/discovery/presentation/screens/search_users_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/social/presentation/screens/create_post_screen.dart';
import '../../features/social/presentation/screens/post_detail_screen.dart';
import '../../features/social/presentation/screens/create_story_screen.dart';
import '../../features/social/presentation/screens/create_trip_screen.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/marketplace/presentation/screens/builder_detail_screen.dart';
import '../../features/marketplace/presentation/screens/create_job_screen.dart';
import '../../features/marketplace/presentation/screens/job_detail_screen.dart';
import '../../shared/models/builder.dart';
import '../../shared/models/job.dart';
import '../../features/social/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/user_profile_screen.dart' as profile;
import '../../features/discovery/presentation/screens/user_profile_screen.dart' as discovery;
import '../../features/auth/providers/auth_provider.dart';
import '../../features/activities/presentation/screens/activity_detail_screen.dart';
import '../../features/activities/presentation/screens/create_activity_screen.dart';
import '../../features/activities/presentation/screens/activities_list_screen.dart';
import '../../shared/models/user.dart';
import '../../shared/models/activity.dart'; // Import Activity model
import '../../shared/models/post.dart';
import '../../features/map/presentation/screens/location_picker_screen.dart';
import '../../features/safety/presentation/screens/blocked_users_screen.dart';
import '../../features/invite/presentation/screens/invite_screen.dart';
import '../../features/verification/presentation/screens/verification_screen.dart';

/// Listenable that notifies GoRouter when auth state changes
class RouterListenable extends ChangeNotifier {
  final Ref _ref;
  bool _isAuthenticated = false;

  RouterListenable(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        _isAuthenticated = next.isAuthenticated;
        notifyListeners();
      }
    });
    _isAuthenticated = _ref.read(authProvider).isAuthenticated;
  }

  bool get isAuthenticated => _isAuthenticated;
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = RouterListenable(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final isAuthenticated = listenable.isAuthenticated;
      final isOnAuthPage = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up' ||
          state.matchedLocation == '/otp' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation.startsWith('/reset-password');

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isOnAuthPage) {
        return '/onboarding';
      }

      // If authenticated and on auth pages, redirect to home
      // Note: We don't redirect to /home if matchedLocation is Splash or OTP to allow initial flow
      if (isAuthenticated && 
          (state.matchedLocation == '/sign-in' || state.matchedLocation == '/sign-up')) {
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
          final email = state.uri.queryParameters['email'];
          return OTPScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/matching-preferences',
        builder: (context, state) => const MatchingPreferencesScreen(),
      ),

      // Forgot Password
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Reset Password
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordScreen(email: email);
        },
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
          return profile.UserProfileScreen(userId: userId, preloadedUser: user);
        },
      ),
      
      // User Profile (Discovery - from search)
      GoRoute(
        path: '/user/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return discovery.UserProfileScreen(userId: userId);
        },
      ),
      
      GoRoute(
        path: '/profile/:id/connections',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          final tabStr = state.uri.queryParameters['tab'] ?? '0';
          final initialTab = int.tryParse(tabStr) ?? 0;
          return FollowersListScreen(userId: userId, initialTab: initialTab);
        },
      ),
      
      // Chat
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;
          final otherUser = state.extra as User?;
          return ChatScreen(conversationId: conversationId, otherUser: otherUser);
        },
      ),

      // Activity Detail
      GoRoute(
        path: '/activity/:id',
        builder: (context, state) {
          final activity = state.extra as Activity;
          return ActivityDetailScreen(activity: activity);
        },
      ),

      // Create Activity
      GoRoute(
        path: '/create-activity',
        builder: (context, state) => const CreateActivityScreen(),
      ),

      // Activities List
      GoRoute(
        path: '/activities',
        builder: (context, state) => const ActivitiesListScreen(),
      ),

      // Create Post
      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      // Create Trip
      GoRoute(
        path: '/create-trip',
        builder: (context, state) => const CreateTripScreen(),
      ),
      GoRoute(
        path: '/post/:id',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          final post = state.extra as Post?;
          return PostDetailScreen(postId: postId, preloadedPost: post);
        },
      ),
      GoRoute(
        path: '/create-story',
        builder: (context, state) => const CreateStoryScreen(),
      ),
      // Marketplace
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      // Notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Builder Detail
      GoRoute(
        path: '/builder/:id',
        builder: (context, state) {
          final builder = state.extra as BuilderProfile;
          return BuilderDetailScreen(builder: builder);
        },
      ),
      // Create Job
      GoRoute(
        path: '/marketplace/create-job',
        builder: (context, state) => const CreateJobScreen(),
      ),
      // Job Detail
      GoRoute(
        path: '/job/:id',
        builder: (context, state) {
          final job = state.extra as Job;
          return JobDetailScreen(job: job);
        },
      ),
      // Location Picker (returns LatLng via pop)
      GoRoute(
        path: '/location-picker',
        builder: (context, state) => const LocationPickerScreen(),
      ),
      // Search Users
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchUsersScreen(),
      ),
      // Blocked Users
      GoRoute(
        path: '/blocked-users',
        builder: (context, state) => const BlockedUsersScreen(),
      ),
      // Invite Codes
      GoRoute(
        path: '/invites',
        builder: (context, state) => const InviteScreen(),
      ),
      // Verification
      GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationScreen(),
      ),
    ],
  );
});
