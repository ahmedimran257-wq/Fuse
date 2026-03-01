import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/shared/widgets/fuse_timer_bar.dart';
import 'package:fuse/shared/widgets/fuse_glass_card.dart';
import 'package:fuse/shared/widgets/premium_button.dart';
import 'package:fuse/core/theme/app_colors.dart';
import 'package:fuse/core/utils/haptics_engine.dart';
import 'package:fuse/core/utils/time_formatter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../domain/post_model.dart';
import 'feed_controller.dart';

class PostWidget extends ConsumerWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = post.baseDurationSeconds;

    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // Media content (placeholder)
          Center(
            child: post.mediaUrl != null
                ? CachedNetworkImage(
                    imageUrl: post.mediaUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: AppColors.danger),
                    ),
                  )
                : Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: Text(
                        'Text Post',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
          ),
          // Gradient overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          // Bottom info area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FuseGlassCard(
              borderRadius: 0,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author and timestamp
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'User ${post.authorId.substring(0, 6)}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      Text(
                        TimeFormatter.formatTimestamp(post.createdAt),
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Timer bar
                  FuseTimerBar(
                    expirationTimestamp: post.expirationTimestamp,
                    totalSeconds: total,
                  ),
                  const SizedBox(height: 12),
                  // Interaction stats
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      Text(
                        ' ${post.likes}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.comment,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      Text(
                        ' ${post.comments}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.remove_red_eye,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      Text(
                        ' ${post.views}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          HapticsEngine.lightImpact();
                          final url = 'fuseapp://post/${post.id}';
                          // ignore: deprecated_member_use
                          Share.share(
                            'Save this post before it explodes! $url',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PremiumButton(
                        text: '❤️ Like',
                        onPressed: () {
                          HapticsEngine.lightImpact();
                          ref
                              .read(feedControllerProvider.notifier)
                              .likePost(post.id);
                        },
                      ),
                      PremiumButton(
                        text: '💬 Comment',
                        onPressed: () {
                          HapticsEngine.lightImpact();
                          // Show comment bottom sheet
                          _showCommentSheet(context, ref);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FuseGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Add a comment...',
                  labelStyle: TextStyle(color: AppColors.textPrimary),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              PremiumButton(
                text: 'Send',
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    HapticsEngine.lightImpact();
                    ref
                        .read(feedControllerProvider.notifier)
                        .commentOnPost(post.id, controller.text);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
