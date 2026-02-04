import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  final _logger = Logger();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      String? apiKey;
      if (Platform.isAndroid) {
        apiKey = dotenv.env['REVENUE_CAT_GOOGLE_KEY'];
      } else if (Platform.isIOS) {
        apiKey = dotenv.env['REVENUE_CAT_APPLE_KEY'];
      }

      if (apiKey == null || apiKey.isEmpty) {
        _logger.w("RevenueCat API key not found for this platform.");
        return;
      }

      await Purchases.setLogLevel(LogLevel.debug);
      
      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _isInitialized = true;
      _logger.i("RevenueCat initialized successfully.");

    } catch (e) {
      _logger.e("Failed to initialize RevenueCat: $e");
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_isInitialized) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      _logger.e("Error getting customer info: $e");
      return null;
    }
  }

  Future<bool> isPro() async {
    if (!_isInitialized) return false;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all["pro_access"]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> showPaywall() async {
    if (!_isInitialized) return;
    try {
      await RevenueCatUI.presentPaywall();
    } catch (e) {
      _logger.e("Error showing paywall: $e");
    }
  }

  Future<void> showPaywallIfNeeded() async {
    if (!_isInitialized) return;
    try {
        // presentPaywallIfNeeded relies on a specific entitlement identifier
        await RevenueCatUI.presentPaywallIfNeeded("pro_access");
    } catch (e) {
         _logger.e("Error showing paywall if needed: $e");
    }
  }
}
