import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class Post with _$Post {
  const Post._();

  const factory Post({
    required String id,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'media_url') String? mediaUrl,
    @JsonKey(name: 'content_type') @Default('image') String contentType,
    @JsonKey(name: 'base_duration_seconds')
    @Default(900)
    int baseDurationSeconds,
    @JsonKey(name: 'expiration_timestamp')
    required DateTime expirationTimestamp,
    required String status,
    @JsonKey(name: 'ever_dead') @Default(false) bool everDead,
    @JsonKey(name: 'immortalized_at') DateTime? immortalizedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int views,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  int get remainingSeconds => expirationTimestamp
      .difference(DateTime.now())
      .inSeconds
      .clamp(0, baseDurationSeconds);
}
