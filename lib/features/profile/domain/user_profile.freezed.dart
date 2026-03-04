// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'revive_tokens')
  int get reviveTokens => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_donated_week')
  int get timeDonatedWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_donated_total')
  int get timeDonatedTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'post_count')
  int get postCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'follower_count')
  int get followerCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'following_count')
  int get followingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'donation_streak')
  int get donationStreak => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'revive_tokens') int reviveTokens,
    @JsonKey(name: 'time_donated_week') int timeDonatedWeek,
    @JsonKey(name: 'time_donated_total') int timeDonatedTotal,
    @JsonKey(name: 'post_count') int postCount,
    @JsonKey(name: 'follower_count') int followerCount,
    @JsonKey(name: 'following_count') int followingCount,
    @JsonKey(name: 'donation_streak') int donationStreak,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? reviveTokens = null,
    Object? timeDonatedWeek = null,
    Object? timeDonatedTotal = null,
    Object? postCount = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? donationStreak = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviveTokens: null == reviveTokens
                ? _value.reviveTokens
                : reviveTokens // ignore: cast_nullable_to_non_nullable
                      as int,
            timeDonatedWeek: null == timeDonatedWeek
                ? _value.timeDonatedWeek
                : timeDonatedWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            timeDonatedTotal: null == timeDonatedTotal
                ? _value.timeDonatedTotal
                : timeDonatedTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            postCount: null == postCount
                ? _value.postCount
                : postCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            donationStreak: null == donationStreak
                ? _value.donationStreak
                : donationStreak // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'revive_tokens') int reviveTokens,
    @JsonKey(name: 'time_donated_week') int timeDonatedWeek,
    @JsonKey(name: 'time_donated_total') int timeDonatedTotal,
    @JsonKey(name: 'post_count') int postCount,
    @JsonKey(name: 'follower_count') int followerCount,
    @JsonKey(name: 'following_count') int followingCount,
    @JsonKey(name: 'donation_streak') int donationStreak,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? reviveTokens = null,
    Object? timeDonatedWeek = null,
    Object? timeDonatedTotal = null,
    Object? postCount = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? donationStreak = null,
  }) {
    return _then(
      _$UserProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviveTokens: null == reviveTokens
            ? _value.reviveTokens
            : reviveTokens // ignore: cast_nullable_to_non_nullable
                  as int,
        timeDonatedWeek: null == timeDonatedWeek
            ? _value.timeDonatedWeek
            : timeDonatedWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        timeDonatedTotal: null == timeDonatedTotal
            ? _value.timeDonatedTotal
            : timeDonatedTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        postCount: null == postCount
            ? _value.postCount
            : postCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        donationStreak: null == donationStreak
            ? _value.donationStreak
            : donationStreak // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.username,
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'revive_tokens') this.reviveTokens = 0,
    @JsonKey(name: 'time_donated_week') this.timeDonatedWeek = 0,
    @JsonKey(name: 'time_donated_total') this.timeDonatedTotal = 0,
    @JsonKey(name: 'post_count') this.postCount = 0,
    @JsonKey(name: 'follower_count') this.followerCount = 0,
    @JsonKey(name: 'following_count') this.followingCount = 0,
    @JsonKey(name: 'donation_streak') this.donationStreak = 0,
  });

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'revive_tokens')
  final int reviveTokens;
  @override
  @JsonKey(name: 'time_donated_week')
  final int timeDonatedWeek;
  @override
  @JsonKey(name: 'time_donated_total')
  final int timeDonatedTotal;
  @override
  @JsonKey(name: 'post_count')
  final int postCount;
  @override
  @JsonKey(name: 'follower_count')
  final int followerCount;
  @override
  @JsonKey(name: 'following_count')
  final int followingCount;
  @override
  @JsonKey(name: 'donation_streak')
  final int donationStreak;

  @override
  String toString() {
    return 'UserProfile(id: $id, username: $username, avatarUrl: $avatarUrl, reviveTokens: $reviveTokens, timeDonatedWeek: $timeDonatedWeek, timeDonatedTotal: $timeDonatedTotal, postCount: $postCount, followerCount: $followerCount, followingCount: $followingCount, donationStreak: $donationStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.reviveTokens, reviveTokens) ||
                other.reviveTokens == reviveTokens) &&
            (identical(other.timeDonatedWeek, timeDonatedWeek) ||
                other.timeDonatedWeek == timeDonatedWeek) &&
            (identical(other.timeDonatedTotal, timeDonatedTotal) ||
                other.timeDonatedTotal == timeDonatedTotal) &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.donationStreak, donationStreak) ||
                other.donationStreak == donationStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    avatarUrl,
    reviveTokens,
    timeDonatedWeek,
    timeDonatedTotal,
    postCount,
    followerCount,
    followingCount,
    donationStreak,
  );

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String username,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'revive_tokens') final int reviveTokens,
    @JsonKey(name: 'time_donated_week') final int timeDonatedWeek,
    @JsonKey(name: 'time_donated_total') final int timeDonatedTotal,
    @JsonKey(name: 'post_count') final int postCount,
    @JsonKey(name: 'follower_count') final int followerCount,
    @JsonKey(name: 'following_count') final int followingCount,
    @JsonKey(name: 'donation_streak') final int donationStreak,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'revive_tokens')
  int get reviveTokens;
  @override
  @JsonKey(name: 'time_donated_week')
  int get timeDonatedWeek;
  @override
  @JsonKey(name: 'time_donated_total')
  int get timeDonatedTotal;
  @override
  @JsonKey(name: 'post_count')
  int get postCount;
  @override
  @JsonKey(name: 'follower_count')
  int get followerCount;
  @override
  @JsonKey(name: 'following_count')
  int get followingCount;
  @override
  @JsonKey(name: 'donation_streak')
  int get donationStreak;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
