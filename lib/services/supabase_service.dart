import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  /// Checks if the user has an access_token in the shops table
  static Future<bool> isShopifyConnected() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final result = await _client
        .from('shops')
        .select('access_token')
        .eq('user_id', user.id)
        .maybeSingle();

    return result != null && result['access_token'] != null;
  }

  /// Checks if Spocket was detected in the integrations table
  static Future<bool> isSpocketDetected() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final result = await _client
        .from('integrations')
        .select('spocket_ready')
        .eq('user_id', user.id)
        .maybeSingle();

    return result != null && result['spocket_ready'] == true;
  }

  /// Fetches the user's current shop connection record
  static Future<Map<String, dynamic>?> getShopConnection() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final result = await _client
        .from('shops')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return result;
  }

  /// Saves or updates the user's Shopify connection info
  static Future<void> saveShopConnection({
    required String shopDomain,
    required String accessToken,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('shops').upsert({
      'user_id': user.id,
      'shop_domain': shopDomain,
      'access_token': accessToken,
    });
  }

  /// Updates or creates the user's vendor integration status
  static Future<void> updateSpocketStatus({required bool isInstalled}) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('integrations').upsert({
      'user_id': user.id,
      'spocket_ready': isInstalled,
      'updated_at': DateTime.now()
          .toIso8601String(), // optional if your table includes it
    });
  }
}
