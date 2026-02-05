// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['_id'] as String,
      conversationId: json['conversation_id'] as String,
      sender: User.fromJson(json['sender_id'] as Map<String, dynamic>),
      message: json['message'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      readBy:
          (json['read_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.sender,
      'message': instance.message,
      'message_type': instance.messageType,
      'read_by': instance.readBy,
      'timestamp': instance.timestamp.toIso8601String(),
    };
