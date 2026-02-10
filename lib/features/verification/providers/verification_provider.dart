import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/verification.dart';
import '../data/repositories/verification_repository.dart';

class VerificationState {
  final Verification? verification;
  final bool isLoading;
  final String? error;

  const VerificationState({this.verification, this.isLoading = false, this.error});

  VerificationState copyWith({Verification? verification, bool? isLoading, String? error}) {
    return VerificationState(
      verification: verification ?? this.verification,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class VerificationNotifier extends StateNotifier<VerificationState> {
  final VerificationRepository _repo;

  VerificationNotifier(this._repo) : super(const VerificationState());

  Future<void> loadStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final v = await _repo.getStatus();
      state = state.copyWith(verification: v, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> submitPhone(String phoneNumber) async {
    try {
      await _repo.submitPhone(phoneNumber);
      await loadStatus();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitPhoto(String selfieUrl) async {
    try {
      await _repo.submitPhoto(selfieUrl);
      await loadStatus();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitIdDocument(String documentUrl, String documentType) async {
    try {
      await _repo.submitIdDocument(documentUrl, documentType);
      await loadStatus();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> refreshCommunity() async {
    try {
      await _repo.refreshCommunity();
      await loadStatus();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final verificationProvider = StateNotifierProvider<VerificationNotifier, VerificationState>((ref) {
  return VerificationNotifier(VerificationRepository());
});
