import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/matching_provider.dart';
import '../../../matches/providers/match_provider.dart';
import '../widgets/matching_card.dart';
import '../widgets/distance_filter_sheet.dart';

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

    final recommended = state.recommendations[previousIndex];
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

    _logger.d('[MatchingUI] Swiping $action on ${recommended.user.username}');

    await ref.read(matchingProvider.notifier).swipeUser(recommended.user.uid, action);
    
    // Check for match
    if (mounted) { 
      final checkState = ref.read(matchingProvider);
      if (checkState.newMatch != null) {
          // Sync matches list immediately
          ref.read(matchProvider.notifier).loadMatches();
          
          _showMatchDialog(checkState.newMatch!['match']);
          ref.read(matchingProvider.notifier).clearMatch();
      }
    }

    // Check if we just swiped the last card
    if (previousIndex == state.recommendations.length - 1) {
       _logger.i('🏁 [MatchingUI] End of stack reached');
       // Delay slightly to let the swipe animation complete before rebuilding the UI
       Future.delayed(const Duration(milliseconds: 300), () {
         if (mounted) {
           ref.read(matchingProvider.notifier).resetDeck();
         }
       });
    }

    return true;
  }

  void _showMatchDialog(Map<String, dynamic>? matchData) {
    if (matchData == null) return;
    
    _logger.i('🎉 [MatchingUI] Showing match dialog');
    final matchedUser = matchData['user'];
    final conversationId = matchData['conversation_id'];
    
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
                   if (conversationId != null) {
                     context.push('/chat/$conversationId');
                   } else {
                     // Fallback to matches screen if something is weird
                     context.go('/matches'); 
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send a Message', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Just close
                },
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
              Icon(
                state.error != null ? Icons.error_outline : Icons.style, 
                size: 80, 
                color: Colors.grey
              ),
              const SizedBox(height: 20),
              Text(
                state.error != null ? 'Something went wrong' : 'No more profiles',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  state.error ?? 'Check back later for more nomads nearby!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(matchingProvider.notifier).loadRecommendations(refresh: true);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                     showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const DistanceFilterSheet(),
                      );
                  },
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Adjust Search Distance'),
                ),
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
                       showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const DistanceFilterSheet(),
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
                numberOfCardsDisplayed: state.recommendations.length == 1 ? 1 : 2,
                backCardOffset: const Offset(0, 30),
                padding: const EdgeInsets.all(20),
                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                  return MatchingCard(recommended: state.recommendations[index]);
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
              color: Colors.grey.withValues(alpha: 0.2),
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
