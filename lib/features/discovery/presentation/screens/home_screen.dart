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

  @override
  Widget build(BuildContext context) {
    // Map visual index (0,1,3,4) → screen index (0,1,2,3)
    final screenIndex = _currentIndex > 2 ? _currentIndex - 1 : _currentIndex;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          IndexedStack(
            index: screenIndex,
            children: const [
              PostsFeedScreen(),   // Feed (0)
              MatchingScreen(),    // Discover (1)
              InboxScreen(),       // Chat (3)
              ProfileScreen(),     // Profile (4)
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
          title: const SizedBox.shrink(), // Remove "Nomadly"
          centerTitle: true,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/home/marketplace.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              onPressed: () => context.push('/marketplace'),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/home/notification.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              onPressed: () => context.push('/notifications'),
            ),
            const SizedBox(width: 8),
          ],
        );
      case 1: // Discover
        return AppBar(
          title: const Text('Discover'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/search'),
            ),
          ],
        );
      case 3: // Chat
        return AppBar(
          title: const Text('Messages'),
        );
      case 4: // Profile
        return AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
          ],
        );
      default:
        return AppBar(title: const Text(AppStrings.appName));
    }
  }
}
