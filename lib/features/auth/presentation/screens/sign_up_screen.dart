import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../invite/data/repositories/invite_repository.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(_currentStep == 0 ? 'The Gate' : 'The Passport'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() => _currentStep = 0);
                },
              )
            : null,
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
              const AppLoader(isOverlay: true, message: 'Creating Account...'),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Form(
        key: _inviteFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.paddingXXL),
            const Icon(Icons.key, size: 80, color: AppColors.primary),
            const SizedBox(height: AppDimensions.paddingXL),
            const Text(
              'Do you have the key?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            const Text(
              'Nomadly is a private community. Enter your invite code to enter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            TextFormField(
              controller: _inviteCodeController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'NOMAD-XXXXX',
                suffixIcon: _validatingCode
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : _inviteCodeValid == null
                        ? null
                        : Icon(
                            _inviteCodeValid! ? Icons.check_circle : Icons.cancel,
                            color: _inviteCodeValid! ? Colors.green : Colors.red,
                          ),
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: _onInviteCodeChanged,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your invite code';
                }
                if (_inviteCodeValid == false) {
                  return 'Invalid invite code';
                }
                return null;
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton(
                onPressed: _inviteCodeValid == true ? _nextStep : null,
                child: const Text('Unlock Access'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Form(
        key: _identityFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Complete your Passport',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            const Text(
              'Tell us who you are',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AppStrings.name,
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.errorFieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingM),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: AppStrings.email,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.errorFieldRequired;
                }
                if (!value.contains('@')) {
                  return AppStrings.errorInvalidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingM),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppStrings.password,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.errorFieldRequired;
                }
                if (value.length < 6) {
                  return AppStrings.errorInvalidPassword;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingM),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: AppStrings.confirmPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.errorFieldRequired;
                }
                if (value != _passwordController.text) {
                  return AppStrings.errorPasswordMismatch;
                }
                return null;
              },
              onFieldSubmitted: (_) => _handleSignUp(),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            SizedBox(
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton(
                onPressed: _handleSignUp,
                child: const Text('Join the Community'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

