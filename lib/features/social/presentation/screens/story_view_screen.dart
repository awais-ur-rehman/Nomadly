import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/models/post.dart';
import '../../../../shared/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryViewScreen extends StatefulWidget {
  final List<Story> stories;
  final User user;
  final int initialIndex;

  const StoryViewScreen({
    super.key,
    required this.stories,
    required this.user,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    final width = MediaQuery.of(context).size.width;
    final x = details.globalPosition.dx;

    HapticFeedback.lightImpact();

    if (x < width / 2) {
      // LEFT SIDE: Go to NEXT story (User request)
      if (_currentIndex < widget.stories.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // No more next stories -> Close
        Navigator.pop(context);
      }
    } else {
      // RIGHT SIDE: Go to PREVIOUS story (User request)
      if (_currentIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // No more previous stories -> Close
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Semantics(
        container: true,
        explicitChildNodes: true,
        child: GestureDetector(
          onTapDown: _handleTap,
          onVerticalDragUpdate: (details) {
            // Detect swipe down
            if (details.primaryDelta! > 10) {
              Navigator.pop(context);
            }
          },
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable standard swipe to use our custom tap/swipe logic
            itemCount: widget.stories.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final story = widget.stories[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: story.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                  ),
                  
                  // Top Overlay with Progress Indicators (Simulated)
                  Positioned(
                    top: 50,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: widget.stories.asMap().entries.map((entry) {
                        return Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: entry.key <= _currentIndex 
                                  ? Colors.white 
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
  
                  // Story Info Overlay
                  Positioned(
                    top: 70,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: widget.user.profile?.photoUrl != null 
                              ? NetworkImage(widget.user.profile!.photoUrl!) 
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.user.profile?.name ?? 'Nomad',
                          style: const TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
