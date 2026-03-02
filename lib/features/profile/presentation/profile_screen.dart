import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_controller.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics_engine.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/time_formatter.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    final targetUserId = userId ?? currentUserId;
    final isOwnProfile = targetUserId == currentUserId;

    final profileAsync = isOwnProfile
        ? ref.watch(profileControllerProvider)
        : ref.watch(userProfileProvider(targetUserId));
    final postsAsync = ref.watch(userPostsProvider(targetUserId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fuse Box'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.danger),
              onPressed: () async {
                HapticsEngine.heavyImpact(); // Give it weight
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: 'Failed to load profile.\n$error',
          onRetry: () => isOwnProfile
              ? ref.refresh(profileControllerProvider)
              : ref.refresh(userProfileProvider(targetUserId)),
        ),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile header
                FuseGlassCard(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.accent,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.username,
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isOwnProfile)
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              onPressed: () => _showEditUsernameDialog(
                                context,
                                ref,
                                profile.username,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(
                            'Donated (Week)',
                            TimeFormatter.formatDuration(
                              Duration(seconds: profile.timeDonatedWeek),
                            ),
                          ),
                          _buildStat(
                            'Total Donated',
                            TimeFormatter.formatDuration(
                              Duration(seconds: profile.timeDonatedTotal),
                            ),
                          ),
                          _buildStat(
                            'Revive Tokens',
                            '${profile.reviveTokens}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PremiumButton(
                  text: '🏆 View Hall of Fame',
                  onPressed: () {
                    HapticsEngine.lightImpact();
                    context.push('/immortal_posts');
                  },
                ),
                const SizedBox(height: 24),
                // User's posts
                const Text(
                  'Your Posts',
                  style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                postsAsync.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const Text(
                        'No posts yet.',
                        style: TextStyle(color: AppColors.textPrimary),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () => context.push('/post/${post.id}'),
                          child: Card(
                            color: AppColors.surface,
                            clipBehavior: Clip.antiAlias,
                            child: post.mediaUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: post.mediaUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (_, _) => Container(
                                      color: AppColors.surfaceHighlight,
                                    ),
                                    errorWidget: (_, _, _) => const Icon(
                                      Icons.broken_image,
                                      color: AppColors.danger,
                                    ),
                                  )
                                : Container(
                                    color: AppColors.surfaceHighlight,
                                    child: const Center(
                                      child: Icon(
                                        Icons.text_fields,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const LoadingIndicator(),
                  error: (e, _) =>
                      ErrorView(message: 'Failed to load posts.\n$e'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditUsernameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Edit Username',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          PremiumButton(
            text: 'Save',
            onPressed: () {
              if (controller.text.isNotEmpty &&
                  controller.text != currentName) {
                ref
                    .read(profileControllerProvider.notifier)
                    .updateUsername(controller.text);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
