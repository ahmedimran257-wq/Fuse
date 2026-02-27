import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostCreationRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadMedia(File file, String userId) async {
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _client.storage.from('posts').upload(fileName, file);
    return _client.storage.from('posts').getPublicUrl(fileName);
  }

  Future<void> createPost({
    required String authorId,
    required String mediaUrl,
    required String contentType,
    int baseDurationSeconds = 900,
    String? caption,
  }) async {
    final expiration = DateTime.now().add(
      Duration(seconds: baseDurationSeconds),
    );
    await _client.from('posts').insert({
      'author_id': authorId,
      'media_url': mediaUrl,
      'content_type': contentType,
      'base_duration_seconds': baseDurationSeconds,
      'expiration_timestamp': expiration.toIso8601String(),
      'status': 'alive',
      'ever_dead': false,
      'caption': caption,
    });
  }
}
