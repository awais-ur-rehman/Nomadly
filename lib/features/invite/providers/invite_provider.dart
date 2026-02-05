import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/invite_repository.dart';

class InviteState {
  final List<Map<String, dynamic>> codes;
  final Map<String, dynamic>? tree;
  final bool isLoading;
  final String? error;

  const InviteState({
    this.codes = const [],
    this.tree,
    this.isLoading = false,
    this.error,
  });

  InviteState copyWith({
    List<Map<String, dynamic>>? codes,
    Map<String, dynamic>? tree,
    bool? isLoading,
    String? error,
  }) {
    return InviteState(
      codes: codes ?? this.codes,
      tree: tree ?? this.tree,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get activeCodeCount => codes.where((c) => c['is_active'] == true).length;
}

class InviteNotifier extends StateNotifier<InviteState> {
  final InviteRepository _repo;

  InviteNotifier(this._repo) : super(const InviteState());

  Future<void> loadCodes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final codes = await _repo.getMyCodes();
      state = state.copyWith(codes: codes, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> generateCode({int maxUses = 1}) async {
    try {
      await _repo.generateCode(maxUses: maxUses);
      await loadCodes();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> revokeCode(String codeId) async {
    try {
      await _repo.revokeCode(codeId);
      await loadCodes();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadTree() async {
    try {
      final tree = await _repo.getInviteTree();
      state = state.copyWith(tree: tree);
    } catch (_) {}
  }
}

final inviteRepositoryProvider = Provider<InviteRepository>((_) => InviteRepository());

final inviteProvider = StateNotifierProvider<InviteNotifier, InviteState>((ref) {
  return InviteNotifier(ref.watch(inviteRepositoryProvider));
});
