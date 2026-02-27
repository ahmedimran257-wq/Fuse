// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  id: json['id'] as String,
  authorId: json['author_id'] as String,
  mediaUrl: json['media_url'] as String?,
  contentType: json['content_type'] as String? ?? 'image',
  baseDurationSeconds: (json['base_duration_seconds'] as num?)?.toInt() ?? 900,
  expirationTimestamp: DateTime.parse(json['expiration_timestamp'] as String),
  status: json['status'] as String,
  everDead: json['ever_dead'] as bool? ?? false,
  immortalizedAt: json['immortalized_at'] == null
      ? null
      : DateTime.parse(json['immortalized_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  comments: (json['comments'] as num?)?.toInt() ?? 0,
  views: (json['views'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'media_url': instance.mediaUrl,
      'content_type': instance.contentType,
      'base_duration_seconds': instance.baseDurationSeconds,
      'expiration_timestamp': instance.expirationTimestamp.toIso8601String(),
      'status': instance.status,
      'ever_dead': instance.everDead,
      'immortalized_at': instance.immortalizedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
      'comments': instance.comments,
      'views': instance.views,
    };
