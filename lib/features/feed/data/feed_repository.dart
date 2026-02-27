import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/core/network/supabase_client.dart';
import '../domain/post_model.dart';

class FeedRepository {
  final SupabaseClient _client;

  FeedRepository(this._client);

  // Fetch initial alive posts
  Future<List<Post>> fetchAlivePosts() async {
    final response = await _client
        .from('posts')
        .select()
        .eq('status', 'alive')
        .order('created_at', ascending: false);

    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  // Real-time subscription for new posts and updates
  Stream<List<Post>> subscribeToPosts() {
    return _client
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('status', 'alive')
        .order('created_at', ascending: false)
        .map((events) => events.map((json) => Post.fromJson(json)).toList());
  }

  // Like a post (call RPC)
  Future<void> likePost(String postId) async {
    await _client.rpc(
      'add_interaction',
      params: {'p_post_id': postId, 'p_type': 'like'},
    );
  }

  // Comment on a post (call RPC)
  Future<void> commentOnPost(String postId, String comment) async {
    await _client.rpc(
      'add_interaction',
      params: {'p_post_id': postId, 'p_type': 'comment', 'p_content': comment},
    );
  }

  // View post (call RPC)
  Future<void> viewPost(String postId) async {
    await _client.rpc(
      'add_interaction',
      params: {'p_post_id': postId, 'p_type': 'view'},
    );
  }
}

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(SupabaseClientWrapper.instance);
});

final feedStreamProvider = StreamProvider<List<Post>>((ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.subscribeToPosts();
});
