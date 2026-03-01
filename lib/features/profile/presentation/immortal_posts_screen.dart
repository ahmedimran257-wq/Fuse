import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/core/theme/app_colors.dart';
import 'package:fuse/core/utils/haptics_engine.dart';
import 'package:fuse/features/feed/data/feed_repository.dart';
import 'package:fuse/features/feed/presentation/post_widget.dart';
import 'package:fuse/shared/widgets/loading_indicator.dart';
import 'package:fuse/shared/widgets/error_view.dart';

class ImmortalPostsScreen extends ConsumerWidget {
  const ImmortalPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immortalPostsAsync = ref.watch(immortalPostsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'HALL OF FAME',
          style: TextStyle(
            color: AppColors.accentCyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: immortalPostsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: 'Failed to load immortal posts.\n$error',
          onRetry: () => ref.refresh(immortalPostsProvider),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'The Hall of Fame is empty.',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.accentCyan,
            backgroundColor: AppColors.background,
            onRefresh: () async {
              HapticsEngine.lightImpact();
              ref.invalidate(immortalPostsProvider);
            },
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Stack(
                  children: [
                    PostWidget(post: post),
                    // Glass overlay to block interactions if desired
                    // But maybe simply wrapping it without touch events or
                    // allowing likes but ignoring the timer since it's immortal
                    if (post.status == 'immortal')
                      Positioned(
                        top: 100,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.2),
                            border: Border.all(color: AppColors.accentCyan),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.diamond,
                                color: AppColors.accentCyan,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'IMMORTAL',
                                style: TextStyle(
                                  color: AppColors.accentCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
