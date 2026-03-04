import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/core/network/supabase_client.dart';
import '../domain/post_model.dart';
import '../domain/comment_model.dart';

class FeedRepository {
  final SupabaseClient _client;

  FeedRepository(this._client);

  // Fetch a single post
  Future<Post> getPost(String postId) async {
    final response = await _client
        .from('posts')
        .select()
        .eq('id', postId)
        .single();
    return Post.fromJson(response);
  }

  // 1. The Paginated Join Query (Fetches Post + Author Profile)
  Future<List<Post>> fetchAlivePosts({int page = 0, int pageSize = 20}) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;
    final response = await _client
        .from('posts')
        .select(
          '*, profiles!author_id(id, username, avatar_url)',
        ) // JOIN MAGIC HERE!
        .eq('status', 'alive')
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  // 2. The Bulletproof Realtime Channel
  Stream<List<Post>> subscribeToPosts() {
    final controller = StreamController<List<Post>>.broadcast();

    // Fire the initial load instantly
    fetchAlivePosts()
        .then((posts) {
          if (!controller.isClosed) controller.add(posts);
        })
        .catchError((e) {
          if (!controller.isClosed) controller.addError(e);
        });

    // Listen to changes quietly in the background
    final channel = _client
        .channel('public:posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'posts',
          callback: (payload) async {
            // Whenever ANY post is liked, killed, or created, quietly fetch the fresh joined data
            if (!controller.isClosed) {
              final posts = await fetchAlivePosts();
              controller.add(posts);
            }
          },
        )
        .subscribe();

    // Clean up connection to save battery
    controller.onCancel = () {
      _client.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  // Real-time subscription for immortal posts
  Stream<List<Post>> subscribeToImmortalPosts() {
    return _client
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('status', 'immortal')
        .order('created_at', ascending: false)
        .map((events) => events.map((json) => Post.fromJson(json)).toList());
  }

  // Real-time subscription for a single post
  Stream<Post> subscribeToSinglePost(String postId) {
    return _client
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('id', postId)
        .map((rows) {
          if (rows.isEmpty) throw Exception('Post not found');
          return Post.fromJson(rows.first);
        });
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

  Future<void> deletePost(String postId) async {
    // Delete the row from the database (Supabase RLS ensures they can only delete their own)
    await _client.from('posts').delete().eq('id', postId);
  }

  Future<void> donateTime(String postId, {int seconds = 30}) async {
    // Triggers the backend RPC to add time and update the user's donation stats
    await _client.rpc(
      'donate_time',
      params: {'p_post_id': postId, 'p_seconds': seconds},
    );
  }

  Stream<List<Comment>> subscribeToComments(String postId) {
    return _client
        .from('post_interactions')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true) // Oldest at top, newest at bottom
        .map(
          (rows) => rows
              .where((j) => j['type'] == 'comment')
              .map((j) => Comment.fromJson(j))
              .toList(),
        );
  }

  Future<void> addComment(String postId, String userId, String text) async {
    await _client.from('post_interactions').insert({
      'post_id': postId,
      'user_id': userId,
      'type': 'comment',
      'content': text,
    });
  }

  Future<void> reportPost(String userId, String postId, String reason) async {
    await _client.from('reports').insert({
      'reporter_id': userId,
      'post_id': postId,
      'reason': reason,
    });
  }
}

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(SupabaseClientWrapper.instance);
});

final feedStreamProvider = StreamProvider<List<Post>>((ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.subscribeToPosts();
});

final immortalPostsProvider = StreamProvider<List<Post>>((ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.subscribeToImmortalPosts();
});
