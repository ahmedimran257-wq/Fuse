import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

import '../data/feed_repository.dart';
import '../domain/comment_model.dart';
import 'feed_controller.dart';

// Stream provider to watch comments in real time
final commentsProvider = StreamProvider.family<List<Comment>, String>((
  ref,
  postId,
) {
  return ref.watch(feedRepositoryProvider).subscribeToComments(postId);
});

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    _controller.clear(); // Clear instantly for UX

    try {
      await ref
          .read(feedControllerProvider.notifier)
          .commentOnPost(widget.postId, text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to post comment'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'No comments yet. Be the first!',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                context.push('/profile/${comment.userId}'),
                            child: comment.avatarUrl != null
                                ? CircleAvatar(
                                    radius: 16,
                                    backgroundImage: CachedNetworkImageProvider(
                                      comment.avatarUrl!,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.surfaceHighlight,
                                    child: Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => context.push(
                                    '/profile/${comment.userId}',
                                  ),
                                  child: Text(
                                    comment.username ?? 'Anonymous',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.content,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error loading comments',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          ),

          // Bottom Input Field
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.surfaceHighlight, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.accent),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
