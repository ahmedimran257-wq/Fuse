import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../data/discover_repository.dart';

final topSaviorsProvider = FutureProvider((ref) {
  return ref.watch(discoverRepositoryProvider).getTopSaviors();
});

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saviorsAsync = ref.watch(topSaviorsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Top Saviors',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: saviorsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error loading leaderboard: $e',
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
        data: (saviors) {
          if (saviors.isEmpty) {
            return const Center(
              child: Text(
                'No saviors yet this week.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            itemCount: saviors.length,
            itemBuilder: (context, index) {
              final user = saviors[index];
              final isTop3 = index < 3;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isTop3
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : AppColors.surfaceHighlight,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isTop3 ? AppColors.accent : Colors.white,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  '@${user.username}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Donated: ${TimeFormatter.formatDuration(Duration(seconds: user.timeDonatedWeek))}',
                  style: const TextStyle(color: AppColors.timerSafe),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white24,
                ),
                onTap: () => context.push('/profile/${user.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
