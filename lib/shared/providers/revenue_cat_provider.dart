import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/revenue_cat_service.dart';

final revenueCatServiceProvider = Provider<RevenueCatService>((ref) => RevenueCatService());

final isProProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  // Ensure init was called (it's called in main, but good to be safe or rely on service state)
  return await service.isPro();
});

final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
  // Purchases.addCustomerInfoUpdateListener
  return Stream.fromFuture(Purchases.getCustomerInfo()); 
  // TODO: Proper stream implementation if real-time updates needed
});
