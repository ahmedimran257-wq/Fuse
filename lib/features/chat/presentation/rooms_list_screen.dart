import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'chat_controller.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../shared/widgets/fuse_timer_bar.dart';
import '../../../core/theme/app_colors.dart';

class RoomsListScreen extends ConsumerWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Live Rooms',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.accent),
            onPressed: () => _showCreateRoomDialog(context, ref),
          ),
        ],
      ),
      body: state.isLoading && state.rooms.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(chatControllerProvider.notifier)
                          .enterRoom(room.id);
                      context.push('/chat/${room.id}');
                    },
                    child: FuseGlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  room.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.accent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            FuseTimerBar(
                              remainingSeconds: room.remainingSeconds,
                              totalSeconds:
                                  room.baseDurationSeconds *
                                  2, // Allow room for extensions
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCreateRoomDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Create New Room',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Room Name',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Create',
              style: TextStyle(color: AppColors.accent),
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(chatControllerProvider.notifier)
                    .createRoom(controller.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
