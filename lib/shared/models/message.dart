import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(name: '_id') required String id,
    required String conversationId,
    required User sender,
    required String message,
    @Default('text') String messageType, // 'text', 'image', 'location'
    @Default([]) List<String> readBy,
    required DateTime timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
