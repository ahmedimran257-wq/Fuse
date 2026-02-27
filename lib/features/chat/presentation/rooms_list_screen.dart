import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'chat_controller.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../shared/widgets/fuse_glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';

class RoomsListScreen extends ConsumerWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(chatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fuse Rooms'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (rooms) {
          if (rooms.isEmpty) {
            return const Center(child: Text('No active rooms. Create one!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final remaining = room.expirationTimestamp
                  .difference(DateTime.now())
                  .inSeconds;
              return GestureDetector(
                onTap: () {
                  // Updated to use go_router matching our app setup
                  context.push('/chat/${room.id}');
                },
                child: FuseGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.roomName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expires in: ${TimeFormatter.formatDuration(Duration(seconds: remaining))}',
                          style: const TextStyle(color: AppColors.accent),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: PremiumButton(
        text: 'Create Room',
        onPressed: () {
          _showCreateRoomDialog(context, ref);
        },
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('New Room', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Room name',
            labelStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
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
            text: 'Create',
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref
                    .read(chatControllerProvider.notifier)
                    .createRoom(controller.text);
                if (!context.mounted) return;
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}
