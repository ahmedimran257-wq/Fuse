import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/feed_repository.dart';
import '../domain/post_model.dart';

final feedControllerProvider =
    StateNotifierProvider<FeedController, AsyncValue<List<Post>>>((ref) {
      final repository = ref.watch(feedRepositoryProvider);
      return FeedController(repository);
    });

class FeedController extends StateNotifier<AsyncValue<List<Post>>> {
  final FeedRepository _repository;
  StreamSubscription<List<Post>>? _subscription;

  final _errorController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _errorController.stream;

  final _likedPostIds = <String>{};
  final _viewedPostIds = <String>{};

  bool isLiked(String postId) => _likedPostIds.contains(postId);

  FeedController(this._repository) : super(const AsyncValue.loading()) {
    _subscribeToPosts();
  }

  void _subscribeToPosts() {
    _subscription = _repository.subscribeToPosts().listen(
      (posts) {
        state = AsyncValue.data(posts);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  Future<void> likePost(String postId) async {
    if (_likedPostIds.contains(postId)) return; // Prevent spamming

    _likedPostIds.add(postId); // Optimistic local update
    // Optimistically increment the like count
    state = AsyncValue.data(
      state.value
              ?.map((p) => p.id == postId ? p.copyWith(likes: p.likes + 1) : p)
              .toList() ??
          [],
    );

    try {
      await _repository.likePost(postId);
    } catch (e) {
      _likedPostIds.remove(postId); // Rollback on failure
      state = AsyncValue.data(
        state.value
                ?.map(
                  (p) => p.id == postId ? p.copyWith(likes: p.likes - 1) : p,
                )
                .toList() ??
            [],
      );
      _errorController.add('Failed to like. Please try again.');
    }
  }

  Future<void> commentOnPost(String postId, String comment) async {
    // Optimistically increment comment count
    state = AsyncValue.data(
      state.value
              ?.map(
                (p) =>
                    p.id == postId ? p.copyWith(comments: p.comments + 1) : p,
              )
              .toList() ??
          [],
    );
    try {
      await _repository.commentOnPost(postId, comment);
    } catch (e) {
      // Rollback
      state = AsyncValue.data(
        state.value
                ?.map(
                  (p) =>
                      p.id == postId ? p.copyWith(comments: p.comments - 1) : p,
                )
                .toList() ??
            [],
      );
      _errorController.add('Failed to post comment. Please try again.');
    }
  }

  Future<void> viewPost(String postId) async {
    if (_viewedPostIds.contains(postId)) {
      return; // Prevent reverse-swipe phantom views
    }
    _viewedPostIds.add(postId);
    try {
      await _repository.viewPost(postId);
    } catch (_) {
      // Views failing silently is acceptable UX
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _repository.deletePost(postId);
      // Optimistically remove the post from the UI instantly
      final currentPosts = state.value ?? [];
      state = AsyncValue.data(
        currentPosts.where((p) => p.id != postId).toList(),
      );
    } catch (e) {
      _errorController.add('Failed to delete post.');
    }
  }

  Future<void> donateTime(String postId, {int seconds = 30}) async {
    try {
      await _repository.donateTime(postId, seconds: seconds);
      // The Supabase Realtime stream will automatically catch the updated time and refresh the UI!
    } catch (e) {
      _errorController.add('Failed to donate time.');
    }
  }

  @override
  void dispose() {
    _errorController.close();
    _subscription?.cancel();
    super.dispose();
  }
}
