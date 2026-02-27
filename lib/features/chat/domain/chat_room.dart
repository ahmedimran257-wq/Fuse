import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  const ChatRoom._();

  const factory ChatRoom({
    required String id,
    required String name,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expiration_timestamp')
    required DateTime expirationTimestamp,
    @JsonKey(name: 'base_duration_seconds')
    @Default(300)
    int baseDurationSeconds,
    @Default('active') String status,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  int get remainingSeconds => expirationTimestamp
      .difference(DateTime.now())
      .inSeconds
      .clamp(0, baseDurationSeconds * 2);
}
