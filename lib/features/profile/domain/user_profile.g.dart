// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      reviveTokens: (json['revive_tokens'] as num?)?.toInt() ?? 0,
      timeDonatedWeek: (json['time_donated_week'] as num?)?.toInt() ?? 0,
      timeDonatedTotal: (json['time_donated_total'] as num?)?.toInt() ?? 0,
      postCount: (json['post_count'] as num?)?.toInt() ?? 0,
      followerCount: (json['follower_count'] as num?)?.toInt() ?? 0,
      followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
      donationStreak: (json['donation_streak'] as num?)?.toInt() ?? 0,
      fuseEnergy: (json['fuse_energy'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'revive_tokens': instance.reviveTokens,
      'time_donated_week': instance.timeDonatedWeek,
      'time_donated_total': instance.timeDonatedTotal,
      'post_count': instance.postCount,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'donation_streak': instance.donationStreak,
      'fuse_energy': instance.fuseEnergy,
    };
