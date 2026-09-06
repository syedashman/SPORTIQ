// Centralized and typed environment configuration.
//
// Foundation-safe behavior:
// - If `.env` exists, it is loaded.
// - If `.env` is missing, the app continues without crashing.
// - Empty or placeholder Supabase credentials are treated as unconfigured.

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/logger_service.dart';

abstract class EnvConfig {
  EnvConfig._();

  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      _loaded = true;
    } catch (_) {
      _loaded = false;

      AppLogger.warning(
        '.env not found — continuing in local foundation mode.',
      );
    }
  }

  static String get supabaseUrl {
    if (!_loaded) {
      return '';
    }

    return dotenv.get('SUPABASE_URL', fallback: '');
  }

  static String get supabaseAnonKey {
    if (!_loaded) {
      return '';
    }

    return dotenv.get('SUPABASE_ANON_KEY', fallback: '');
  }

  static String get environment {
    if (!_loaded) {
      return 'development';
    }

    return dotenv.get('ENV', fallback: 'development');
  }

  static bool get isProduction {
    return environment == 'production';
  }

  static bool get isDevelopment {
    return environment == 'development';
  }

  static bool get isSupabaseConfigured {
    final url = supabaseUrl.trim();
    final key = supabaseAnonKey.trim();

    if (url.isEmpty || key.isEmpty) {
      return false;
    }

    if (url.contains('your-project') ||
        key.contains('your-anon-key') ||
        key.contains('your-publishable-key')) {
      return false;
    }

    return true;
  }
}
