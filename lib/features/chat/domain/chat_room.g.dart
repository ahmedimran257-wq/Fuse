// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomImpl _$$ChatRoomImplFromJson(
  Map<String, dynamic> json,
) => _$ChatRoomImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  expirationTimestamp: DateTime.parse(json['expiration_timestamp'] as String),
  baseDurationSeconds: (json['base_duration_seconds'] as num?)?.toInt() ?? 300,
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$$ChatRoomImplToJson(_$ChatRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'expiration_timestamp': instance.expirationTimestamp.toIso8601String(),
      'base_duration_seconds': instance.baseDurationSeconds,
      'status': instance.status,
    };
