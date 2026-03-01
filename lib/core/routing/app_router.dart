import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_animations.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/domain/auth_state.dart';

// 1. We bring back your sleek Email/Password screens
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
import 'main_scaffold.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
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

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation:
        '/login', // 2. Set the starting point to your SignIn screen
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // 1. If they are not logged in, force them to login
      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      // If the link is a deep link, parse it explicitly to ensure robust routing
      if (state.uri.path.startsWith('/post/')) {
        final postId = state.uri.pathSegments.last;
        // We navigate to our dedicated complete SinglePostScreen
        if (state.matchedLocation != '/post/$postId') {
          return '/post/$postId';
        }
        return null;
      }
      if (state.uri.path.startsWith('/chat/')) {
        final roomId = state.uri.pathSegments.last;
        if (state.matchedLocation != '/chat/$roomId') {
          return '/chat/$roomId';
        }
        return null;
      }

      // 2. If they ARE logged in, and they try to go to the login screen OR the root route ('/'),
      // forcefully push them into the Feed.
      if (isLoggedIn && (isLoggingIn || state.matchedLocation == '/')) {
        return '/feed';
      }

      return null;
    },
    routes: [
      // 3. Register your actual Auth routes
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SignUpScreen(),
        ),
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
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
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
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const RoomsListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/camera',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const CameraScreen(),
        ),
      ),
      GoRoute(
        path: '/preview',
        pageBuilder: (context, state) {
          final imagePath = state.extra as String;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: PreviewScreen(imagePath: imagePath),
          );
        },
      ),
      GoRoute(
        path: '/post/:postId',
        pageBuilder: (context, state) {
          final id = state.pathParameters['postId']!;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: SinglePostScreen(postId: id),
          );
        },
      ),
      GoRoute(
        path: '/chat/:roomId',
        pageBuilder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ChatRoomScreen(roomId: roomId),
          );
        },
      ),
      GoRoute(
        path: '/immortal_posts',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ImmortalPostsScreen(),
        ),
      ),
    ],
  );
});
