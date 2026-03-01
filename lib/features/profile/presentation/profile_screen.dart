import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_controller.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics_engine.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final postsAsync = ref.watch(userPostsProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fuse Box'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: 'Failed to load profile.\n$error',
          onRetry: () => ref.refresh(profileControllerProvider),
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
                      Text(
                        profile.username,
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(
                            'Time Donated (Week)',
                            '${profile.timeDonatedWeek}s',
                          ),
                          _buildStat(
                            'Total Donated',
                            '${profile.timeDonatedTotal}s',
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
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return FuseGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.mediaUrl ?? 'Text Post',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${post.status}',
                                style: TextStyle(
                                  color: post.status == 'alive'
                                      ? AppColors.accent
                                      : post.status == 'dead'
                                      ? AppColors.danger
                                      : AppColors.accentCyan,
                                ),
                              ),
                              if (post.status == 'dead' &&
                                  profile.reviveTokens > 0)
                                PremiumButton(
                                  text: 'Use Revive Token',
                                  onPressed: () async {
                                    HapticsEngine.heavyImpact();
                                    await ref
                                        .read(
                                          profileControllerProvider.notifier,
                                        )
                                        .useReviveToken(post.id);
                                    // Force the list to redraw
                                    ref.invalidate(userPostsProvider(userId));
                                  },
                                ),
                            ],
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
