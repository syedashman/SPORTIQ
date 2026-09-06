// Initializes the Supabase client — but only when real, non-placeholder
// credentials are present (see [EnvConfig.isSupabaseConfigured]).
//
// Sprint 1 repair: no feature may depend on Supabase yet, and the app
// must boot fine with no `.env` at all. [initialize] is a no-op (with one
// warning log) when config is missing, and [client] is only safe to call
// after [isInitialized] is true.
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';
import '../services/logger_service.dart';

abstract class SupabaseConfig {
  SupabaseConfig._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (!EnvConfig.isSupabaseConfigured) {
      AppLogger.warning(
        'Supabase not configured (missing/placeholder SUPABASE_URL or SUPABASE_ANON_KEY) — skipping initialization.',
      );
      return;
    }

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
    );
    _initialized = true;
  }

  /// Only valid when [isInitialized] is true — check before calling in any
  /// future feature code.
  static SupabaseClient get client => Supabase.instance.client;
}
