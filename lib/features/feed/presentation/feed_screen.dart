import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fuse/core/theme/app_colors.dart';
import 'package:fuse/core/utils/haptics_engine.dart';
import '../../../shared/widgets/shimmer_loading.dart';
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
      ),
      extendBodyBehindAppBar: true,
      body: postsAsync.when(
        loading: () => const PostShimmer(),
        error: (error, stack) => ErrorView(
          message: 'Failed to load posts.\n$error',
          onRetry: () => ref.refresh(feedControllerProvider),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The feed is empty',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to post something!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final dyingPosts = posts.where((p) {
            // Find posts with < 2 minutes left, but greater than 0
            final seconds = p.expirationTimestamp
                .difference(DateTime.now().toUtc())
                .inSeconds;
            return seconds < 120 && seconds > 0 && p.status == 'alive';
          }).toList();

          return Column(
            children: [
              // THE DYING STRIP
              if (dyingPosts.isNotEmpty)
                Container(
                  height: 120,
                  color: AppColors.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 40),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.timerCritical,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'DYING NOW',
                              style: TextStyle(
                                color: AppColors.timerCritical,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dyingPosts.length,
                          itemBuilder: (context, index) {
                            final post = dyingPosts[index];
                            final secondsLeft = post.expirationTimestamp
                                .difference(DateTime.now().toUtc())
                                .inSeconds;

                            return GestureDetector(
                              onTap: () => context.push('/post/${post.id}'),
                              child: Container(
                                width: 64,
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  top: 8,
                                  bottom: 8,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.timerCritical,
                                    width: 2,
                                  ),
                                  image: post.mediaUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(post.mediaUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${secondsLeft}s',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // THE MAIN VERTICAL FEED
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.accent,
                  backgroundColor: AppColors.surface,
                  onRefresh: () async {
                    HapticsEngine.lightImpact();
                    ref.invalidate(feedControllerProvider);
                  },
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: posts.length,
                    onPageChanged: (index) {
                      final post = posts[index];
                      ref
                          .read(feedControllerProvider.notifier)
                          .viewPost(post.id);
                    },
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostWidget(post: post);
                    },
                  ),
                ),
              ),
            ],
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
