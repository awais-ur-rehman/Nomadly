import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/discovery_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/filter_bottom_sheet.dart';
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
  final CardSwiperController _controller = CardSwiperController();
  int _currentIndex = 0;

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    final state = ref.read(discoveryProvider);
    if (previousIndex >= state.users.length) return true;

    final user = state.users[previousIndex];
    String action;

    if (direction == CardSwiperDirection.right) {
      action = 'right';
    } else if (direction == CardSwiperDirection.left) {
      action = 'left';
    } else if (direction == CardSwiperDirection.top) {
      action = 'star'; // Super like
    } else {
      return true;
    }

    // Process swipe
    final match = await ref.read(discoveryProvider.notifier).swipeUser(
      user.user.id,
      action,
    );

    if (match != null && match.isMutual && mounted) {
      // Show match dialog
      _showMatchDialog(user.user.profile?.photoUrl);
    }

    return true;
  }

  void _showMatchDialog(String? photoUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.itsAMatch),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (photoUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl),
              ),
            const SizedBox(height: 16),
            const Text('You have a new mutual connection!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Switch to matches/chat tab
              setState(() {
                _currentIndex = 2;
              });
            },
            child: const Text('Send Message'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Swiping'),
          ),
        ],
      ),
    );
  }

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
          ],
          if (_currentIndex == 1) // Only show filter on discovery
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const FilterBottomSheet(),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0: Feed
          const PostsFeedScreen(),
          // 1: Discovery
          _buildDiscoveryFeed(),
          // 2: Map
          const MapScreen(),
          // 3: Chat / Matches / Inbox
          const InboxScreen(),
          // 4: Profile
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
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Discovery',
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
        return AppStrings.discovery;
      case 2:
        return 'Explore Map';
      case 3:
        return AppStrings.matches;
      case 4:
        return AppStrings.profile;
      default:
        return AppStrings.appName;
    }
  }

  Widget _buildDiscoveryFeed() {
    final state = ref.watch(discoveryProvider);

    if (state.isLoading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              state.noMoreUsers ? AppStrings.noMoreProfiles : 'No users found',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            if (state.noMoreUsers) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(discoveryProvider.notifier).loadDiscoveryFeed(refresh: true),
                child: const Text('Refresh'),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: _controller,
            cardsCount: state.users.length,
            onSwipe: _onSwipe,
            numberOfCardsDisplayed: 2,
            backCardOffset: const Offset(0, 40),
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
              final discoveryUser = state.users[index];
              return GestureDetector(
                onTap: () {
                  context.push('/profile/${discoveryUser.user.id}', extra: discoveryUser.user);
                },
                child: UserCard(discoveryUser: discoveryUser),
              );
            },
          ),
        ),
        // Swipe Actions
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FloatingActionButton(
                icon: Icons.close,
                color: AppColors.error,
                onPressed: () => _controller.swipe(CardSwiperDirection.left),
              ),
              _FloatingActionButton(
                icon: Icons.star,
                color: AppColors.warning,
                onPressed: () => _controller.swipe(CardSwiperDirection.top),
                isSmall: true,
              ),
              _FloatingActionButton(
                icon: Icons.favorite,
                color: AppColors.success,
                onPressed: () => _controller.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isSmall;

  const _FloatingActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: isSmall ? 24 : 32,
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
