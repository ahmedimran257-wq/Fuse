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
import 'package:go_router/go_router.dart';
import 'package:fuse/core/providers/auth_user_provider.dart';
import '../domain/post_model.dart';
import '../data/feed_repository.dart';
import 'feed_controller.dart';

class PostWidget extends ConsumerWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = post.baseDurationSeconds;
    // Check if the post is liked in the current session
    final isLiked = ref.watch(feedControllerProvider.notifier).isLiked(post.id);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // The Three-Dot Menu
          Positioned(
            top: 48,
            right: 16,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: AppColors.surface,
              onSelected: (value) async {
                if (value == 'delete') {
                  // Show confirmation dialog
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      title: const Text(
                        'Delete Post?',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'This action cannot be undone.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: AppColors.danger),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    ref
                        .read(feedControllerProvider.notifier)
                        .deletePost(post.id);
                  }
                } else if (value == 'report') {
                  final reason = await _showReportDialog(context);
                  if (reason != null && context.mounted) {
                    await ref
                        .read(feedRepositoryProvider)
                        .reportPost(currentUserId, post.id, reason);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Post reported. Thank you for keeping Fuse safe.',
                        ),
                      ),
                    );
                  }
                }
              },
              itemBuilder: (_) => post.authorId == currentUserId
                  ? [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Post',
                          style: TextStyle(color: AppColors.danger),
                        ),
                      ),
                    ]
                  : [
                      const PopupMenuItem(
                        value: 'report',
                        child: Text(
                          'Report Post',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
            ),
          ),
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
                  GestureDetector(
                    onTap: () => context.push('/profile/${post.authorId}'),
                    child: Row(
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
                  ),
                  if (post.caption != null && post.caption!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        post.caption!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Timer bar
                  post.status == 'immortal'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.all_inclusive,
                              color: AppColors.timerSafe,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'IMMORTAL',
                              style: TextStyle(
                                color: AppColors.timerSafe,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: AppColors.timerSafe.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : FuseTimerBar(
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked
                              ? AppColors.timerCritical
                              : Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          HapticsEngine.selectionClick();
                          ref
                              .read(feedControllerProvider.notifier)
                              .likePost(post.id);
                        },
                      ),

                      // The Core Mechanic: Donate Time
                      PremiumButton(
                        text: '⏱️ +30s',
                        isPrimary: false,
                        onPressed: () {
                          HapticsEngine.heavySuccess(); // Massive dopamine hit
                          ref
                              .read(feedControllerProvider.notifier)
                              .donateTime(post.id, seconds: 30);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          HapticsEngine.selectionClick();
                          context.push(
                            '/comments/${post.id}',
                          ); // Push to the new screen
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          post.remainingSeconds < 300 &&
                                  post.remainingSeconds > 0
                              ? Icons.campaign
                              : Icons.ios_share,
                          color:
                              post.remainingSeconds < 300 &&
                                  post.remainingSeconds > 0
                              ? AppColors.timerWarning
                              : Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          HapticsEngine.selectionClick();

                          final isRescue =
                              post.remainingSeconds < 300 &&
                              post.remainingSeconds > 0;
                          final String deepLink = 'fuseapp://post/${post.id}';
                          final String shareText = isRescue
                              ? '🚨 RESCUE PARTY! Help save this post before it dies! Donating time gives 2X bonus right now.\n$deepLink'
                              : 'Check out this post on Fuse!\n$deepLink';

                          SharePlus.instance.share(
                            ShareParams(text: shareText),
                          );
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

  Future<String?> _showReportDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Report Post', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Spam', 'Inappropriate Content', 'Harassment', 'Other']
              .map(
                (reason) => ListTile(
                  title: Text(
                    reason,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () => Navigator.pop(ctx, reason),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
