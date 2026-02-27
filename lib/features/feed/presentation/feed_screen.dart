import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fuse/core/theme/app_colors.dart';
import 'package:fuse/core/utils/haptics_engine.dart';
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
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () => context.push('/chat'),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: postsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
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
