// Root-level Riverpod providers shared app-wide. Feature-specific
// providers live inside their own feature/ directory.
//
// Sprint 1 repair: Supabase may not be initialized (no `.env` / placeholder
// credentials). No feature may depend on Supabase yet, so the client is
// exposed as nullable — callers must check [supabaseInitializedProvider]
// (or that the value isn't null) before use.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';
import '../core/services/connectivity_service.dart';

/// True only when Supabase was actually initialized with real config.
final supabaseInitializedProvider = Provider<bool>((ref) {
  return SupabaseConfig.isInitialized;
});

/// Nullable on purpose — null means "not initialized", not an error.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  return SupabaseConfig.isInitialized ? SupabaseConfig.client : null;
});

final connectivityServiceProvider = Provider<ConnectivityChecker>((ref) {
  final service = StubConnectivityChecker();
  ref.onDispose(service.dispose);
  return service;
});

final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onStatusChange;
});
