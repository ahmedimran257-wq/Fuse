import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // Core App Routes
      GoRoute(path: '/feed', builder: (context, state) => const FeedScreen()),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/preview',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return PreviewScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: '/rooms',
        builder: (context, state) => const RoomsListScreen(),
      ),
      GoRoute(
        path: '/chat/:roomId',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return ChatRoomScreen(roomId: roomId);
        },
      ),
    ],
  );
});
