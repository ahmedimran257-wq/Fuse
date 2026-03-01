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

  Future<List<Post>> getUserPosts(String userId) async {
    final response = await _client
        .from('posts')
        .select()
        .eq('author_id', userId)
        .order('created_at', ascending: false);
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
}
