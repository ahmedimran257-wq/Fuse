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
        .gt('expiration_timestamp', DateTime.now().toIso8601String())
        .order('created_at', ascending: false);
    return (response as List).map((json) => ChatRoom.fromJson(json)).toList();
  }

  // Create a new room
  Future<ChatRoom> createRoom(
    String roomName, {
    int maxDurationHours = 24,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final now = DateTime.now();
    final expiration = now.add(const Duration(minutes: 30)); // initial fuse
    final maxExpiration = now.add(Duration(hours: maxDurationHours));
    final response = await _client
        .from('chat_rooms')
        .insert({
          'room_name': roomName,
          'creator_id': userId,
          'expiration_timestamp': expiration.toIso8601String(),
          'max_expiration_timestamp': maxExpiration.toIso8601String(),
          'status': 'active', // Ensure status exists if required
          'created_at': now
              .toIso8601String(), // Ensure created_at exists for model calculation
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

  // Subscribe to messages in a room
  Stream<List<ChatMessage>> subscribeToMessages(String roomId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map(
          (events) => events.map((json) => ChatMessage.fromJson(json)).toList(),
        );
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
