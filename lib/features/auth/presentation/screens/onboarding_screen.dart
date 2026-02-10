import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _backgrounds = [
    'assets/images/bg_campfire_dark.png',
    'assets/images/bg_mountain_mist.png',
    'assets/images/bg_winding_road.png',
    'assets/images/bg_van_interior.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _backgrounds.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToSignUp();
    }
  }

  void _skip() {
    _navigateToSignUp();
  }

  void _navigateToSignUp() {
    context.go('/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          // Background with Ken Burns Effect
          TweenAnimationBuilder<double>(
            key: ValueKey(_currentPage),
            tween: Tween(begin: 1.01, end: 1.1),
            duration: const Duration(seconds: 15),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_backgrounds[_currentPage]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),

          // Dark Overlay for contrast (Brightened as per feedback)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.obsidian.withOpacity(0.1),
                  AppColors.obsidian.withOpacity(0.45),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          'assets/images/logo_mark_white.png',
                          height: 32,
                        ),
                      ),
                      TextButton(
                        onPressed: _skip,
                        child: Text(
                          AppStrings.skip.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Onboarding Content
                SizedBox(
                  height: 280, // Reduced to sit better on background
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildPageContent(
                        title: AppStrings.onboardingTitle1,
                        desc: AppStrings.onboardingDesc1,
                      ),
                      _buildPageContent(
                        title: AppStrings.onboardingTitle2,
                        desc: AppStrings.onboardingDesc2,
                      ),
                      _buildPageContent(
                        title: AppStrings.onboardingTitle3,
                        desc: AppStrings.onboardingDesc3,
                      ),
                      _buildPageContent(
                        title: AppStrings.onboardingTitle4,
                        desc: AppStrings.onboardingDesc4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      // Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _backgrounds.length,
                          (index) => _buildIndicator(index == _currentPage),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _currentPage == _backgrounds.length - 1
                                ? AppStrings.getStarted.toUpperCase()
                                : AppStrings.next.toUpperCase(),
                            style: const TextStyle(
                              letterSpacing: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            desc,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              color: AppColors.white.withOpacity(0.9), // Higher opacity for readability without card
              height: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 1),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 4,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
