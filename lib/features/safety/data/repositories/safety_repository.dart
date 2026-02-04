import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/user.dart';

class SafetyRepository {
  final _api = ApiClient();

  Future<void> blockUser(String userId) async {
    await _api.post('${AppConfig.safetyEndpoint}/block/$userId');
  }

  Future<void> unblockUser(String userId) async {
    await _api.delete('${AppConfig.safetyEndpoint}/block/$userId');
  }

  Future<List<User>> getBlockedUsers() async {
    final response = await _api.get('${AppConfig.safetyEndpoint}/blocked');
    final data = response.data['data'] as List? ?? [];
    
    return data.map<User>((e) {
      if (e is Map && e['user'] != null) {
        return User.fromJson(Map<String, dynamic>.from(e['user']));
      }
      return const User();
    }).where((u) => u.uid.isNotEmpty).toList();
  }

  Future<void> reportUser(String userId, String reason, {String? description}) async {
    await _api.post(
      '${AppConfig.safetyEndpoint}/report/$userId',
      data: {
        'reason': reason,
        if (description != null && description.isNotEmpty) 'description': description,
      },
    );
  }
}
