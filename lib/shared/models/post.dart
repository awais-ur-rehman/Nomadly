import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const Post._();

  const factory Post({
    @JsonKey(name: '_id') required String id,
    @JsonKey(readValue: _readAuthor) required User author,
    required String caption,
    @Default([]) List<String> photos,
    @Default([]) List<String> tags,
    @Default('post') String type, // 'post', 'trip', 'activity'
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<String> likes,
    @JsonKey(name: 'comments_count') @Default(0) int commentCount,
    @Default(false) bool isLikedByMe,
  }) = _Post;

  bool get isTrip => type == 'trip';
  bool get isActivity => type == 'activity';
  bool get isRegularPost => type == 'post' || type.isEmpty;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

Object? _readAuthor(Map json, String key) => json['author'] ?? json['author_id'];

@freezed
class Story with _$Story {
  const factory Story({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'asset_url') required String imageUrl,
    @JsonKey(name: 'asset_type') required String type, // 'image' or 'video'
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @Default([]) List<String> viewers,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@freezed
class StoryBundle with _$StoryBundle {
  const StoryBundle._();
  
  const factory StoryBundle({
    @JsonKey(name: 'author') required User user,
    required List<Story> stories,
    @JsonKey(name: 'hasUnviewed') @Default(false) bool hasUnviewed,
  }) = _StoryBundle;

  factory StoryBundle.fromJson(Map<String, dynamic> json) {
    // The backend sends 'hasUnviewed' but we want to invert it to 'allViewed'
    final hasUnviewed = json['hasUnviewed'] as bool? ?? false;
    
    return _StoryBundle(
      user: User.fromJson(json['author'] as Map<String, dynamic>),
      stories: (json['stories'] as List<dynamic>)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasUnviewed: hasUnviewed,
    );
  }
  
  // Helper getter for UI - inverted hasUnviewed
  bool get allViewed => !hasUnviewed;
}

