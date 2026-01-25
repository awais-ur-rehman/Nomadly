import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required User author,
    required String content,
    @Default([]) List<String> imageUrls,
    required DateTime createdAt,
    @Default([]) List<String> likes, // List of user IDs
    @Default(0) int commentCount,
    @Default(false) bool isLikedByMe,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required User author,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
