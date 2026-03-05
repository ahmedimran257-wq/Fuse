import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_controller.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics_engine.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/error_view.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/time_formatter.dart';
import 'package:image_picker/image_picker.dart';

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
      body: profileAsync.when(
        loading: () => const Center(
          child: ShimmerLoading(width: 200, height: 200, borderRadius: 100),
        ),
        error: (error, stack) => ErrorView(
          message: 'Failed to load profile.\n$error',
          onRetry: () => isOwnProfile
              ? ref.refresh(profileControllerProvider)
              : ref.refresh(userProfileProvider(targetUserId)),
        ),
        data: (profile) {
          return CustomScrollView(
            slivers: [
              // Parallax collapsing header
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.surface,
                actions: [
                  if (isOwnProfile)
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        HapticsEngine.selectionClick();
                        context.push('/settings');
                      },
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.surfaceGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Avatar with gradient ring
                          GestureDetector(
                            onTap: isOwnProfile
                                ? () async {
                                    HapticsEngine.selectionClick();
                                    final picker = ImagePicker();
                                    final file = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 70,
                                    );
                                    if (file != null) {
                                      final error = await ref
                                          .read(
                                            profileControllerProvider.notifier,
                                          )
                                          .updateAvatar(file.path);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error == null
                                                  ? 'Profile photo updated!'
                                                  : 'Failed: $error',
                                            ),
                                            backgroundColor: error == null
                                                ? AppColors.success
                                                : AppColors.danger,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isOwnProfile
                                    ? AppColors.brandGradient
                                    : null,
                                border: !isOwnProfile
                                    ? Border.all(
                                        color: AppColors.surfaceHighlight,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: AppColors.surfaceHighlight,
                                backgroundImage: profile.avatarUrl != null
                                    ? CachedNetworkImageProvider(
                                        profile.avatarUrl!,
                                      )
                                    : null,
                                child: profile.avatarUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 48,
                                        color: AppColors.textSecondary,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                profile.username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (isOwnProfile)
                                GestureDetector(
                                  onTap: () => _showEditUsernameDialog(
                                    context,
                                    ref,
                                    profile.username,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.textTertiary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Stats row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat(
                                  'This Week',
                                  TimeFormatter.formatDuration(
                                    Duration(seconds: profile.timeDonatedWeek),
                                  ),
                                ),
                                _buildDivider(),
                                _buildStat(
                                  'Total',
                                  TimeFormatter.formatDuration(
                                    Duration(seconds: profile.timeDonatedTotal),
                                  ),
                                ),
                                _buildDivider(),
                                _buildStat(
                                  'Streak',
                                  '🔥 ${profile.donationStreak}',
                                ),
                                _buildDivider(),
                                _buildStat('Energy', '⚡ ${profile.fuseEnergy}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Action buttons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticsEngine.lightImpact();
                            context.push('/immortal_posts');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHighlight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.surfaceElevated,
                                width: 0.5,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  color: AppColors.accentGold,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Hall of Fame',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Posts section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    isOwnProfile ? 'YOUR POSTS' : 'POSTS',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // Posts grid
              postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No posts yet',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () => context.push('/post/${post.id}'),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: post.mediaUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: post.mediaUrl!,
                                    fit: BoxFit.cover,
                                    memCacheWidth: 300,
                                    placeholder: (_, _) =>
                                        const ShimmerLoading(borderRadius: 4),
                                    errorWidget: (_, _, _) => Container(
                                      color: AppColors.surfaceHighlight,
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: AppColors.surfaceHighlight,
                                    child: const Center(
                                      child: Icon(
                                        Icons.text_fields,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      }, childCount: posts.length),
                    ),
                  );
                },
                loading: () => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerLoading(borderRadius: 4),
                      childCount: 9,
                    ),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorView(message: 'Failed to load posts.\n$e'),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Username',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceHighlight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter new username',
            hintStyle: const TextStyle(color: AppColors.textTertiary),
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
            onPressed: () async {
              if (controller.text.isNotEmpty &&
                  controller.text != currentName) {
                Navigator.pop(ctx);
                final error = await ref
                    .read(profileControllerProvider.notifier)
                    .updateUsername(controller.text);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error == null ? 'Username updated!' : 'Failed: $error',
                      ),
                      backgroundColor: error == null
                          ? AppColors.success
                          : AppColors.danger,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              } else {
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 28, width: 0.5, color: AppColors.surfaceOverlay);
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
