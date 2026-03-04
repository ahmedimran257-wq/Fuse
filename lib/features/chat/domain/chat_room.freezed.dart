// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return _ChatRoom.fromJson(json);
}

/// @nodoc
mixin _$ChatRoom {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_name')
  String get roomName => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  String get creatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiration_timestamp')
  DateTime get expirationTimestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_expiration_timestamp')
  DateTime get maxExpirationTimestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatRoom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) then) =
      _$ChatRoomCopyWithImpl<$Res, ChatRoom>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'room_name') String roomName,
    @JsonKey(name: 'creator_id') String creatorId,
    @JsonKey(name: 'expiration_timestamp') DateTime expirationTimestamp,
    @JsonKey(name: 'max_expiration_timestamp') DateTime maxExpirationTimestamp,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res, $Val extends ChatRoom>
    implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomName = null,
    Object? creatorId = null,
    Object? expirationTimestamp = null,
    Object? maxExpirationTimestamp = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            roomName: null == roomName
                ? _value.roomName
                : roomName // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorId: null == creatorId
                ? _value.creatorId
                : creatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            expirationTimestamp: null == expirationTimestamp
                ? _value.expirationTimestamp
                : expirationTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            maxExpirationTimestamp: null == maxExpirationTimestamp
                ? _value.maxExpirationTimestamp
                : maxExpirationTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatRoomImplCopyWith<$Res>
    implements $ChatRoomCopyWith<$Res> {
  factory _$$ChatRoomImplCopyWith(
    _$ChatRoomImpl value,
    $Res Function(_$ChatRoomImpl) then,
  ) = __$$ChatRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'room_name') String roomName,
    @JsonKey(name: 'creator_id') String creatorId,
    @JsonKey(name: 'expiration_timestamp') DateTime expirationTimestamp,
    @JsonKey(name: 'max_expiration_timestamp') DateTime maxExpirationTimestamp,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$ChatRoomImplCopyWithImpl<$Res>
    extends _$ChatRoomCopyWithImpl<$Res, _$ChatRoomImpl>
    implements _$$ChatRoomImplCopyWith<$Res> {
  __$$ChatRoomImplCopyWithImpl(
    _$ChatRoomImpl _value,
    $Res Function(_$ChatRoomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomName = null,
    Object? creatorId = null,
    Object? expirationTimestamp = null,
    Object? maxExpirationTimestamp = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ChatRoomImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        roomName: null == roomName
            ? _value.roomName
            : roomName // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        expirationTimestamp: null == expirationTimestamp
            ? _value.expirationTimestamp
            : expirationTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        maxExpirationTimestamp: null == maxExpirationTimestamp
            ? _value.maxExpirationTimestamp
            : maxExpirationTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomImpl extends _ChatRoom {
  const _$ChatRoomImpl({
    required this.id,
    @JsonKey(name: 'room_name') required this.roomName,
    @JsonKey(name: 'creator_id') required this.creatorId,
    @JsonKey(name: 'expiration_timestamp') required this.expirationTimestamp,
    @JsonKey(name: 'max_expiration_timestamp')
    required this.maxExpirationTimestamp,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$ChatRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'room_name')
  final String roomName;
  @override
  @JsonKey(name: 'creator_id')
  final String creatorId;
  @override
  @JsonKey(name: 'expiration_timestamp')
  final DateTime expirationTimestamp;
  @override
  @JsonKey(name: 'max_expiration_timestamp')
  final DateTime maxExpirationTimestamp;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatRoom(id: $id, roomName: $roomName, creatorId: $creatorId, expirationTimestamp: $expirationTimestamp, maxExpirationTimestamp: $maxExpirationTimestamp, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roomName, roomName) ||
                other.roomName == roomName) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.expirationTimestamp, expirationTimestamp) ||
                other.expirationTimestamp == expirationTimestamp) &&
            (identical(other.maxExpirationTimestamp, maxExpirationTimestamp) ||
                other.maxExpirationTimestamp == maxExpirationTimestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    roomName,
    creatorId,
    expirationTimestamp,
    maxExpirationTimestamp,
    createdAt,
  );

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      __$$ChatRoomImplCopyWithImpl<_$ChatRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomImplToJson(this);
  }
}

abstract class _ChatRoom extends ChatRoom {
  const factory _ChatRoom({
    required final String id,
    @JsonKey(name: 'room_name') required final String roomName,
    @JsonKey(name: 'creator_id') required final String creatorId,
    @JsonKey(name: 'expiration_timestamp')
    required final DateTime expirationTimestamp,
    @JsonKey(name: 'max_expiration_timestamp')
    required final DateTime maxExpirationTimestamp,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$ChatRoomImpl;
  const _ChatRoom._() : super._();

  factory _ChatRoom.fromJson(Map<String, dynamic> json) =
      _$ChatRoomImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'room_name')
  String get roomName;
  @override
  @JsonKey(name: 'creator_id')
  String get creatorId;
  @override
  @JsonKey(name: 'expiration_timestamp')
  DateTime get expirationTimestamp;
  @override
  @JsonKey(name: 'max_expiration_timestamp')
  DateTime get maxExpirationTimestamp;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
