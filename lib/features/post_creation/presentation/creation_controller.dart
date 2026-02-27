import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/post_creation_repository.dart';

final creationControllerProvider =
    StateNotifierProvider<CreationController, AsyncValue<void>>((ref) {
      return CreationController(PostCreationRepository());
    });

class CreationController extends StateNotifier<AsyncValue<void>> {
  final PostCreationRepository _repository;
  CreationController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> uploadPost({
    required String imagePath,
    required String caption,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final file = File(imagePath);
      final mediaUrl = await _repository.uploadMedia(file, userId);
      await _repository.createPost(
        authorId: userId,
        mediaUrl: mediaUrl,
        contentType: 'image',
        caption: caption,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
