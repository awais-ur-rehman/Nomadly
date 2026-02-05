import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
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

  // Tabs: Feed(0), Discover(1), [+](2 — intercepted), Chat(3), Me(4)
  // The "+" tab is index 2 but never actually shown — tapping it opens the
  // create action sheet and we keep the previous tab selected.

  void _onTabTapped(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12, left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _CreateOption(
                icon: Icons.photo_camera_outlined,
                label: 'New Post',
                subtitle: 'Share a photo or update',
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/create-post');
                },
              ),
              _CreateOption(
                icon: Icons.route_outlined,
                label: 'New Trip',
                subtitle: 'Announce where you\'re heading',
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/create-trip');
                },
              ),
              _CreateOption(
                icon: Icons.event_outlined,
                label: 'New Activity',
                subtitle: 'Organise a meetup or event',
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/create-activity');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Map visual index (0,1,3,4) → screen index (0,1,2,3)
    final screenIndex = _currentIndex > 2 ? _currentIndex - 1 : _currentIndex;

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: screenIndex,
        children: const [
          PostsFeedScreen(),   // Feed
          MatchingScreen(),    // Discover
          InboxScreen(),       // Chat
          ProfileScreen(),     // Me
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            activeIcon: Icon(Icons.style),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            activeIcon: Icon(Icons.add_circle, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0: // Feed
        return AppBar(
          title: const Text(AppStrings.appName),
          actions: [
            IconButton(
              icon: const Icon(Icons.storefront_outlined),
              onPressed: () => context.push('/marketplace'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => context.push('/notifications'),
            ),
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
      case 4: // Me
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

/// A single row in the create action sheet.
class _CreateOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
