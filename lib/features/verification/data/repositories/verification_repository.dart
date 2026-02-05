import '../../../../core/config/app_config.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../shared/models/verification.dart';

class VerificationRepository {
  final _api = ApiClient();

  Future<Verification> getStatus() async {
    final response = await _api.get('${AppConfig.verificationEndpoint}/status');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return Verification.fromJson(data);
  }

  Future<void> submitPhone(String phoneNumber) async {
    await _api.post(
      '${AppConfig.verificationEndpoint}/phone',
      data: {'phone_number': phoneNumber},
    );
  }

  Future<void> submitPhoto(String selfieUrl) async {
    await _api.post(
      '${AppConfig.verificationEndpoint}/photo',
      data: {'selfie_url': selfieUrl},
    );
  }

  Future<void> submitIdDocument(String documentUrl, String documentType) async {
    await _api.post(
      '${AppConfig.verificationEndpoint}/id-document',
      data: {
        'document_url': documentUrl,
        'document_type': documentType,
      },
    );
  }

  Future<void> refreshCommunity() async {
    await _api.post('${AppConfig.verificationEndpoint}/community/refresh');
  }
}
