
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/api_client.dart';
import '../../../../core/config/app_config.dart';

class SubscriptionRepository {
  final _apiClient = ApiClient();

  Future<void> syncSubscription() async {
    try {
      // Calls POST /payments/sync
      await _apiClient.post('${AppConfig.paymentsEndpoint}/sync');
    } catch (e) {
      // We allow this to fail silently in UI or log, but throw so caller knows
      throw e;
    }
  }
}
