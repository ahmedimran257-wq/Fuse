import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_animations.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/domain/auth_state.dart';

import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';

import '../../features/feed/presentation/feed_screen.dart';
import '../../features/post_creation/presentation/camera_screen.dart';
import '../../features/post_creation/presentation/preview_screen.dart';
import '../../features/chat/presentation/rooms_list_screen.dart';
import '../../features/chat/presentation/chat_room_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/feed/presentation/single_post_screen.dart';
import '../../features/profile/presentation/immortal_posts_screen.dart';
import '../../features/feed/presentation/comments_screen.dart';
import '../../features/profile/presentation/public_profile_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/discover/presentation/leaderboard_screen.dart';
import '../../features/discover/presentation/discover_screen.dart';
import 'main_scaffold.dart';

// ── Transition builders ──

/// Crossfade for tab switches
CustomTransitionPage buildFadeTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(
          curve: AppAnimations.easeOutExpo,
        ).animate(animation),
        child: child,
      );
    },
  );
}

/// Slide from right for detail/push screens
CustomTransitionPage buildSlideTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

/// Slide up for creation flow (camera, preview)
CustomTransitionPage buildSlideUpTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeAnimation = Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: fadeAnimation, child: child),
      );
    },
  );
}

// ── Router Notifier for auth refresh ──
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        return '/splash';
      }

      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      if (isLoggedIn) {
        if (isLoggingIn || state.matchedLocation == '/') {
          return '/feed';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            buildFadeTransition(state: state, child: const SignInScreen()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            buildSlideTransition(state: state, child: const SignUpScreen()),
      ),

      // Core App Routes with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feed',
                pageBuilder: (context, state) => buildFadeTransition(
                  state: state,
                  child: const FeedScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rooms',
                pageBuilder: (context, state) => buildFadeTransition(
                  state: state,
                  child: const RoomsListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/camera',
                pageBuilder: (context, state) => buildSlideUpTransition(
                  state: state,
                  child: const CameraScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                pageBuilder: (context, state) => buildFadeTransition(
                  state: state,
                  child: const DiscoverScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => buildFadeTransition(
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Detail screens: slide from right
      GoRoute(
        path: '/preview',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return buildSlideUpTransition(
            state: state,
            child: PreviewScreen(
              imagePath: extra['path']!,
              contentType: extra['type'] ?? 'image',
            ),
          );
        },
      ),
      GoRoute(
        path: '/post/:postId',
        pageBuilder: (context, state) {
          final id = state.pathParameters['postId']!;
          return buildSlideTransition(
            state: state,
            child: SinglePostScreen(postId: id),
          );
        },
      ),
      GoRoute(
        path: '/chat/:roomId',
        pageBuilder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return buildSlideTransition(
            state: state,
            child: ChatRoomScreen(roomId: roomId),
          );
        },
      ),
      GoRoute(
        path: '/immortal_posts',
        pageBuilder: (context, state) => buildSlideTransition(
          state: state,
          child: const ImmortalPostsScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        pageBuilder: (context, state) {
          final targetUserId = state.pathParameters['userId']!;
          return buildSlideTransition(
            state: state,
            child: PublicProfileScreen(targetUserId: targetUserId),
          );
        },
      ),
      GoRoute(
        path: '/comments/:postId',
        pageBuilder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return buildSlideUpTransition(
            state: state,
            child: CommentsScreen(postId: postId),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            buildSlideTransition(state: state, child: const SettingsScreen()),
      ),
      GoRoute(
        path: '/leaderboard',
        pageBuilder: (context, state) => buildSlideTransition(
          state: state,
          child: const LeaderboardScreen(),
        ),
      ),
    ],
  );
});
