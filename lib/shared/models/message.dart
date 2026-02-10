import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'sender_id') required User sender,
    required String message,
    @JsonKey(name: 'message_type') @Default('text') String messageType,
    @JsonKey(name: 'read_by') @Default([]) List<String> readBy,
    @JsonKey(name: 'timestamp') required DateTime timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
