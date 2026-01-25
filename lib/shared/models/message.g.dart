// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['_id'] as String,
      conversationId: json['conversationId'] as String,
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      message: json['message'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      readBy:
          (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'conversationId': instance.conversationId,
      'sender': instance.sender,
      'message': instance.message,
      'messageType': instance.messageType,
      'readBy': instance.readBy,
      'timestamp': instance.timestamp.toIso8601String(),
    };
