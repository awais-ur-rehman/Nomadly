import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../invite/data/repositories/invite_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _inviteFormKey = GlobalKey<FormState>();
  final _identityFormKey = GlobalKey<FormState>();

  final _inviteCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Invite code validation
  bool? _inviteCodeValid;
  bool _validatingCode = false;
  final _inviteRepo = InviteRepository();

  @override
  void dispose() {
    _pageController.dispose();
    _inviteCodeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onInviteCodeChanged(String value) {
    final code = value.trim().toUpperCase();
    if (code.length < 10) {
      setState(() {
        _inviteCodeValid = null;
        _validatingCode = false;
      });
      return;
    }
    setState(() => _validatingCode = true);
    _inviteRepo.validateCode(code).then((valid) {
      if (mounted && _inviteCodeController.text.trim().toUpperCase() == code) {
        setState(() {
          _inviteCodeValid = valid;
          _validatingCode = false;
        });
      }
    });
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_inviteFormKey.currentState!.validate()) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = 1);
    }
  }

  Future<void> _handleSignUp() async {
    if (!_identityFormKey.currentState!.validate()) return;

    final response = await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: '', // Backend will auto-generate
          name: _nameController.text.trim(),
          inviteCode: _inviteCodeController.text.trim(),
        );

    if (response != null && mounted) {
      context.go('/otp?email=${Uri.encodeComponent(_emailController.text.trim())}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                  );
                  setState(() => _currentStep = 0);
                },
              )
            : IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => context.pop(),
              ),
        title: Text(
          _currentStep == 0 ? 'INVITE CODE' : 'REGISTRATION',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildInviteStep(),
                _buildIdentityStep(),
              ],
            ),
            if (authState.isLoading)
              const AppLoader(isOverlay: true, message: 'CREATING ACCOUNT...'),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _inviteFormKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Lock Animation Area
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_inviteCodeValid ?? false) 
                        ? AppColors.accent.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset(
                  (_inviteCodeValid ?? false)
                      ? 'assets/icons/auth/icon_lock_open_glowing.svg'
                      : 'assets/icons/auth/icon_lock_closed.svg',
                  colorFilter: ColorFilter.mode(
                    (_inviteCodeValid ?? false) ? AppColors.accent : AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              'Join the Journey',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nomadly is a private community.\nPlease enter your unique invitation code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.white.withOpacity(0.5),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Invite Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _inviteCodeController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'CODE-XXXXX',
                  hintStyle: TextStyle(
                    color: AppColors.white.withOpacity(0.1),
                    letterSpacing: 4,
                  ),
                  fillColor: Colors.transparent,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: _validatingCode
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : _inviteCodeValid == null
                          ? null
                          : Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                _inviteCodeValid! 
                                    ? 'assets/icons/auth/icon_check_circle.svg'
                                    : 'assets/icons/auth/icon_warning_circle.svg',
                                colorFilter: ColorFilter.mode(
                                  _inviteCodeValid! ? AppColors.accent : AppColors.error,
                                  BlendMode.srcIn,
                                ),
                                height: 24,
                              ),
                            ),
                ),
                textCapitalization: TextCapitalization.characters,
                onChanged: _onInviteCodeChanged,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return '';
                  if (_inviteCodeValid == false) return '';
                  return null;
                },
              ),
            ),
            
            const SizedBox(height: 60),
            
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _inviteCodeValid == true ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.2),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(letterSpacing: 2),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ALREADY HAVE AN ACCOUNT? ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/sign-in'),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _identityFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Registration',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us how you should be known in the field.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40),
            
            _buildFieldHeader('FULL NAME'),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Awais Ur Rehman',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.person_outline, color: AppColors.white.withOpacity(0.3)),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            
            const SizedBox(height: 24),
            
            _buildFieldHeader('EMAIL ADDRESS'),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'nomad@voyage.com',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.email_outlined, color: AppColors.white.withOpacity(0.3)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => (value?.contains('@') ?? false) ? null : 'Invalid email',
            ),
            
            const SizedBox(height: 24),
            
            _buildFieldHeader('PASSWORD'),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    'assets/icons/auth/icon_lock_closed.svg',
                    colorFilter: ColorFilter.mode(AppColors.white.withOpacity(0.3), BlendMode.srcIn),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    _obscurePassword ? 'assets/icons/auth/icon_eye.svg' : 'assets/icons/auth/icon_eye_slash.svg',
                    colorFilter: ColorFilter.mode(AppColors.white.withOpacity(0.3), BlendMode.srcIn),
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) => (value?.length ?? 0) < 6 ? 'Min 6 characters' : null,
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _handleSignUp,
                child: const Text('CREATE ACCOUNT', style: TextStyle(letterSpacing: 2)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppColors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}

