import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../../../shared/widgets/app_loader.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          name: _nameController.text.trim(),
          inviteCode: _inviteCodeController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

    if (response != null && mounted) {
      // Navigate to OTP screen
      context.go('/otp?email=${Uri.encodeComponent(_emailController.text.trim())}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.signUp),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimensions.paddingL),

                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    const Text(
                      'Join the nomad community',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Invite code field
                    TextFormField(
                      controller: _inviteCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Invite Code',
                        prefixIcon: Icon(Icons.card_giftcard_outlined),
                        hintText: 'NOMAD-XXXXX',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'An invite code is required to join Nomadly';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Name field
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
                    // Username field
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.alternate_email),
                        hintText: 'Use letters, numbers, and underscores',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                         if (value == null || value.isEmpty) {
                           return AppStrings.errorFieldRequired;
                         }
                         if (value.length < 3) {
                           return 'Username must be at least 3 characters';
                         }
                         if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                           return 'Only letters, numbers and underscores allowed';
                         }
                         return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Email field
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

                    // Phone field (optional)
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: '${AppStrings.phone} (Optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Password field
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

                    // Confirm Password field
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

                    // Sign Up button
                    SizedBox(
                      height: AppDimensions.buttonHeightL,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleSignUp,
                        child: const Text(AppStrings.signUp),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.alreadyHaveAccount,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/sign-in');
                          },
                          child: const Text(AppStrings.signIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (authState.isLoading)
              const AppLoader(isOverlay: true, message: 'Creating Account...'),
          ],
        ),
      ),
    );
  }
}
