class UserProfile {
  final String id;
  final String username;
  final int timeDonatedWeek;
  final int timeDonatedTotal;
  final int reviveTokens;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.timeDonatedWeek,
    required this.timeDonatedTotal,
    required this.reviveTokens,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      timeDonatedWeek: json['time_donated_week'] ?? 0,
      timeDonatedTotal: json['time_donated_total'] ?? 0,
      reviveTokens: json['revive_tokens'] ?? 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
