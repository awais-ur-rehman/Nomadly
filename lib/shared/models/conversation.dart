import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    @JsonKey(name: '_id') required String id,
    @JsonKey(readValue: _readParticipants) @Default([]) List<User> participants,
    @Default('direct') String type, // 'direct', 'group'
    String? lastMessage,
    DateTime? lastMessageTime,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

/// Handle both string IDs and populated user objects in participants array.
Object? _readParticipants(Map json, String key) {
  final raw = json['participants'];
  if (raw == null) return [];
  if (raw is! List) return [];
  return raw.map((item) {
    if (item is String) {
      // Just an ID string - create minimal User object
      return {'_id': item, 'id': item};
    }
    // Already a populated user object
    return item;
  }).toList();
}
