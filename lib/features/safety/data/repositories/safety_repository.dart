import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';

class SafetyRepository {
  final _api = ApiClient();

  Future<void> blockUser(String userId) async {
    await _api.post('${AppConfig.safetyEndpoint}/block/$userId');
  }

  Future<void> unblockUser(String userId) async {
    await _api.delete('${AppConfig.safetyEndpoint}/block/$userId');
  }

  Future<List<String>> getBlockedUserIds() async {
    final response = await _api.get('${AppConfig.safetyEndpoint}/blocked');
    final data = response.data['data'] as List? ?? [];
    // Backend returns blocked user objects; extract IDs
    return data.map<String>((e) {
      if (e is String) return e;
      if (e is Map) return (e['blocked_user_id'] ?? e['_id'] ?? '').toString();
      return '';
    }).where((id) => id.isNotEmpty).toList();
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
