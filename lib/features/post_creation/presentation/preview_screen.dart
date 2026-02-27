import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'creation_controller.dart';
import 'package:fuse/shared/widgets/premium_button.dart';
import 'package:fuse/shared/widgets/fuse_glass_card.dart';
import 'package:fuse/core/theme/app_colors.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final String imagePath;
  const PreviewScreen({super.key, required this.imagePath});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creationControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.imagePath.isNotEmpty
                        ? Image.file(File(widget.imagePath), fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
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
                      final success = await ref
                          .read(creationControllerProvider.notifier)
                          .uploadPost(
                            imagePath: widget.imagePath,
                            caption: _captionController.text,
                          );

                      if (!context.mounted) return;

                      if (success) {
                        context.go('/feed');
                      }
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
