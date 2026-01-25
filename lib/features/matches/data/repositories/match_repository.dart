import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/match.dart';
import '../../../../shared/models/user.dart';

class MatchRepository {
  final _apiClient = ApiClient();
  final _logger = Logger();

  // Get all mutual matches
  Future<List<Match>> getMatches() async {
    try {
      final response = await _apiClient.get(
        AppConfig.matchesEndpoint,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Match.fromJson(json)).toList();
      }

      throw Exception('Failed to load matches');
    } on DioException catch (e) {
      _logger.e('Get matches error: ${e.message}');
      // Return empty list on error for now to avoid breaking UI
      return [];
    }
  }

  // Get matched user details
  Future<User> getUserDetails(String userId) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.usersEndpoint}/$userId',
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Failed to load user details');
    } on DioException catch (e) {
      _logger.e('Get user details error: ${e.message}');
      rethrow;
    }
  }

  // Unmatch
  Future<void> unmatch(String matchId) async {
    try {
      await _apiClient.delete(
        '${AppConfig.matchesEndpoint}/$matchId',
      );
    } on DioException catch (e) {
      _logger.e('Unmatch error: ${e.message}');
      throw Exception('Failed to unmatch');
    }
  }
}
