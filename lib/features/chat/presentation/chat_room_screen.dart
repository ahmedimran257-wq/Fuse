import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_controller.dart';
import '../../../shared/widgets/fuse_timer_bar.dart';
import '../../../shared/widgets/premium_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics_engine.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/chat_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.roomId));
    final roomAsync = ref.watch(chatControllerProvider).whenData((rooms) {
      return rooms.firstWhere((room) => room.id == widget.roomId);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: roomAsync.when(
          data: (room) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.roomName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 4,
                width: 200, // Constrain width for appbar
                child: FuseTimerBar(
                  expirationTimestamp: room.expirationTimestamp,
                  totalSeconds: room.totalSeconds,
                ),
              ),
            ],
          ),
          loading: () =>
              const Text('Loading...', style: TextStyle(color: Colors.white54)),
          error: (e, _) =>
              const Text('Error', style: TextStyle(color: AppColors.danger)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                reverse: true, // Show latest at bottom logic
                itemBuilder: (context, index) {
                  final msg = messages.reversed.toList()[index];
                  final isMe =
                      msg.senderId ==
                      Supabase.instance.client.auth.currentUser!.id;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.accent : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorView(
                message: 'Failed to load messages.\n$e',
                onRetry: () => ref.refresh(chatMessagesProvider(widget.roomId)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PremiumButton(
                  text: 'Send',
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      HapticsEngine.lightImpact();
                      final repo = ChatRepository();
                      await repo.sendMessage(
                        widget.roomId,
                        _messageController.text,
                      );
                      _messageController.clear();
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
