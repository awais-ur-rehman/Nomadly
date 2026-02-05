import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';

class InviteRepository {
  final _api = ApiClient();

  /// Generate a new invite code. Returns the created code object.
  Future<Map<String, dynamic>> generateCode({int maxUses = 1}) async {
    final response = await _api.post(
      '${AppConfig.inviteEndpoint}/generate',
      data: {'max_uses': maxUses},
    );
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }

  /// Get all invite codes created by the current user.
  Future<List<Map<String, dynamic>>> getMyCodes() async {
    final response = await _api.get('${AppConfig.inviteEndpoint}/my-codes');
    final data = response.data['data'] as List? ?? [];
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Revoke an invite code by its ID.
  Future<void> revokeCode(String codeId) async {
    await _api.delete('${AppConfig.inviteEndpoint}/$codeId');
  }

  /// Validate an invite code (public endpoint, used during registration).
  /// Returns true if valid, false otherwise.
  Future<bool> validateCode(String code) async {
    try {
      final response = await _api.get('${AppConfig.inviteEndpoint}/validate/$code');
      return response.data['data']?['valid'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Get the invite tree for the current user.
  Future<Map<String, dynamic>> getInviteTree() async {
    final response = await _api.get('${AppConfig.inviteEndpoint}/tree');
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }
}
