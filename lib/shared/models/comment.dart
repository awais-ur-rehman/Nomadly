import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(readValue: _readAuthor) required User author,
    required String text,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(false) bool isPending, // For optimistic updates
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

Object? _readAuthor(Map json, String key) => json['author'] ?? json['author_id'];
