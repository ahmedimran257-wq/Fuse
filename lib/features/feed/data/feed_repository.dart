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

  // Fetch top 10 trending posts (most likes)
  Future<List<Post>> fetchTrendingPosts() async {
    final response = await _client
        .from('posts')
        .select('*, profiles!author_id(id, username, avatar_url)')
        .eq('status', 'alive')
        .order('likes', ascending: false)
        .limit(10);
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  // Fetch top 10 dying posts (closest to expiration)
  Future<List<Post>> fetchDyingPosts() async {
    final response = await _client
        .from('posts')
        .select('*, profiles!author_id(id, username, avatar_url)')
        .eq('status', 'alive')
        .gt('expiration_timestamp', DateTime.now().toUtc().toIso8601String())
        .order('expiration_timestamp', ascending: true)
        .limit(10);
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  // 2. The Bulletproof Realtime Channel
  Stream<List<Post>> subscribeToPosts({int limit = 10}) {
    final controller = StreamController<List<Post>>.broadcast();

    Future<void> fetchPosts() async {
      try {
        final response = await _client
            .from('posts')
            .select('*, profiles!author_id(id, username, avatar_url)')
            .eq('status', 'alive')
            .order('created_at', ascending: false)
            .limit(limit);
        if (!controller.isClosed) {
          controller.add(
            (response as List).map((j) => Post.fromJson(j)).toList(),
          );
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    // Fire the initial load instantly
    fetchPosts();

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
              await fetchPosts();
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

  // Real-time subscription for immortal posts (with profile JOIN support)
  Stream<List<Post>> subscribeToImmortalPosts() {
    final controller = StreamController<List<Post>>.broadcast();

    Future<void> fetchImmortal() async {
      try {
        final rows = await _client
            .from('posts')
            .select('*, profiles!author_id(id, username, avatar_url)')
            .eq('status', 'immortal')
            .order('created_at', ascending: false);
        if (!controller.isClosed) {
          controller.add((rows as List).map((j) => Post.fromJson(j)).toList());
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    fetchImmortal();

    final channel = _client
        .channel('public:immortal_posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'status',
            value: 'immortal',
          ),
          callback: (_) => fetchImmortal(),
        )
        .subscribe();

    controller.onCancel = () {
      _client.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  // Real-time subscription for a single post (with profile JOIN support)
  Stream<Post> subscribeToSinglePost(String postId) {
    final controller = StreamController<Post>.broadcast();

    Future<void> fetchSingle() async {
      try {
        final row = await _client
            .from('posts')
            .select('*, profiles!author_id(id, username, avatar_url)')
            .eq('id', postId)
            .single();
        if (!controller.isClosed) {
          controller.add(Post.fromJson(row));
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    fetchSingle();

    final channel = _client
        .channel('public:single_post_$postId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: postId,
          ),
          callback: (_) => fetchSingle(),
        )
        .subscribe();

    controller.onCancel = () {
      _client.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
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
    try {
      // Fetch post to see if it has media
      final response = await _client
          .from('posts')
          .select('media_url')
          .eq('id', postId)
          .single();
      final mediaUrl = response['media_url'] as String?;

      if (mediaUrl != null && mediaUrl.contains('/posts/')) {
        // Extract the filename from the public URL
        final fileName = mediaUrl.split('/posts/').last;
        await _client.storage.from('posts').remove([fileName]);
      }
    } catch (_) {
      // Ignore if fetch fails or media deletion fails, continue to delete row
    }

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

  Future<void> useReviveToken(String postId) async {
    await _client.rpc('use_revive_token', params: {'p_post_id': postId});
  }

  final Map<String, Map<String, dynamic>> _profileCache = {};

  Stream<List<Comment>> subscribeToComments(String postId) {
    return _client
        .from('post_interactions')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true)
        .asyncMap((rows) async {
          final comments = rows.where((j) => j['type'] == 'comment').toList();

          // Collect unique user IDs that need profile lookup
          final userIds = comments
              .map((j) => j['user_id'] as String)
              .toSet()
              .where((id) => !_profileCache.containsKey(id))
              .toList();

          // Batch fetch missing profiles
          if (userIds.isNotEmpty) {
            final profiles = await _client
                .from('profiles')
                .select('id, username, avatar_url')
                .inFilter('id', userIds);
            for (final p in profiles) {
              _profileCache[p['id'] as String] = p;
            }
          }

          // Build Comment objects with profile data
          return comments.map((j) {
            final profile = _profileCache[j['user_id']];
            j['profiles'] = profile;
            return Comment.fromJson(j);
          }).toList();
        });
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

final immortalPostsProvider = StreamProvider<List<Post>>((ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.subscribeToImmortalPosts();
});

final trendingPostsProvider = FutureProvider<List<Post>>((ref) {
  return ref.watch(feedRepositoryProvider).fetchTrendingPosts();
});

final dyingPostsProvider = FutureProvider<List<Post>>((ref) {
  return ref.watch(feedRepositoryProvider).fetchDyingPosts();
});
