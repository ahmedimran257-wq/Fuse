// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomImpl _$$ChatRoomImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomImpl(
      id: json['id'] as String,
      roomName: json['room_name'] as String,
      creatorId: json['creator_id'] as String,
      expirationTimestamp: DateTime.parse(
        json['expiration_timestamp'] as String,
      ),
      maxExpirationTimestamp: DateTime.parse(
        json['max_expiration_timestamp'] as String,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ChatRoomImplToJson(
  _$ChatRoomImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'room_name': instance.roomName,
  'creator_id': instance.creatorId,
  'expiration_timestamp': instance.expirationTimestamp.toIso8601String(),
  'max_expiration_timestamp': instance.maxExpirationTimestamp.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
