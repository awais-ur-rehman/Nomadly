import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/matching_provider.dart';
import '../widgets/matching_card.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  final CardSwiperController _controller = CardSwiperController();
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchingProvider.notifier).loadRecommendations();
    });
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    final state = ref.read(matchingProvider);
    if (previousIndex >= state.recommendations.length) return true;

    final user = state.recommendations[previousIndex];
    String action;

    if (direction == CardSwiperDirection.right) {
      action = 'like';
    } else if (direction == CardSwiperDirection.left) {
      action = 'pass';
    } else if (direction == CardSwiperDirection.top) {
      action = 'super_like';
    } else {
      return true;
    }

    _logger.d('👆 [MatchingUI] Swiping $action on ${user.username}');
    
    // Fire and forget (Provider handles state update optimistically)
    await ref.read(matchingProvider.notifier).swipeUser(user.uid, action);
    
    // Check for match (need to wait a microsecond for state to update? 
    // actually swipeUser is async and we await it, so state.newMatch might be set now)
    final checkState = ref.read(matchingProvider);
    if (checkState.newMatch != null && mounted) {
        _showMatchDialog(checkState.newMatch!['match']?['user']);
        ref.read(matchingProvider.notifier).clearMatch();
    }

    return true;
  }

  void _showMatchDialog(Map<String, dynamic>? matchedUser) {
    _logger.i('🎉 [MatchingUI] Showing match dialog');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "It's a Match!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Pacifico', // Or any fun font
                ),
              ),
              const SizedBox(height: 20),
              if (matchedUser != null && matchedUser['profile']?['photo_url'] != null)
                 CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(matchedUser['profile']['photo_url']),
                ),
              const SizedBox(height: 10),
              Text(
                "You and ${matchedUser?['profile']?['name'] ?? 'Nomad'} like each other!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                   Navigator.pop(context);
                   // Navigate to chat
                   // context.push('/chat/${match['conversation_id']}'); 
                   // Ideally we get conversation ID from match data
                   // For now just close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send a Message', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Swiping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchingProvider);

    if (state.isLoading && state.recommendations.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.recommendations.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.style, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'No more profiles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Check back later for more nomads nearby!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(matchingProvider.notifier).loadRecommendations(refresh: true);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: Open preferences
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preferences coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Card Stack
            Expanded(
              child: CardSwiper(
                controller: _controller,
                cardsCount: state.recommendations.length,
                onSwipe: _onSwipe,
                numberOfCardsDisplayed: 2,
                backCardOffset: const Offset(0, 30),
                padding: const EdgeInsets.all(20),
                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                  return MatchingCard(user: state.recommendations[index]);
                },
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SwipeButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onTap: () => _controller.swipe(CardSwiperDirection.left),
                  ),
                  const SizedBox(width: 40),
                  _SwipeButton(
                    icon: Icons.star,
                    color: Colors.blue,
                    isSmall: true,
                    onTap: () => _controller.swipe(CardSwiperDirection.top),
                  ),
                  const SizedBox(width: 40),
                  _SwipeButton(
                    icon: Icons.favorite,
                    color: Colors.green,
                    onTap: () => _controller.swipe(CardSwiperDirection.right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isSmall;

  const _SwipeButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmall ? 50.0 : 65.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}
