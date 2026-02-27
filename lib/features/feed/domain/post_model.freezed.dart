// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_id')
  String get authorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String? get mediaUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_type')
  String get contentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_duration_seconds')
  int get baseDurationSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiration_timestamp')
  DateTime get expirationTimestamp => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'ever_dead')
  bool get everDead => throw _privateConstructorUsedError;
  @JsonKey(name: 'immortalized_at')
  DateTime? get immortalizedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get comments => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'author_id') String authorId,
    @JsonKey(name: 'media_url') String? mediaUrl,
    @JsonKey(name: 'content_type') String contentType,
    @JsonKey(name: 'base_duration_seconds') int baseDurationSeconds,
    @JsonKey(name: 'expiration_timestamp') DateTime expirationTimestamp,
    String status,
    @JsonKey(name: 'ever_dead') bool everDead,
    @JsonKey(name: 'immortalized_at') DateTime? immortalizedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    int likes,
    int comments,
    int views,
  });
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? mediaUrl = freezed,
    Object? contentType = null,
    Object? baseDurationSeconds = null,
    Object? expirationTimestamp = null,
    Object? status = null,
    Object? everDead = null,
    Object? immortalizedAt = freezed,
    Object? createdAt = null,
    Object? likes = null,
    Object? comments = null,
    Object? views = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaUrl: freezed == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            contentType: null == contentType
                ? _value.contentType
                : contentType // ignore: cast_nullable_to_non_nullable
                      as String,
            baseDurationSeconds: null == baseDurationSeconds
                ? _value.baseDurationSeconds
                : baseDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            expirationTimestamp: null == expirationTimestamp
                ? _value.expirationTimestamp
                : expirationTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            everDead: null == everDead
                ? _value.everDead
                : everDead // ignore: cast_nullable_to_non_nullable
                      as bool,
            immortalizedAt: freezed == immortalizedAt
                ? _value.immortalizedAt
                : immortalizedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as int,
            comments: null == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as int,
            views: null == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
    _$PostImpl value,
    $Res Function(_$PostImpl) then,
  ) = __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'author_id') String authorId,
    @JsonKey(name: 'media_url') String? mediaUrl,
    @JsonKey(name: 'content_type') String contentType,
    @JsonKey(name: 'base_duration_seconds') int baseDurationSeconds,
    @JsonKey(name: 'expiration_timestamp') DateTime expirationTimestamp,
    String status,
    @JsonKey(name: 'ever_dead') bool everDead,
    @JsonKey(name: 'immortalized_at') DateTime? immortalizedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    int likes,
    int comments,
    int views,
  });
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
    : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? mediaUrl = freezed,
    Object? contentType = null,
    Object? baseDurationSeconds = null,
    Object? expirationTimestamp = null,
    Object? status = null,
    Object? everDead = null,
    Object? immortalizedAt = freezed,
    Object? createdAt = null,
    Object? likes = null,
    Object? comments = null,
    Object? views = null,
  }) {
    return _then(
      _$PostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaUrl: freezed == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        contentType: null == contentType
            ? _value.contentType
            : contentType // ignore: cast_nullable_to_non_nullable
                  as String,
        baseDurationSeconds: null == baseDurationSeconds
            ? _value.baseDurationSeconds
            : baseDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        expirationTimestamp: null == expirationTimestamp
            ? _value.expirationTimestamp
            : expirationTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        everDead: null == everDead
            ? _value.everDead
            : everDead // ignore: cast_nullable_to_non_nullable
                  as bool,
        immortalizedAt: freezed == immortalizedAt
            ? _value.immortalizedAt
            : immortalizedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        likes: null == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as int,
        comments: null == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as int,
        views: null == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl extends _Post {
  const _$PostImpl({
    required this.id,
    @JsonKey(name: 'author_id') required this.authorId,
    @JsonKey(name: 'media_url') this.mediaUrl,
    @JsonKey(name: 'content_type') this.contentType = 'image',
    @JsonKey(name: 'base_duration_seconds') this.baseDurationSeconds = 900,
    @JsonKey(name: 'expiration_timestamp') required this.expirationTimestamp,
    required this.status,
    @JsonKey(name: 'ever_dead') this.everDead = false,
    @JsonKey(name: 'immortalized_at') this.immortalizedAt,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.views = 0,
  }) : super._();

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'author_id')
  final String authorId;
  @override
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
  @override
  @JsonKey(name: 'content_type')
  final String contentType;
  @override
  @JsonKey(name: 'base_duration_seconds')
  final int baseDurationSeconds;
  @override
  @JsonKey(name: 'expiration_timestamp')
  final DateTime expirationTimestamp;
  @override
  final String status;
  @override
  @JsonKey(name: 'ever_dead')
  final bool everDead;
  @override
  @JsonKey(name: 'immortalized_at')
  final DateTime? immortalizedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final int comments;
  @override
  @JsonKey()
  final int views;

  @override
  String toString() {
    return 'Post(id: $id, authorId: $authorId, mediaUrl: $mediaUrl, contentType: $contentType, baseDurationSeconds: $baseDurationSeconds, expirationTimestamp: $expirationTimestamp, status: $status, everDead: $everDead, immortalizedAt: $immortalizedAt, createdAt: $createdAt, likes: $likes, comments: $comments, views: $views)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.baseDurationSeconds, baseDurationSeconds) ||
                other.baseDurationSeconds == baseDurationSeconds) &&
            (identical(other.expirationTimestamp, expirationTimestamp) ||
                other.expirationTimestamp == expirationTimestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.everDead, everDead) ||
                other.everDead == everDead) &&
            (identical(other.immortalizedAt, immortalizedAt) ||
                other.immortalizedAt == immortalizedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.views, views) || other.views == views));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorId,
    mediaUrl,
    contentType,
    baseDurationSeconds,
    expirationTimestamp,
    status,
    everDead,
    immortalizedAt,
    createdAt,
    likes,
    comments,
    views,
  );

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(this);
  }
}

abstract class _Post extends Post {
  const factory _Post({
    required final String id,
    @JsonKey(name: 'author_id') required final String authorId,
    @JsonKey(name: 'media_url') final String? mediaUrl,
    @JsonKey(name: 'content_type') final String contentType,
    @JsonKey(name: 'base_duration_seconds') final int baseDurationSeconds,
    @JsonKey(name: 'expiration_timestamp')
    required final DateTime expirationTimestamp,
    required final String status,
    @JsonKey(name: 'ever_dead') final bool everDead,
    @JsonKey(name: 'immortalized_at') final DateTime? immortalizedAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final int likes,
    final int comments,
    final int views,
  }) = _$PostImpl;
  const _Post._() : super._();

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'author_id')
  String get authorId;
  @override
  @JsonKey(name: 'media_url')
  String? get mediaUrl;
  @override
  @JsonKey(name: 'content_type')
  String get contentType;
  @override
  @JsonKey(name: 'base_duration_seconds')
  int get baseDurationSeconds;
  @override
  @JsonKey(name: 'expiration_timestamp')
  DateTime get expirationTimestamp;
  @override
  String get status;
  @override
  @JsonKey(name: 'ever_dead')
  bool get everDead;
  @override
  @JsonKey(name: 'immortalized_at')
  DateTime? get immortalizedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  int get likes;
  @override
  int get comments;
  @override
  int get views;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
