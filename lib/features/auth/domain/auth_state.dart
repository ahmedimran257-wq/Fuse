enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  emailVerification,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? email; // store email for verification step

  AuthState({required this.status, this.errorMessage, this.email});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }
}
