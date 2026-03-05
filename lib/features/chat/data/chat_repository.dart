import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_room.dart';
import '../domain/chat_message.dart';

class ChatRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch rooms the user is a member of
  Future<List<ChatRoom>> fetchMyRooms() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('chat_rooms')
        .select('*, chat_members!inner(user_id)')
        .eq('chat_members.user_id', userId)
        .gt('expiration_timestamp', DateTime.now().toUtc().toIso8601String())
        .order('created_at', ascending: false);
    return (response as List).map((json) => ChatRoom.fromJson(json)).toList();
  }

  // Create a new room
  Future<ChatRoom> createRoom(
    String roomName, {
    int maxDurationHours = 24,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final now = DateTime.now().toUtc();
    final expiration = now.add(const Duration(minutes: 30)); // initial fuse
    final maxExpiration = now.add(Duration(hours: maxDurationHours));
    final response = await _client
        .from('chat_rooms')
        .insert({
          'room_name': roomName,
          'creator_id': userId,
          'expiration_timestamp': expiration.toIso8601String(),
          'max_expiration_timestamp': maxExpiration.toIso8601String(),
        })
        .select()
        .single();
    // Add creator as member
    await _client.from('chat_members').insert({
      'room_id': response['id'],
      'user_id': userId,
    });
    return ChatRoom.fromJson(response);
  }

  // Join a room
  Future<void> joinRoom(String roomId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('chat_members').insert({
      'room_id': roomId,
      'user_id': userId,
    });
  }

  // Send a message
  Future<void> sendMessage(String roomId, String content) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('chat_messages').insert({
      'room_id': roomId,
      'sender_id': userId,
      'content': content,
    });
  }

  // Subscribe to messages in a room (with profile JOIN support)
  Stream<List<ChatMessage>> subscribeToMessages(String roomId) {
    final controller = StreamController<List<ChatMessage>>.broadcast();

    Future<void> fetchMessages() async {
      try {
        final rows = await _client
            .from('chat_messages')
            .select('*, profiles!sender_id(id, username, avatar_url)')
            .eq('room_id', roomId)
            .order('created_at', ascending: false);
        if (!controller.isClosed) {
          controller.add(
            (rows as List).map((j) => ChatMessage.fromJson(j)).toList(),
          );
        }
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    // Initial fetch
    fetchMessages();

    // Listen for changes
    final channel = _client
        .channel('room:$roomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (_) => fetchMessages(),
        )
        .subscribe();

    controller.onCancel = () {
      _client.removeChannel(channel);
      controller.close();
    };
    return controller.stream;
  }

  // Get room details
  Future<ChatRoom> getRoom(String roomId) async {
    final response = await _client
        .from('chat_rooms')
        .select()
        .eq('id', roomId)
        .single();
    return ChatRoom.fromJson(response);
  }
}
