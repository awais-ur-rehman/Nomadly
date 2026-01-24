import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../data/models/auth_response.dart';
import '../data/repositories/auth_repository.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/services/toast_service.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Logger _logger = Logger();

  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        // TODO: Fetch user profile
        state = state.copyWith(isAuthenticated: true);
      }
    } catch (e) {
      _logger.e('Error checking auth status: $e');
    }
  }

  // Register
  Future<RegisterResponse?> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    int? age,
    String? gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
        gender: gender,
      );

      state = state.copyWith(isLoading: false);
      ToastService.showSuccess('Registration successful! Please verify your email.');
      return response;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
      return null;
    }
  }

  // Verify OTP
  Future<bool> verifyOTP({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.verifyOTP(
        email: email,
        code: code,
      );

      state = state.copyWith(
        isLoading: false,
        user: response.user,
        isAuthenticated: true,
      );

      ToastService.showSuccess('Email verified successfully!');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
      return false;
    }
  }

  // Resend OTP
  Future<void> resendOTP(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.resendOTP(email);
      state = state.copyWith(isLoading: false);
      ToastService.showSuccess('OTP sent successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        user: response.user,
        isAuthenticated: true,
      );

      ToastService.showSuccess('Login successful!');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
      return false;
    }
  }

  // Complete Profile
  Future<bool> completeProfile({
    required Map<String, dynamic> profileData,
    required Map<String, dynamic> rigData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.completeProfile(
        profileData: profileData,
        rigData: rigData,
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
      );

      ToastService.showSuccess('Profile completed successfully!');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ToastService.showError(e.toString());
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _repository.logout();
      state = AuthState(); // Reset to initial state
      ToastService.showSuccess('Logged out successfully');
    } catch (e) {
      _logger.e('Logout error: $e');
      ToastService.showError('Failed to logout');
    }
  }

  // Update user
  void updateUser(User user) {
    state = state.copyWith(user: user);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
