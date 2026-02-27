import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_room.dart';
import 'chat_message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatRoom> rooms,
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ChatState;
}
