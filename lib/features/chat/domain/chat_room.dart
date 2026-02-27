class ChatRoom {
  final String id;
  final String roomName;
  final String creatorId;
  final DateTime expirationTimestamp;
  final DateTime maxExpirationTimestamp;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.roomName,
    required this.creatorId,
    required this.expirationTimestamp,
    required this.maxExpirationTimestamp,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      roomName: json['room_name'],
      creatorId: json['creator_id'],
      expirationTimestamp: DateTime.parse(json['expiration_timestamp']),
      maxExpirationTimestamp: DateTime.parse(json['max_expiration_timestamp']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  int get remainingSeconds => expirationTimestamp
      .difference(DateTime.now())
      .inSeconds
      .clamp(0, maxExpirationTimestamp.difference(createdAt).inSeconds);
  int get totalSeconds =>
      maxExpirationTimestamp.difference(createdAt).inSeconds;
}
