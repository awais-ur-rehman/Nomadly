// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  id: json['_id'] as String,
  author: User.fromJson(_readAuthor(json, 'author') as Map<String, dynamic>),
  caption: json['caption'] as String,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  likes:
      (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  commentCount: (json['comments_count'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'author': instance.author,
      'caption': instance.caption,
      'photos': instance.photos,
      'tags': instance.tags,
      'created_at': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
      'comments_count': instance.commentCount,
      'isLikedByMe': instance.isLikedByMe,
    };

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
  id: json['_id'] as String,
  imageUrl: json['asset_url'] as String,
  type: json['asset_type'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  viewers:
      (json['viewers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'asset_url': instance.imageUrl,
      'asset_type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'viewers': instance.viewers,
    };
