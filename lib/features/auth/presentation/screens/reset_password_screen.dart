import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../../../shared/widgets/app_loader.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).resetPassword(
          email: widget.email,
          otp: _otpController.text.trim(),
          newPassword: _passwordController.text,
        );

    if (success && mounted) {
      // Navigate back to sign in
      context.go('/sign-in');
    }
  }

  Future<void> _handleResendCode() async {
    await ref.read(authProvider.notifier).forgotPassword(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
                      'Create New Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Text(
                      'Enter the code sent to ${widget.email} and create a new password.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // OTP field
                    TextFormField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: 'Reset Code',
                        hintText: 'Enter 6-digit code',
                        prefixIcon: Icon(Icons.pin_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.errorFieldRequired;
                        }
                        if (value.length != 6) {
                          return 'Please enter a valid 6-digit code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Resend code
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: authState.isLoading ? null : _handleResendCode,
                        child: const Text('Resend Code'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // New password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
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
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        // Check for uppercase, lowercase, and number
                        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                          return 'Must contain uppercase, lowercase, and number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    // Confirm password field
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
                      onFieldSubmitted: (_) => _handleSubmit(),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Submit button
                    SizedBox(
                      height: AppDimensions.buttonHeightL,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleSubmit,
                        child: const Text('Reset Password'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (authState.isLoading)
              const AppLoader(isOverlay: true, message: 'Resetting password...'),
          ],
        ),
      ),
    );
  }
}
