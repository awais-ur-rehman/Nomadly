import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/builder.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) => MarketplaceRepository());

class MarketplaceState {
  final List<BuilderProfile> builders;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final List<String> selectedSpecialties;

  MarketplaceState({
    this.builders = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedSpecialties = const [],
  });

  MarketplaceState copyWith({
    List<BuilderProfile>? builders,
    bool? isLoading,
    String? error,
    String? searchQuery,
    List<String>? selectedSpecialties,
  }) {
    return MarketplaceState(
      builders: builders ?? this.builders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
    );
  }
}

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final MarketplaceRepository _repository;

  MarketplaceNotifier(this._repository) : super(MarketplaceState()) {
    searchBuilders();
  }

  Future<void> searchBuilders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final builders = await _repository.getBuilders(
        query: state.searchQuery,
        specialties: state.selectedSpecialties,
      );
      state = state.copyWith(isLoading: false, builders: builders);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    searchBuilders();
  }

  void toggleSpecialty(String specialty) {
    final newList = [...state.selectedSpecialties];
    if (newList.contains(specialty)) {
      newList.remove(specialty);
    } else {
      newList.add(specialty);
    }
    state = state.copyWith(selectedSpecialties: newList);
    searchBuilders();
  }

  Future<void> requestConsultation(String builderId, String message) async {
    try {
      await _repository.requestConsultation(builderId, message);
      ToastService.showSuccess('Consultation request sent!');
    } catch (e) {
      ToastService.showError(e.toString());
    }
  }
}

final marketplaceProvider = StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return MarketplaceNotifier(repository);
});
