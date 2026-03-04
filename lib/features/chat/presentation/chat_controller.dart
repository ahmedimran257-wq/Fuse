import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository.dart';
import '../domain/chat_room.dart';
import '../domain/chat_message.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<List<ChatRoom>>>((ref) {
      return ChatController(ref.watch(chatRepositoryProvider));
    });

class ChatController extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  final ChatRepository _repository;
  Timer? _refreshTimer;

  ChatController(this._repository) : super(const AsyncValue.loading()) {
    _loadRooms();
    // Periodically refresh rooms to catch expirations and new rooms
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadRooms(),
    );
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repository.fetchMyRooms();
      if (mounted) state = AsyncValue.data(rooms);
    } catch (e, stack) {
      if (mounted) state = AsyncValue.error(e, stack);
    }
  }

  Future<ChatRoom> createRoom(String name) async {
    final room = await _repository.createRoom(name);
    await _loadRooms(); // refresh
    return room;
  }

  Future<void> joinRoom(String roomId) async {
    await _repository.joinRoom(roomId);
    await _loadRooms();
  }

  Future<void> sendMessage(String roomId, String content) async {
    await _repository.sendMessage(roomId, content);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

// CRIT-03 FIX: Use injected repository, not raw ChatRepository()
final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((
  ref,
  roomId,
) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.subscribeToMessages(roomId);
});

// BUG-13/16 FIX: Dedicated provider for a single room (works for deep links)
final singleRoomProvider = FutureProvider.family<ChatRoom, String>((
  ref,
  roomId,
) {
  return ref.watch(chatRepositoryProvider).getRoom(roomId);
});
