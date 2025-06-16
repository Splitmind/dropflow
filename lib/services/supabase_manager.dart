import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/constants.dart';

class SupabaseManager {
  static Future<void> init() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static final SupabaseClient client = Supabase.instance.client;
}
