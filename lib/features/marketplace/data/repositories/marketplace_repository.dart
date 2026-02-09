import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/builder.dart';
import '../../../../shared/models/job.dart';
import '../../../../shared/models/job_application.dart';
import '../../../../shared/models/my_job.dart';

class MarketplaceRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get builders
  Future<List<BuilderProfile>> getBuilders({
    String? query,
    List<String>? specialties,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/marketplace/builders',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'search': query,
          if (specialties != null && specialties.isNotEmpty) 'specialties': specialties.join(','),
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BuilderProfile.fromJson(json)).toList();
      }
      throw Exception('Failed to load builders');
    } on DioException catch (e) {
      _logger.e('Get builders error: ${e.message}');
      throw Exception('Failed to load builders: ${e.message}');
    }
  }

  // Get builder reviews
  Future<List<BuilderReview>> getBuilderReviews(String builderId) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/builders/$builderId/reviews');
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
        '/v1/marketplace/consult',
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
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/jobs',
        queryParameters: {
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (radius != null) 'radius': radius,
          if (categories != null && categories.isNotEmpty) 'category': categories.join(','),
          if (budgetType != null) 'budget_type': budgetType,
          if (minBudget != null) 'min_budget': minBudget,
          if (maxBudget != null) 'max_budget': maxBudget,
          'page': page,
          'limit': limit,
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
        '/v1/jobs',
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

  // Get single job
  Future<Job?> getJob(String jobId) async {
    try {
      final response = await _apiClient.get('/v1/jobs/$jobId');
      if (response.statusCode == 200) {
        return Job.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      _logger.e('Get job error: ${e.message}');
      return null;
    }
  }

  // Apply for job
  Future<void> applyForJob(String jobId, String coverLetter) async {
    try {
      await _apiClient.post(
        '/v1/jobs/$jobId/apply',
        data: {'cover_letter': coverLetter},
      );
    } on DioException catch (e) {
      _logger.e('Apply for job error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get my job applications
  Future<List<JobApplication>> getMyApplications() async {
    try {
      final response = await _apiClient.get('/v1/jobs/applications/mine');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => JobApplication.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get my applications error: ${e.message}');
      return [];
    }
  }

  // Get my posted jobs
  Future<List<MyJob>> getMyJobs() async {
    try {
      final response = await _apiClient.get('/v1/jobs/mine');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => MyJob.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get my jobs error: ${e.message}');
      return [];
    }
  }

  // Get applications for a specific job (for job authors)
  Future<List<JobApplication>> getJobApplications(String jobId) async {
    try {
      final response = await _apiClient.get('/v1/jobs/$jobId/applications');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> applications = data['applications'] ?? [];
        return applications.map((json) => JobApplication.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get job applications error: ${e.message}');
      return [];
    }
  }

  // Update application status
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    try {
      await _apiClient.patch(
        '/v1/jobs/applications/$applicationId',
        data: {'status': status},
      );
    } on DioException catch (e) {
      _logger.e('Update application status error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Delete job
  Future<void> deleteJob(String jobId) async {
    try {
      await _apiClient.delete('/v1/jobs/$jobId');
    } on DioException catch (e) {
      _logger.e('Delete job error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Submit review for a consultation
  Future<void> submitReview({
    required String consultationId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _apiClient.post(
        '/v1/marketplace/review',
        data: {
          'consultation_id': consultationId,
          'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );
    } on DioException catch (e) {
      _logger.e('Submit review error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Get my consultations (as requester)
  Future<List<Map<String, dynamic>>> getMyConsultations() async {
    try {
      final response = await _apiClient.get('/v1/marketplace/consultations/mine');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Get my consultations error: ${e.message}');
      return [];
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
