import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/builder.dart';
import '../../../../shared/models/job.dart';
import '../../../../shared/services/toast_service.dart';
import '../data/repositories/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) => MarketplaceRepository());

class MarketplaceState {
  final List<BuilderProfile> builders;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final List<String> selectedSpecialties;
  final List<Job> jobs;
  final int buildersPage;
  final int jobsPage;
  final bool hasMoreBuilders;
  final bool hasMoreJobs;
  static const int pageSize = 20;

  MarketplaceState({
    this.builders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedSpecialties = const [],
    this.jobs = const [],
    this.buildersPage = 1,
    this.jobsPage = 1,
    this.hasMoreBuilders = true,
    this.hasMoreJobs = true,
  });

  MarketplaceState copyWith({
    List<BuilderProfile>? builders,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    List<String>? selectedSpecialties,
    List<Job>? jobs,
    int? buildersPage,
    int? jobsPage,
    bool? hasMoreBuilders,
    bool? hasMoreJobs,
  }) {
    return MarketplaceState(
      builders: builders ?? this.builders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
      jobs: jobs ?? this.jobs,
      buildersPage: buildersPage ?? this.buildersPage,
      jobsPage: jobsPage ?? this.jobsPage,
      hasMoreBuilders: hasMoreBuilders ?? this.hasMoreBuilders,
      hasMoreJobs: hasMoreJobs ?? this.hasMoreJobs,
    );
  }
}

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final MarketplaceRepository _repository;

  MarketplaceNotifier(this._repository) : super(MarketplaceState()) {
    searchBuilders();
  }

  Future<void> searchBuilders({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        buildersPage: 1,
        hasMoreBuilders: true,
        builders: [],
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final builders = await _repository.getBuilders(
        query: state.searchQuery,
        specialties: state.selectedSpecialties,
      );
      state = state.copyWith(
        isLoading: false,
        builders: builders,
        hasMoreBuilders: builders.length >= MarketplaceState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreBuilders() async {
    if (state.isLoadingMore || !state.hasMoreBuilders) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.buildersPage + 1;
      final builders = await _repository.getBuilders(
        query: state.searchQuery,
        specialties: state.selectedSpecialties,
        page: nextPage,
      );
      state = state.copyWith(
        isLoadingMore: false,
        builders: [...state.builders, ...builders],
        buildersPage: nextPage,
        hasMoreBuilders: builders.length >= MarketplaceState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    searchBuilders(refresh: true);
  }

  void toggleSpecialty(String specialty) {
    final newList = [...state.selectedSpecialties];
    if (newList.contains(specialty)) {
      newList.remove(specialty);
    } else {
      newList.add(specialty);
    }
    state = state.copyWith(selectedSpecialties: newList);
    searchBuilders(refresh: true);
  }

  Future<void> requestConsultation(String builderId, String message) async {
    try {
      await _repository.requestConsultation(builderId, message);
      ToastService.showSuccess('Consultation request sent!');
    } catch (e) {
      ToastService.showError(e.toString());
    }
  }
  // Jobs logic
  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        jobsPage: 1,
        hasMoreJobs: true,
        jobs: [],
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final jobs = await _repository.getJobs();
      state = state.copyWith(
        isLoading: false,
        jobs: jobs,
        hasMoreJobs: jobs.length >= MarketplaceState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreJobs() async {
    if (state.isLoadingMore || !state.hasMoreJobs) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.jobsPage + 1;
      final jobs = await _repository.getJobs(page: nextPage);
      state = state.copyWith(
        isLoadingMore: false,
        jobs: [...state.jobs, ...jobs],
        jobsPage: nextPage,
        hasMoreJobs: jobs.length >= MarketplaceState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> createJob(Map<String, dynamic> jobData) async {
    try {
      final newJob = await _repository.createJob(jobData);
      state = state.copyWith(jobs: [newJob, ...state.jobs]);
      ToastService.showSuccess('Job posted successfully!');
    } catch (e) {
      ToastService.showError(e.toString());
      rethrow;
    }
  }

  Future<void> applyForJob(String jobId, String coverLetter) async {
    try {
      await _repository.applyForJob(jobId, coverLetter);
      ToastService.showSuccess('Application submitted successfully!');
    } catch (e) {
      ToastService.showError(e.toString());
      rethrow;
    }
  }
}

final marketplaceProvider = StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return MarketplaceNotifier(repository);
});
