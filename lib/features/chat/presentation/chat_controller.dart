import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository.dart';
import '../domain/chat_state.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatController extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _roomsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatController(this._repository) : super(const ChatState()) {
    _initRoomsStream();
  }

  void _initRoomsStream() {
    _roomsSubscription?.cancel();
    _roomsSubscription = _repository.subscribeToRooms().listen(
      (rooms) {
        state = state.copyWith(rooms: rooms, isLoading: false);
      },
      onError: (error) {
        state = state.copyWith(
          errorMessage: error.toString(),
          isLoading: false,
        );
      },
    );
  }

  void enterRoom(String roomId) {
    state = state.copyWith(messages: [], isLoading: true);
    _messagesSubscription?.cancel();
    _messagesSubscription = _repository
        .subscribeToMessages(roomId)
        .listen(
          (messages) {
            state = state.copyWith(messages: messages, isLoading: false);
          },
          onError: (error) {
            state = state.copyWith(
              errorMessage: error.toString(),
              isLoading: false,
            );
          },
        );
    _repository.joinRoom(roomId);
  }

  Future<void> createRoom(String name) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.createRoom(name);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> sendMessage(String roomId, String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _repository.sendMessage(roomId, text.trim());
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  @override
  void dispose() {
    _roomsSubscription?.cancel();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatController(repository);
  },
);
