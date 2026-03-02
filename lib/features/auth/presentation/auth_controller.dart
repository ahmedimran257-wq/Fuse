import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(AuthRepository());
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSub;

  AuthController(this._authRepository) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _authSub = _authRepository.authStateChanges().listen((event) {
      if (event.session != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        );
      } else if (state.status != AuthStatus.emailVerification) {
        // Prevent the stream from violently overwriting the emailVerification state
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      await _authRepository.signUp(email, password);
      state = state.copyWith(
        status: AuthStatus.emailVerification,
        email: email,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      await _authRepository.signIn(email, password);
      // DO NOT set state to authenticated here! The stream handles it securely.
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = AuthState.initial();
  }

  void checkAuthState() {
    final user = _authRepository.getCurrentUser();
    if (user != null && user.emailConfirmedAt != null) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else if (user != null && user.emailConfirmedAt == null) {
      state = state.copyWith(
        status: AuthStatus.emailVerification,
        email: user.email,
      );
    } else {
      state = AuthState.initial();
    }
  }

  void resetError() {
    state = state.copyWith(status: AuthStatus.initial, clearError: true);
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      await _authRepository.resetPassword(email);
      // Reset back to initial so the loading spinner stops
      state = state.copyWith(status: AuthStatus.initial, clearError: true);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
    }
  }

  String _parseError(Object e) {
    if (e is AuthException) {
      final message = e.message.toLowerCase();
      if (message.contains('invalid login credentials')) {
        return 'Incorrect email or password.';
      }
      if (message.contains('email not confirmed')) {
        return 'Please check your inbox to verify your email.';
      }
      if (message.contains('user already registered')) {
        return 'An account with this email already exists.';
      }
      if (message.contains('password should be at least 6 characters')) {
        return 'Password must be at least 6 characters.';
      }
      if (message.contains(
        'unable to validate email address: invalid format',
      )) {
        return 'Please enter a valid email address.';
      }
      return e.message;
    }
    if (e.toString().contains('network') ||
        e.toString().contains('SocketException')) {
      return 'No internet connection. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
