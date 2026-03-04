import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  const ChatRoom._(); // Required to add custom getters to a Freezed class

  const factory ChatRoom({
    required String id,
    @JsonKey(name: 'room_name') required String roomName,
    @JsonKey(name: 'creator_id') required String creatorId,
    @JsonKey(name: 'expiration_timestamp')
    required DateTime expirationTimestamp,
    @JsonKey(name: 'max_expiration_timestamp')
    required DateTime maxExpirationTimestamp,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  int get remainingSeconds {
    final diff = expirationTimestamp
        .difference(DateTime.now().toUtc())
        .inSeconds;
    return diff > 0 ? diff : 0;
  }

  int get totalSeconds {
    return maxExpirationTimestamp.difference(createdAt).inSeconds;
  }
}
