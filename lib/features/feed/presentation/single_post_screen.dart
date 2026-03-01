import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/core/theme/app_colors.dart';
import '../data/feed_repository.dart';
import 'post_widget.dart';
import '../domain/post_model.dart';
import 'package:go_router/go_router.dart';

final singlePostProvider = FutureProvider.family<Post, String>((
  ref,
  postId,
) async {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.getPost(postId);
});

class SinglePostScreen extends ConsumerWidget {
  final String postId;

  const SinglePostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(singlePostProvider(postId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/feed'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: postAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading post: $error',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        data: (post) {
          return PostWidget(post: post);
        },
      ),
    );
  }
}
