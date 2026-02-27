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

  FeedController(this._repository) : super(const AsyncValue.loading()) {
    _subscribeToPosts();
  }

  void _subscribeToPosts() {
    _repository.subscribeToPosts().listen(
      (posts) {
        state = AsyncValue.data(posts);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  Future<void> likePost(String postId) async {
    try {
      await _repository.likePost(postId);
    } catch (e) {
      // Handle error
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
    try {
      await _repository.viewPost(postId);
    } catch (e) {
      // Handle error
    }
  }
}
