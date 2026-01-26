// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['_id'] as String,
      postId: json['post_id'] as String,
      author: User.fromJson(
        _readAuthor(json, 'author') as Map<String, dynamic>,
      ),
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isPending: json['isPending'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'post_id': instance.postId,
      'author': instance.author,
      'text': instance.text,
      'created_at': instance.createdAt.toIso8601String(),
      'isPending': instance.isPending,
    };
