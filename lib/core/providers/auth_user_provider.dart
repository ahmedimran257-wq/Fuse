import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provides the raw User object (nullable)
final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

// Provides the safe user ID string. Throws a safe state error instead of a fatal null-check crash.
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw StateError(
      'Attempted to access currentUserIdProvider while unauthenticated',
    );
  }
  return user.id;
});
