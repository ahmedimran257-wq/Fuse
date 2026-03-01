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
  ChatController(this._repository) : super(const AsyncValue.loading()) {
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repository.fetchMyRooms();
      state = AsyncValue.data(rooms);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
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
}

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((
  ref,
  roomId,
) {
  final repo = ChatRepository();
  return repo.subscribeToMessages(roomId);
});
