import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/auth/presentation/phone_input_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/post_creation/presentation/camera_screen.dart';
import '../../features/post_creation/presentation/preview_screen.dart';
import '../../features/chat/presentation/rooms_list_screen.dart';
import '../../features/chat/presentation/chat_room_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn =
          state.matchedLocation == '/otp' || state.matchedLocation == '/';

      if (!isLoggedIn && !isLoggingIn) {
        return '/';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/feed';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const PhoneInputScreen()),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OTPVerificationScreen(),
      ),
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
