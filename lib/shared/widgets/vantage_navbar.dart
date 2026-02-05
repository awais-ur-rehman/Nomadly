import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class VantageNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onPostTap;
  final VoidCallback onTripTap;
  final VoidCallback onActivityTap;

  const VantageNavbar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onPostTap,
    required this.onTripTap,
    required this.onActivityTap,
  });

  @override
  State<VantageNavbar> createState() => _VantageNavbarState();
}

class _VantageNavbarState extends State<VantageNavbar> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Dark Overlay when menu is open
        if (_isMenuOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.transparent, // Captures taps to close menu
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),

        // Floating Menu (Tooltip Style)
        Positioned(
          bottom: 150, // Premium vertical separation
          child: ScaleTransition(
            scale: _expandAnimation,
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: _buildFloatingMenu(),
            ),
          ),
        ),

        // Main Navbar Bar
        Container(
          height: 110,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: BottomAppBar(
                padding: EdgeInsets.zero,
                height: 72,
                color: AppColors.obsidian.withOpacity(0.85),
                elevation: 0,
                notchMargin: 10,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, 'nav_home.svg', 'Home'),
                    _buildNavItem(1, 'nav_ai.svg', 'Discover'),
                    const SizedBox(width: 48), // Space for centered FAB
                    _buildNavItem(3, 'nav_resources.svg', 'Chat'),
                    _buildNavItem(4, 'nav_profile.svg', 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Central FAB - Vertically centered on the top edge (half-in, half-out)
        Positioned(
          bottom: 24 + 72 - 32, // (padding) + (barHeight) - (half FAB height)
          child: SizedBox(
            height: 64,
            width: 64,
            child: FloatingActionButton(
              onPressed: _toggleMenu,
              backgroundColor: AppColors.primary,
              elevation: 4,
              shape: const CircleBorder(),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.125).animate(_animationController),
                child: SvgPicture.asset(
                  'assets/icons/nav/nav_plus.svg',
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingMenu() {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.obsidian.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuOption('menu_post.svg', 'Post', widget.onPostTap),
          const Divider(color: AppColors.divider, height: 16, indent: 12, endIndent: 12),
          _buildMenuOption('menu_trip.svg', 'Trip', widget.onTripTap),
          const Divider(color: AppColors.divider, height: 16, indent: 12, endIndent: 12),
          _buildMenuOption('menu_activity.svg', 'Activity', widget.onActivityTap),
        ],
      ),
    );
  }

  Widget _buildMenuOption(String icon, String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _toggleMenu();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/nav/$icon',
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label) {
    final isSelected = widget.currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_isMenuOpen) _toggleMenu();
          widget.onTabSelected(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/nav/$iconName',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 4 : 0,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
