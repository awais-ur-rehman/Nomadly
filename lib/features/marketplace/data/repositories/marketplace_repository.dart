import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/builder.dart';
import '../../../../shared/models/job.dart';

class MarketplaceRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get builders
  Future<List<BuilderProfile>> getBuilders({String? query, List<String>? specialties}) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.baseUrl}/api/v1/marketplace/builders',
        queryParameters: {
          if (query != null) 'search': query,
          if (specialties != null && specialties.isNotEmpty) 'specialties': specialties.join(','),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BuilderProfile.fromJson(json)).toList();
      }
      throw Exception('Failed to load builders');
    } on DioException catch (e) {
      _logger.e('Get builders error: ${e.message}');
      return [];
    }
  }

  // Get builder reviews
  Future<List<BuilderReview>> getBuilderReviews(String builderId) async {
    try {
      final response = await _apiClient.get('${AppConfig.baseUrl}/api/v1/marketplace/builders/$builderId/reviews');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BuilderReview.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get reviews error: ${e.message}');
      return [];
    }
  }

  // Request consultation
  Future<void> requestConsultation(String builderId, String specialty) async {
    try {
      await _apiClient.post(
        '${AppConfig.marketplaceEndpoint}/consult',
        data: {
          'builder_id': builderId,
          'specialty': specialty,
        },
      );
    } on DioException catch (e) {
      _logger.e('Request consultation error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Jobs
  Future<List<Job>> getJobs({
    double? lat, 
    double? lng, 
    double? radius,
    List<String>? categories,
    String? budgetType,
    double? minBudget,
    double? maxBudget,
  }) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.baseUrl}/api/v1/jobs',
        queryParameters: {
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (radius != null) 'radius': radius,
          if (categories != null && categories.isNotEmpty) 'category': categories.join(','),
          if (budgetType != null) 'budget_type': budgetType,
          if (minBudget != null) 'min_budget': minBudget,
          if (maxBudget != null) 'max_budget': maxBudget,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Job.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get jobs error: ${e.message}');
      return [];
    }
  }

  Future<Job> createJob(Map<String, dynamic> jobData) async {
    try {
      _logger.i('Creating job with data: $jobData');
      final response = await _apiClient.post(
        '${AppConfig.baseUrl}/api/v1/jobs',
        data: jobData,
      );
      _logger.i('Create job response: ${response.statusCode}');
      _logger.i('Create job data: ${response.data}');
      if (response.statusCode == 201) {
        final data = response.data['data'];
        _logger.i('Parsing job from: $data');
        return Job.fromJson(data);
      }
      throw Exception('Failed to create job');
    } on DioException catch (e) {
      _logger.e('Create job DioException: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      throw _handleError(e);
    } catch (e, stack) {
      _logger.e('Create job parsing error: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
    }
    return 'An unexpected error occurred.';
  }
}
