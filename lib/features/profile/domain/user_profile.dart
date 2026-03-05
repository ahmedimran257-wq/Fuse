import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'revive_tokens') @Default(0) int reviveTokens,
    @JsonKey(name: 'time_donated_week') @Default(0) int timeDonatedWeek,
    @JsonKey(name: 'time_donated_total') @Default(0) int timeDonatedTotal,
    @JsonKey(name: 'post_count') @Default(0) int postCount,
    @JsonKey(name: 'follower_count') @Default(0) int followerCount,
    @JsonKey(name: 'following_count') @Default(0) int followingCount,
    @JsonKey(name: 'donation_streak') @Default(0) int donationStreak,
    @JsonKey(name: 'fuse_energy') @Default(0) int fuseEnergy,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
