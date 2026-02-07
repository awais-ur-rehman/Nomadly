import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/matching_provider.dart';
import '../../../matches/providers/match_provider.dart';
import '../../../safety/providers/safety_provider.dart';
import '../../../../shared/services/toast_service.dart';
import '../widgets/matching_card.dart';

class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> with SingleTickerProviderStateMixin {
  final CardSwiperController _controller = CardSwiperController();
  final _logger = Logger();
  final TextEditingController _searchController = TextEditingController();
  
  // Filter Menu State
  bool _isFilterMenuOpen = false;
  late AnimationController _filterAnimController;
  late Animation<double> _filterExpandAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchingProvider.notifier).loadRecommendations();
      ref.read(safetyProvider.notifier).loadBlockedUsers();
    });

    _filterAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _filterExpandAnimation = CurvedAnimation(
      parent: _filterAnimController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterAnimController.dispose();
    super.dispose();
  }

  void _toggleFilterMenu() {
    setState(() {
      _isFilterMenuOpen = !_isFilterMenuOpen;
      if (_isFilterMenuOpen) {
        _filterAnimController.forward();
      } else {
        _filterAnimController.reverse();
      }
    });
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    List<dynamic> currentList,
  ) async {
    // We pass the current list to know what we are swiping on
    if (previousIndex >= currentList.length) return true;

    final recommended = currentList[previousIndex];
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

    // Optimistic UI update is handled by the swiper visual
    await ref.read(matchingProvider.notifier).swipeUser(recommended.user.uid, action);
    
    // Check for match
    if (mounted) { 
      final checkState = ref.read(matchingProvider);
      if (checkState.newMatch != null) {
          ref.read(matchProvider.notifier).loadMatches();
          _showMatchDialog(checkState.newMatch!['match']);
          ref.read(matchingProvider.notifier).clearMatch();
      }
    }

    return true;
  }

  void _showMatchDialog(Map<String, dynamic>? matchData) {
    if (matchData == null) return;
    
    final matchedUser = matchData['user'];
    final conversationId = matchData['conversation_id'];
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
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
                  fontFamily: 'Outfit', 
                ),
              ),
              const SizedBox(height: 24),
              if (matchedUser != null && matchedUser['profile']?['photo_url'] != null)
                 CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(matchedUser['profile']['photo_url']),
                ),
              const SizedBox(height: 16),
              Text(
                "You and ${matchedUser?['profile']?['name'] ?? 'Nomad'} vibe!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                   Navigator.pop(context);
                   if (conversationId != null) {
                     context.push('/chat/$conversationId');
                   } else {
                     context.go('/matches'); 
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Send a Message', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Swiping', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardSafetySheet(String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 24), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await ref.read(safetyProvider.notifier).blockUser(userId);
                if (ok && mounted) {
                  ToastService.showSuccess('User blocked');
                  _controller.swipe(CardSwiperDirection.left);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Report User', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog(userId);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(String userId) {
    // ... consistent report dialog ...
    const reasons = [
      ('harassment', 'Harassment'),
      ('fake_profile', 'Fake Profile'),
      ('inappropriate_content', 'Inappropriate Content'),
      ('spam', 'Spam'),
      ('other', 'Other'),
    ];
    String? selectedReason;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Report User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: reasons.map((r) => RadioListTile<String>(
              value: r.$1,
              groupValue: selectedReason,
              title: Text(r.$2),
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.red,
              onChanged: (v) => setDialogState(() => selectedReason = v),
            )).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
            TextButton(
              onPressed: () async {
                if (selectedReason == null) { ToastService.showError('Select a reason'); return; }
                Navigator.pop(ctx);
                final ok = await ref.read(safetyProvider.notifier).reportUser(userId, selectedReason!);
                if (mounted) ok ? ToastService.showSuccess('Report submitted') : ToastService.showError('Failed');
              },
              child: const Text('Submit', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchingProvider);
    final blockedIds = ref.watch(safetyProvider).blockedUserIds;
    final searchQuery = _searchController.text.toLowerCase();

    // 1. Filter blocked users
    var activeRecs = state.recommendations
        .where((r) => !blockedIds.contains(r.user.uid))
        .toList();
    
    // 2. Filter by search query (local filter)
    if (searchQuery.isNotEmpty) {
      activeRecs = activeRecs.where((r) {
        final name = (r.user.profile?.name ?? '').toLowerCase();
        final username = (r.user.username ?? '').toLowerCase();
        return name.contains(searchQuery) || username.contains(searchQuery);
      }).toList();
    }

    final isSearching = state.isSearching || searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.obsidian, // Dark background
      body: Stack(
        children: [
          // Main Content Layer
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                            onChanged: (val) {
                              setState(() {}); // Local UI update
                              ref.read(matchingProvider.notifier).searchUsers(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search nomads...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15),
                              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.close, color: Colors.white.withOpacity(0.5), size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                        ref.read(matchingProvider.notifier).searchUsers('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter Button
                      GestureDetector(
                        onTap: _toggleFilterMenu,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENT: Search Results OR Swipe Deck
                Expanded(
                  child: searchQuery.isNotEmpty
                      ? _buildSearchResults(state)
                      : activeRecs.isEmpty
                          ? _buildEmptyState(state, false)
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: CardSwiper(
                                controller: _controller,
                                cardsCount: activeRecs.length,
                                onSwipe: (prev, curr, dir) => _onSwipe(prev, curr, dir, activeRecs),
                                numberOfCardsDisplayed: activeRecs.length == 1 ? 1 : 2,
                                backCardOffset: const Offset(0, 30),
                                padding: const EdgeInsets.all(0),
                                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                  final rec = activeRecs[index];
                                  return MatchingCard(
                                    recommended: rec,
                                    onTap: () => context.push('/profile/${rec.user.uid}', extra: rec.user),
                                  );
                                },
                              ),
                            ),
                ),

                // Controls (Only show if we have cards AND NOT searching)
                if (activeRecs.isNotEmpty && searchQuery.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 130),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SwipeButton(
                          icon: Icons.close,
                          color: const Color(0xFFFF4B4B),
                          onTap: () => _controller.swipe(CardSwiperDirection.left),
                        ),
                        const SizedBox(width: 32),
                        _SwipeButton(
                          icon: Icons.star_rounded,
                          color: const Color(0xFF4B9FFF),
                          isSmall: true,
                          onTap: () => _controller.swipe(CardSwiperDirection.top),
                        ),
                        const SizedBox(width: 32),
                        _SwipeButton(
                          icon: Icons.favorite_rounded,
                          color: const Color(0xFF00C853),
                          onTap: () => _controller.swipe(CardSwiperDirection.right),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Black Overlay for Menu
          if (_isFilterMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleFilterMenu,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.transparent, // Capture taps
                ),
              ),
            ),

          // Filter Menu (Animated)
          Positioned(
            top: MediaQuery.of(context).padding.top + 70, // Below top bar
            right: 20,
            child: ScaleTransition(
              scale: _filterExpandAnimation,
              alignment: Alignment.topRight,
              child: FadeTransition(
                opacity: _filterExpandAnimation,
                child: _buildFilterMenu(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(MatchingState state, bool isSearching) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.error != null) {
      return Center(child: Text(state.error!, style: const TextStyle(color: Colors.white)));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.explore_off_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          Text(
            isSearching ? 'No nomads found.' : "Searching for nomads...",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isSearching 
                  ? "Try a different search term or clear the filter."
                  : "We're expanding our network! Check back soon for new travelers in your area.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.5),
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {});
                ref.read(matchingProvider.notifier).searchUsers('');
              },
              icon: const Icon(Icons.clear, color: Colors.white),
              label: const Text("Clear Search", style: TextStyle(color: Colors.white)),
            ),
          ] else if (!state.isLoading) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => ref.read(matchingProvider.notifier).loadRecommendations(refresh: true),
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              label: const Text("Refresh List", style: TextStyle(color: AppColors.primary)),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSearchResults(MatchingState state) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.searchResults.isEmpty) {
      return _buildEmptyState(state, true);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final user = state.searchResults[index].user;
        return Card(
          color: AppColors.white.withOpacity(0.05),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: user.profile?.photoUrl != null
                  ? NetworkImage(user.profile!.photoUrl!)
                  : null,
              child: user.profile?.photoUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(
              user.profile?.name ?? user.username ?? 'Nomad',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              user.profile?.bio ?? 'No bio yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            onTap: () => context.push('/profile/${user.uid}', extra: user),
          ),
        );
      },
    );
  }

  Widget _buildFilterMenu() {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Dark surface
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
             padding: const EdgeInsets.only(bottom: 16, left: 4),
             child: Text(
               'EXPLORATION RADIUS',
               style: TextStyle(
                 color: AppColors.primary.withOpacity(0.8),
                 fontSize: 12,
                 fontWeight: FontWeight.bold,
                 letterSpacing: 1.2,
               ),
             ),
          ),
          _buildFilterOption('Town', '50 km', 50, Icons.home_work_outlined),
          const SizedBox(height: 8),
          _buildFilterOption('Region', '100 km', 100, Icons.location_city_outlined),
          const SizedBox(height: 8),
          _buildFilterOption('State', '500 km', 500, Icons.map_outlined),
          const SizedBox(height: 8),
          _buildFilterOption('Global', 'Everywhere', 10000, Icons.public),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, String subtitle, int distance, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(matchingProvider.notifier).updateDistance(distance);
          _toggleFilterMenu();
          ToastService.showSuccess('Radius updated to $subtitle');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            color: Colors.white.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 14),
            ],
          ),
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
    final size = isSmall ? 50.0 : 64.0;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.45,
        ),
      ),
    );
  }
}
