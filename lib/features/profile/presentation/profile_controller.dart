import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';
import '../domain/user_profile.dart';
import '../../feed/domain/post_model.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserProfile>>((ref) {
      return ProfileController(ProfileRepository());
    });

class ProfileController extends StateNotifier<AsyncValue<UserProfile>> {
  final ProfileRepository _repository;
  ProfileController(this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final profile = await _repository.getProfile(userId);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() => _loadProfile();

  Future<void> useReviveToken(String postId) async {
    await _repository.useReviveToken(postId);
    refresh();
  }

  Future<void> updateUsername(String newUsername) async {
    await _repository.updateUsername(newUsername);
    refresh();
  }
}

final userPostsProvider = FutureProvider.family<List<Post>, String>((
  ref,
  userId,
) async {
  final repo = ProfileRepository();
  return await repo.getUserPosts(userId);
});
