// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['_id'] as String,
      participants:
          (_readParticipants(json, 'participants') as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      type: json['type'] as String? ?? 'direct',
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'participants': instance.participants,
      'type': instance.type,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
