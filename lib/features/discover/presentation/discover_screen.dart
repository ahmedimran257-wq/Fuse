import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/domain/user_profile.dart';
import '../data/discover_repository.dart';
import '../../feed/data/feed_repository.dart';
import '../../feed/domain/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/shimmer_loading.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();
  List<UserProfile> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
      return;
    }

    if (mounted) setState(() => _isSearching = true);

    try {
      final results = await ref
          .read(discoverRepositoryProvider)
          .searchUsers(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text(
              'Discover',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.leaderboard_rounded,
                  color: AppColors.accentGold,
                ),
                onPressed: () => context.push('/leaderboard'),
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceHighlight,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Content area
          if (_isSearching)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            )
          else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_search_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No users found',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_searchResults.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final user = _searchResults[index];
                return _buildUserTile(user);
              }, childCount: _searchResults.length),
            )
          else ...[
            // Default state: Quick actions + trending
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leaderboard Card
                    GestureDetector(
                      onTap: () => context.push('/leaderboard'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Global Leaderboard',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See top time donors',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Trending Section
                    _buildSectionHeader(
                      Icons.local_fire_department_rounded,
                      'TRENDING',
                      AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    _buildTrendingCarousel(ref),
                    const SizedBox(height: 32),

                    // Dying Now Section
                    _buildSectionHeader(
                      Icons.timer_outlined,
                      'DYING NOW',
                      AppColors.danger,
                    ),
                    const SizedBox(height: 16),
                    _buildDyingCarousel(ref),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCarousel(WidgetRef ref) {
    final trendingAsync = ref.watch(trendingPostsProvider);
    return SizedBox(
      height: 160,
      child: trendingAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No trending posts right now.',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) =>
                _buildCarouselCard(context, posts[index]),
          );
        },
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: const ShimmerLoading(borderRadius: 16),
          ),
        ),
        error: (e, _) => const Center(
          child: Text(
            'Failed to load',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }

  Widget _buildDyingCarousel(WidgetRef ref) {
    final dyingAsync = ref.watch(dyingPostsProvider);
    return SizedBox(
      height: 160,
      child: dyingAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No dying posts right now.',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) =>
                _buildCarouselCard(context, posts[index]),
          );
        },
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: const ShimmerLoading(borderRadius: 16),
          ),
        ),
        error: (e, _) => const Center(
          child: Text(
            'Failed to load',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselCard(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () => context.push('/post/${post.id}'),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceHighlight,
          image: post.mediaUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(post.mediaUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: post.mediaUrl == null
            ? const Center(
                child: Icon(Icons.text_fields, color: AppColors.textTertiary),
              )
            : null,
      ),
    );
  }

  Widget _buildUserTile(UserProfile user) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accent, width: 1.5),
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.surfaceHighlight,
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? const Icon(
                  Icons.person,
                  color: AppColors.textTertiary,
                  size: 22,
                )
              : null,
        ),
      ),
      title: Text(
        '@${user.username}',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        '${user.postCount} posts',
        style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
        size: 20,
      ),
      onTap: () => context.push('/profile/${user.id}'),
    );
  }
}
