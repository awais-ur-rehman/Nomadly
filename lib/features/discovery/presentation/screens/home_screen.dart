import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../chat/presentation/screens/inbox_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../map/presentation/screens/map_screen.dart';
import '../../../social/presentation/screens/posts_feed_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_currentIndex)),
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              icon: const Icon(Icons.storefront_outlined),
              onPressed: () => context.push('/marketplace'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => context.push('/notifications'),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/search'),
            ),
          ],
          if (_currentIndex == 3)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
        ],

      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0: Feed
          const PostsFeedScreen(),
          // 1: Map
          const MapScreen(),
          // 2: Chat / Matches / Inbox
          const InboxScreen(),
          // 3: Profile
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Nomad Feed';
      case 1:
        return 'Explore Map';
      case 2:
        return AppStrings.matches;
      case 3:
        return AppStrings.profile;
      default:
        return AppStrings.appName;
    }
  }
}


