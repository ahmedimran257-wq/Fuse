import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fuse/core/theme/app_colors.dart';
import 'package:fuse/core/utils/haptics_engine.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import 'feed_controller.dart';
import 'post_widget.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FUSE',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () => context.push('/rooms'),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: postsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: 'Failed to load posts.\n$error',
          onRetry: () => ref.refresh(feedControllerProvider),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No posts yet. Create one!',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }
          return PageView.builder(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            onPageChanged: (index) {
              // Only fires exactly once when the user snaps to a new video
              final post = posts[index];
              ref.read(feedControllerProvider.notifier).viewPost(post.id);
            },
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostWidget(post: post); // Clean and safe
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticsEngine.lightImpact();
          context.push('/camera');
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }
}
