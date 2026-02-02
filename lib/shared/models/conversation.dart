import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    @JsonKey(name: '_id') required String id,
    @Default([]) List<User> participants,
    @Default('direct') String type, // 'direct', 'group'
    String? lastMessage,
    DateTime? lastMessageTime,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
