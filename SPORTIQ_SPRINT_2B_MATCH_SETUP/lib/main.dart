import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/config/env_config.dart';
import 'core/config/supabase_config.dart';
import 'core/services/logger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await EnvConfig.load();
    await SupabaseConfig.initialize();
  } catch (e, stackTrace) {
    AppLogger.error('Startup initialization failed', e, stackTrace);
  }

  runApp(const ProviderScope(child: SportiqApp()));
}
