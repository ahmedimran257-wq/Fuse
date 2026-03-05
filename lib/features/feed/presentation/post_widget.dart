import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/shared/widgets/fuse_timer_bar.dart';
import 'package:fuse/shared/widgets/fuse_glass_card.dart';
import 'package:fuse/shared/widgets/shimmer_loading.dart';
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

class PostWidget extends ConsumerStatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _heartScale;
  late final Animation<double> _heartOpacity;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heartScale = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.4), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
      ],
    ).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeOut));

    _heartOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartController);

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showHeart = false);
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    final post = widget.post;
    final isAlreadyLiked = ref
        .read(feedControllerProvider.notifier)
        .isLiked(post.id);

    if (!isAlreadyLiked) {
      ref.read(feedControllerProvider.notifier).likePost(post.id);
    }

    HapticsEngine.heavySuccess();
    setState(() => _showHeart = true);
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final total = post.baseDurationSeconds;
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

          // Media content with double-tap to like
          GestureDetector(
            onDoubleTap: _onDoubleTap,
            child: Center(
              child: post.mediaUrl != null
                  ? CachedNetworkImage(
                      imageUrl: post.mediaUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          const ShimmerLoading(borderRadius: 0),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textTertiary,
                            size: 48,
                          ),
                        ),
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
          ),

          // Heart animation overlay
          if (_showHeart)
            Center(
              child: AnimatedBuilder(
                animation: _heartController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _heartOpacity.value,
                    child: Transform.scale(
                      scale: _heartScale.value,
                      child: child,
                    ),
                  );
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 20)],
                ),
              ),
            ),

          // Gradient overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                  ),
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                          ),
                          child: post.author?.avatarUrl != null
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.author!.avatarUrl!,
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.surfaceHighlight,
                                  child: Icon(
                                    Icons.person,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author?.username ??
                                    'User ${post.authorId.substring(0, 6)}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                TimeFormatter.formatTimestamp(post.createdAt),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (post.caption != null && post.caption!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 4),
                      child: Text(
                        post.caption!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
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
                      Icon(
                        Icons.favorite,
                        color: isLiked
                            ? AppColors.timerCritical
                            : AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.views}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Like button with scale animation
                      _AnimatedLikeButton(
                        isLiked: isLiked,
                        onTap: () {
                          HapticsEngine.selectionClick();
                          ref
                              .read(feedControllerProvider.notifier)
                              .likePost(post.id);
                        },
                      ),

                      // Donate Time
                      GestureDetector(
                        onTap: () {
                          HapticsEngine.heavySuccess();
                          ref
                              .read(feedControllerProvider.notifier)
                              .donateTime(post.id, seconds: 30);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.5),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: AppColors.accent,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '+30s',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white70,
                          size: 26,
                        ),
                        onPressed: () {
                          HapticsEngine.selectionClick();
                          context.push('/comments/${post.id}');
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
                              : Colors.white70,
                          size: 26,
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

/// Animated like button with a bounce effect on tap
class _AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const _AnimatedLikeButton({required this.isLiked, required this.onTap});

  @override
  State<_AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<_AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_AnimatedLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked && !oldWidget.isLiked) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: Icon(
          widget.isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.isLiked ? AppColors.timerCritical : Colors.white70,
          size: 30,
        ),
      ),
    );
  }
}
