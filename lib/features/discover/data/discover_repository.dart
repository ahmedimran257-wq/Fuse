import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/domain/user_profile.dart';

final discoverRepositoryProvider = Provider((ref) => DiscoverRepository());

class DiscoverRepository {
  final _client = Supabase.instance.client;

  // Search users by username
  Future<List<UserProfile>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final response = await _client
        .from('profiles')
        .select()
        .ilike(
          'username',
          '%${query.trim()}%',
        ) // Case-insensitive partial match
        .limit(20);

    return (response as List)
        .map((json) => UserProfile.fromJson(json))
        .toList();
  }

  // Get Top Saviors (Leaderboard)
  Future<List<UserProfile>> getTopSaviors() async {
    final response = await _client
        .from('profiles')
        .select()
        .order('time_donated_week', ascending: false)
        .limit(20);

    return (response as List)
        .map((json) => UserProfile.fromJson(json))
        .toList();
  }
}
