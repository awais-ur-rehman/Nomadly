import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/builder.dart';

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
  Future<void> requestConsultation(String builderId, String message) async {
    try {
      await _apiClient.post(
        '${AppConfig.baseUrl}/api/v1/marketplace/builders/$builderId/consult',
        data: {'message': message},
      );
    } on DioException catch (e) {
      _logger.e('Request consultation error: ${e.message}');
      throw _handleError(e);
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
