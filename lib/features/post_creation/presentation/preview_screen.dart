import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'creation_controller.dart';
import 'package:fuse/shared/widgets/premium_button.dart';
import 'package:fuse/shared/widgets/fuse_glass_card.dart';
import 'package:fuse/core/theme/app_colors.dart';

import 'package:fuse/shared/widgets/fuse_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final String contentType;
  const PreviewScreen({
    super.key,
    required this.imagePath,
    this.contentType = 'image',
  });

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final _captionController = TextEditingController();
  int _selectedDuration = 900; // Default 15 minutes

  @override
  void initState() {
    super.initState();
    _checkExistingDraft();

    // Auto-save listener
    _captionController.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('draft_caption', _captionController.text);
      await prefs.setString('draft_image_path', widget.imagePath);
      await prefs.setString('draft_content_type', widget.contentType);
    });
  }

  Future<void> _checkExistingDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftPath = prefs.getString('draft_image_path');
    final draftCaption = prefs.getString('draft_caption');
    final draftType = prefs.getString('draft_content_type') ?? 'image';

    // If a draft exists AND it's not the exact one we are currently looking at
    if (draftPath != null && draftPath != widget.imagePath && mounted) {
      final restore = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Restore Draft?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'You have an unsaved post. Would you like to restore it?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                prefs.remove('draft_image_path'); // Discard
                Navigator.pop(ctx, false);
              },
              child: const Text(
                'Discard',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Restore',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (restore == true && mounted) {
        // Swap the screen data
        context.replace(
          '/preview',
          extra: {'path': draftPath, 'type': draftType},
        );
        // We defer caption setting to ensure the new route has built
        Future.microtask(() => _captionController.text = draftCaption ?? '');
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creationControllerProvider);

    // Listen for successful upload and route automatically
    ref.listen(creationControllerProvider, (previous, next) {
      if (previous != null &&
          previous.isLoading &&
          !next.isLoading &&
          !next.hasError) {
        context.go('/feed');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.imagePath.isEmpty
                        ? const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          )
                        : widget.contentType == 'video'
                        ? FuseVideoPlayer(file: File(widget.imagePath))
                        : Image.file(File(widget.imagePath), fit: BoxFit.cover),
                  ),
                  if (state.isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
            FuseGlassCard(
              borderRadius: 0,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.error.toString(),
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  // The Duration Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          {
                            '5m': 300,
                            '15m': 900,
                            '30m': 1800,
                            '1h': 3600,
                            '6h': 21600,
                          }.entries.map((e) {
                            final isSelected = _selectedDuration == e.value;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedDuration = e.value),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.surfaceHighlight,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  e.key,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      labelText: 'Add a caption...',
                      labelStyle: TextStyle(color: AppColors.textPrimary),
                    ),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  PremiumButton(
                    text: 'Post',
                    isLoading: state.isLoading,
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('draft_image_path');
                      await prefs.remove('draft_caption');
                      ref
                          .read(creationControllerProvider.notifier)
                          .uploadPost(
                            widget.imagePath,
                            widget.contentType,
                            _captionController.text,
                            _selectedDuration,
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
