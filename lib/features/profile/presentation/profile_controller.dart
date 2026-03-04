import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';
import '../domain/user_profile.dart';
import '../../feed/domain/post_model.dart';
import '../../../core/providers/auth_user_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(),
);

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserProfile>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileController(repository, ref);
    });

class ProfileController extends StateNotifier<AsyncValue<UserProfile>> {
  final ProfileRepository _repository;
  final Ref ref;
  ProfileController(this._repository, this.ref)
    : super(const AsyncValue.loading()) {
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

  Future<void> updateAvatar(String filePath) async {
    try {
      final userId = ref.read(currentUserIdProvider);
      await _repository.uploadAvatar(userId, filePath);
      await refresh(); // Reload the UI to show the new picture!
    } catch (e) {
      debugPrint('Failed to upload avatar: $e');
    }
  }
}

final userProfileProvider = FutureProvider.family<UserProfile, String>((
  ref,
  userId,
) async {
  return await ref.watch(profileRepositoryProvider).getProfile(userId);
});

final userPostsProvider = FutureProvider.family<List<Post>, String>((
  ref,
  userId,
) async {
  return await ref.watch(profileRepositoryProvider).getUserPosts(userId);
});
