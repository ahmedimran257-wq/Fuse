import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_room.dart';
import '../domain/chat_message.dart';

class ChatRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Stream of active rooms
  Stream<List<ChatRoom>> subscribeToRooms() {
    return _client
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .eq('status', 'active')
        .order('expiration_timestamp', ascending: false)
        .map(
          (events) => events.map((json) => ChatRoom.fromJson(json)).toList(),
        );
  }

  // Create a new room
  Future<ChatRoom> createRoom(String name) async {
    final response = await _client
        .from('chat_rooms')
        .insert({'name': name, 'created_by': _client.auth.currentUser!.id})
        .select()
        .single();
    return ChatRoom.fromJson(response);
  }

  // Stream of messages for a room
  Stream<List<ChatMessage>> subscribeToMessages(String roomId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true)
        .map(
          (events) => events.map((json) => ChatMessage.fromJson(json)).toList(),
        );
  }

  // Send message and extend room timer
  Future<void> sendMessage(String roomId, String text) async {
    // 1. Insert message
    await _client.from('chat_messages').insert({
      'room_id': roomId,
      'sender_id': _client.auth.currentUser!.id,
      'text': text,
    });

    // 2. Extend room timer (via RPC to handle atomic update)
    await _client.rpc(
      'extend_room_timer',
      params: {
        'p_room_id': roomId,
        'p_extension_seconds': 30, // Each message adds 30 seconds
      },
    );
  }

  // Join room and extend timer
  Future<void> joinRoom(String roomId) async {
    await _client.rpc(
      'extend_room_timer',
      params: {
        'p_room_id': roomId,
        'p_extension_seconds': 60, // New join adds 60 seconds
      },
    );
  }
}
