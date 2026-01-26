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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          HapticFeedback.selectionClick();
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 3) {
            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.stories.length,
          itemBuilder: (context, index) {
            final story = widget.stories[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: story.imageUrl,
                  fit: BoxFit.contain,
                ),
                
                // Story Info Overlay
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: widget.user.profile?.photoUrl != null 
                            ? NetworkImage(widget.user.profile!.photoUrl!) 
                            : null,
                        child: widget.user.profile?.photoUrl == null 
                            ? const Icon(Icons.person, size: 20) 
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.user.profile?.name ?? 'Nomad',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }
}
