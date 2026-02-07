import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/vantage_navbar.dart';
import '../../../chat/presentation/screens/inbox_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../social/presentation/screens/posts_feed_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) return; // FAB is handled by the navbar widget
    setState(() => _currentIndex = index);
  }

  // Map visual tab index to screen index
  // Visual: 0=Feed, 1=Discover, 2=FAB(skip), 3=Chat, 4=Profile
  // Screen: 0=Feed, 1=Discover, 2=Chat, 3=Profile
  int get _screenIndex {
    switch (_currentIndex) {
      case 0: return 0; // Feed
      case 1: return 1; // Discover
      case 3: return 2; // Chat
      case 4: return 3; // Profile
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          IndexedStack(
            index: _screenIndex,
            children: const [
              PostsFeedScreen(), // 0 - Feed
              MatchingScreen(), // 1 - Discover
              InboxScreen(), // 2 - Chat
              ProfileScreen(), // 3 - Profile
            ],
          ),

          // Floating Navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: VantageNavbar(
              currentIndex: _currentIndex,
              onTabSelected: _onTabTapped,
              onPostTap: () => context.push('/create-post'),
              onTripTap: () => context.push('/create-trip'),
              onActivityTap: () => context.push('/create-activity'),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0: // Feed
        return AppBar(
          backgroundColor: AppColors.obsidian,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const SizedBox.shrink(),
          centerTitle: true,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/home/marketplace.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => context.push('/marketplace'),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/home/notification.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => context.push('/notifications'),
            ),
            const SizedBox(width: 8),
          ],
        );
      case 1: // Discover - No AppBar, MatchingScreen has its own header
        return PreferredSize(preferredSize: Size.zero, child: Container());
      case 3: // Chat
        return AppBar(
          backgroundColor: AppColors.obsidian,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Messages',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.white,
            ),
          ),
        );
      case 4: // Profile - No AppBar, ProfileScreen has its own header
        return PreferredSize(preferredSize: Size.zero, child: Container());
      default:
        return AppBar(title: const Text(AppStrings.appName));
    }
  }
}
