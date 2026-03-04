import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_user_provider.dart';
import '../../../shared/widgets/premium_button.dart';
import 'profile_controller.dart';

// Stream the target user's profile
final publicProfileProvider = FutureProvider.family((ref, String userId) async {
  return await ref.watch(profileRepositoryProvider).getProfile(userId);
});

// Check if the current user is following the target user
final isFollowingProvider = FutureProvider.family<bool, String>((
  ref,
  targetId,
) async {
  final currentId = ref.watch(currentUserIdProvider);
  return await ref
      .watch(profileRepositoryProvider)
      .checkIsFollowing(currentId, targetId);
});

class PublicProfileScreen extends ConsumerWidget {
  final String targetUserId;
  const PublicProfileScreen({super.key, required this.targetUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final isMe = currentUserId == targetUserId;

    // If they clicked their own name, redirect to their main profile tab
    if (isMe) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/profile');
      });
      return const Scaffold(backgroundColor: AppColors.background);
    }

    final profileAsync = ref.watch(publicProfileProvider(targetUserId));
    final postsAsync = ref.watch(userPostsProvider(targetUserId));
    final isFollowingAsync = ref.watch(isFollowingProvider(targetUserId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: AppColors.surface,
            onSelected: (value) async {
              if (value == 'block') {
                await ref
                    .read(profileRepositoryProvider)
                    .blockUser(currentUserId, targetUserId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User blocked.')),
                  );
                  context.pop(); // Kick them out of the profile
                }
              } else if (value == 'report') {
                // We can reuse a simple dialog here, or just submit a generic report
                await ref
                    .read(profileRepositoryProvider)
                    .reportUser(
                      currentUserId,
                      targetUserId,
                      'User Profile Report',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User reported.')),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'report',
                child: Text(
                  'Report User',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Text(
                  'Block User',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ],
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
        data: (profile) => Column(
          children: [
            // Header
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surfaceHighlight,
              backgroundImage: profile.avatarUrl != null
                  ? NetworkImage(profile.avatarUrl!)
                  : null,
              child: profile.avatarUrl == null
                  ? const Icon(Icons.person, size: 40, color: Colors.white54)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              '@${profile.username}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Follow Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat('Followers', profile.followerCount.toString()),
                const SizedBox(width: 32),
                _buildStat('Following', profile.followingCount.toString()),
              ],
            ),
            const SizedBox(height: 24),

            // Follow Button
            isFollowingAsync.when(
              data: (isFollowing) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: PremiumButton(
                  text: isFollowing ? 'Unfollow' : 'Follow',
                  isPrimary: !isFollowing, // Highlighted if not following
                  onPressed: () async {
                    if (isFollowing) {
                      await ref
                          .read(profileRepositoryProvider)
                          .unfollowUser(currentUserId, targetUserId);
                    } else {
                      await ref
                          .read(profileRepositoryProvider)
                          .followUser(currentUserId, targetUserId);
                    }
                    ref.invalidate(isFollowingProvider(targetUserId));
                    ref.invalidate(
                      publicProfileProvider(targetUserId),
                    ); // Refresh counts
                  },
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.surfaceHighlight),

            // Post Grid
            Expanded(
              child: postsAsync.when(
                data: (posts) => GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return GestureDetector(
                      onTap: () => context.push('/post/${post.id}'),
                      child: post.mediaUrl != null
                          ? CachedNetworkImage(
                              imageUrl: post.mediaUrl!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppColors.surfaceHighlight,
                              child: const Icon(
                                Icons.text_fields,
                                color: Colors.white54,
                              ),
                            ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    const Center(child: Text('Failed to load posts')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
