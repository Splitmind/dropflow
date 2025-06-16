import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // ✅ for debugPrint()

class ShopifyIntegrationService {
  /// Calls Supabase Edge Function to check Shopify-installed apps
  static Future<Map<String, dynamic>?> checkInstalledApps({
    required String shopDomain,
    required String accessToken,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      debugPrint('🛑 User not authenticated.');
      return null;
    }

    final response = await Supabase.instance.client.functions.invoke(
      'check_installed_apps',
      body: {
        'shop_domain': shopDomain,
        'access_token': accessToken,
        'user_id': user.id,
      },
    );

    if (response.status >= 400) {
      debugPrint('❌ Supabase Edge Function error: ${response.data}');
      return null;
    }

    final data = response.data;
    debugPrint('✅ Vendor integration check result: $data');

    return data;
  }

  /// 🔄 Subscribes to real-time updates on shop_integrations for the current user
  static Stream<Map<String, dynamic>> subscribeToIntegrationStatus(
    String userId,
  ) {
    return Supabase.instance.client
        .from('shop_integrations:user_id=eq.$userId')
        .stream(primaryKey: ['user_id'])
        .map((rows) => rows.isNotEmpty ? rows.first : {});
  }

  /// 🔄 Subscribes to real-time updates on shops for the current user
  static Stream<Map<String, dynamic>> subscribeToShop(String userId) {
    return Supabase.instance.client
        .from('shops:user_id=eq.$userId')
        .stream(primaryKey: ['user_id'])
        .map((rows) => rows.isNotEmpty ? rows.first : {});
  }
}
