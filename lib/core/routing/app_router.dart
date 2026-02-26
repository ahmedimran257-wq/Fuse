import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isAuthRoute =
          state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup';
      if (!isLoggedIn && !isAuthRoute) {
        return '/signin';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/feed';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(path: '/feed', builder: (context, state) => const FeedScreen()),
      // Map root to feed if authenticated via redirect
      GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
    ],
  );
});
