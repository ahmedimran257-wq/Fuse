import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(AuthRepository());
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _authRepository.authStateChanges().listen((event) {
      final session = event.session;
      if (session != null) {
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signUp(email, password);
      // After sign-up, user may need to verify email
      state = state.copyWith(
        status: AuthStatus.emailVerification,
        email: email,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signIn(email, password);
      state = state.copyWith(status: AuthStatus.authenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
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
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }
}
