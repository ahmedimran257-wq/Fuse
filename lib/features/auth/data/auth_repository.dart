import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Sign up with email & password
  Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
    // Note: Email confirmation may be required depending on your Supabase settings.
  }

  // Sign in with email & password
  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Get current user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Stream auth state
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }
}
