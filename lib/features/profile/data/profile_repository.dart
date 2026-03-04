import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../feed/domain/post_model.dart';
import '../domain/user_profile.dart';

class ProfileRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return UserProfile.fromJson(response);
  }

  Future<List<Post>> getUserPosts(
    String userId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;
    final response = await _client
        .from('posts')
        .select()
        .eq('author_id', userId)
        .order('created_at', ascending: false)
        .range(from, to);
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<void> useReviveToken(String postId) async {
    await _client.rpc('revive_post', params: {'target_post_id': postId});
  }

  Future<void> updateUsername(String newUsername) async {
    final userId = _client.auth.currentUser!.id;
    await _client
        .from('profiles')
        .update({'username': newUsername})
        .eq('id', userId);
  }

  Future<void> uploadAvatar(String userId, String filePath) async {
    final file = File(filePath);
    final ext = file.path.split('.').last;
    final fileName = '$userId/avatar.$ext';

    // Upload to storage
    await _client.storage
        .from('avatars')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    // Get public URL and update profile row
    final publicUrl = _client.storage.from('avatars').getPublicUrl(fileName);
    await _client
        .from('profiles')
        .update({'avatar_url': publicUrl})
        .eq('id', userId);
  }

  Future<bool> checkIsFollowing(
    String currentUserId,
    String targetUserId,
  ) async {
    final response = await _client
        .from('follows')
        .select('id')
        .eq('follower_id', currentUserId)
        .eq('following_id', targetUserId)
        .maybeSingle();
    return response != null;
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _client.from('follows').insert({
      'follower_id': currentUserId,
      'following_id': targetUserId,
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _client
        .from('follows')
        .delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', targetUserId);
  }

  Future<void> blockUser(String blockerId, String blockedId) async {
    // Insert block record. You can later create a Postgres View to filter out blocked users' posts.
    await _client.from('blocks').insert({
      'blocker_id': blockerId,
      'blocked_id': blockedId,
    });
  }

  Future<void> reportUser(
    String reporterId,
    String targetUserId,
    String reason,
  ) async {
    await _client.from('reports').insert({
      'reporter_id': reporterId,
      'user_id': targetUserId,
      'reason': reason,
    });
  }
}
