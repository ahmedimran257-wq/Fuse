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
    state = AsyncValue.data(
      state.value?.toList() ?? [],
    ); // Force UI rebuild to show red heart

    try {
      await _repository.likePost(postId);
    } catch (e) {
      _likedPostIds.remove(postId); // Rollback on failure
      _errorController.add('Failed to like. Please try again.');
      state = AsyncValue.data(state.value?.toList() ?? []); // Revert UI
    }
  }

  Future<void> commentOnPost(String postId, String comment) async {
    try {
      await _repository.commentOnPost(postId, comment);
    } catch (e) {
      // Handle error
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

  @override
  void dispose() {
    _errorController.close();
    _subscription?.cancel();
    super.dispose();
  }
}
