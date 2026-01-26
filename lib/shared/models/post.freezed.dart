// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readAuthor)
  User get author => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;
  @JsonKey(name: 'comments_count')
  int get commentCount => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(readValue: _readAuthor) User author,
    String caption,
    List<String> photos,
    List<String> tags,
    @JsonKey(name: 'created_at') DateTime createdAt,
    List<String> likes,
    @JsonKey(name: 'comments_count') int commentCount,
    bool isLikedByMe,
  });

  $UserCopyWith<$Res> get author;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? caption = null,
    Object? photos = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? likes = null,
    Object? commentCount = null,
    Object? isLikedByMe = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as User,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLikedByMe: null == isLikedByMe
                ? _value.isLikedByMe
                : isLikedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get author {
    return $UserCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
    _$PostImpl value,
    $Res Function(_$PostImpl) then,
  ) = __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(readValue: _readAuthor) User author,
    String caption,
    List<String> photos,
    List<String> tags,
    @JsonKey(name: 'created_at') DateTime createdAt,
    List<String> likes,
    @JsonKey(name: 'comments_count') int commentCount,
    bool isLikedByMe,
  });

  @override
  $UserCopyWith<$Res> get author;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
    : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? caption = null,
    Object? photos = null,
    Object? tags = null,
    Object? createdAt = null,
    Object? likes = null,
    Object? commentCount = null,
    Object? isLikedByMe = null,
  }) {
    return _then(
      _$PostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as User,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        likes: null == likes
            ? _value._likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLikedByMe: null == isLikedByMe
            ? _value.isLikedByMe
            : isLikedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl implements _Post {
  const _$PostImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(readValue: _readAuthor) required this.author,
    required this.caption,
    final List<String> photos = const [],
    final List<String> tags = const [],
    @JsonKey(name: 'created_at') required this.createdAt,
    final List<String> likes = const [],
    @JsonKey(name: 'comments_count') this.commentCount = 0,
    this.isLikedByMe = false,
  }) : _photos = photos,
       _tags = tags,
       _likes = likes;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(readValue: _readAuthor)
  final User author;
  @override
  final String caption;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<String> _likes;
  @override
  @JsonKey()
  List<String> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  @override
  @JsonKey(name: 'comments_count')
  final int commentCount;
  @override
  @JsonKey()
  final bool isLikedByMe;

  @override
  String toString() {
    return 'Post(id: $id, author: $author, caption: $caption, photos: $photos, tags: $tags, createdAt: $createdAt, likes: $likes, commentCount: $commentCount, isLikedByMe: $isLikedByMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    author,
    caption,
    const DeepCollectionEquality().hash(_photos),
    const DeepCollectionEquality().hash(_tags),
    createdAt,
    const DeepCollectionEquality().hash(_likes),
    commentCount,
    isLikedByMe,
  );

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(this);
  }
}

abstract class _Post implements Post {
  const factory _Post({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(readValue: _readAuthor) required final User author,
    required final String caption,
    final List<String> photos,
    final List<String> tags,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final List<String> likes,
    @JsonKey(name: 'comments_count') final int commentCount,
    final bool isLikedByMe,
  }) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(readValue: _readAuthor)
  User get author;
  @override
  String get caption;
  @override
  List<String> get photos;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  List<String> get likes;
  @override
  @JsonKey(name: 'comments_count')
  int get commentCount;
  @override
  bool get isLikedByMe;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Story _$StoryFromJson(Map<String, dynamic> json) {
  return _Story.fromJson(json);
}

/// @nodoc
mixin _$Story {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_type')
  String get type => throw _privateConstructorUsedError; // 'image' or 'video'
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  List<String> get viewers => throw _privateConstructorUsedError;

  /// Serializes this Story to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryCopyWith<Story> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCopyWith<$Res> {
  factory $StoryCopyWith(Story value, $Res Function(Story) then) =
      _$StoryCopyWithImpl<$Res, Story>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'asset_url') String imageUrl,
    @JsonKey(name: 'asset_type') String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    List<String> viewers,
  });
}

/// @nodoc
class _$StoryCopyWithImpl<$Res, $Val extends Story>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? expiresAt = null,
    Object? viewers = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            viewers: null == viewers
                ? _value.viewers
                : viewers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryImplCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$$StoryImplCopyWith(
    _$StoryImpl value,
    $Res Function(_$StoryImpl) then,
  ) = __$$StoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'asset_url') String imageUrl,
    @JsonKey(name: 'asset_type') String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    List<String> viewers,
  });
}

/// @nodoc
class __$$StoryImplCopyWithImpl<$Res>
    extends _$StoryCopyWithImpl<$Res, _$StoryImpl>
    implements _$$StoryImplCopyWith<$Res> {
  __$$StoryImplCopyWithImpl(
    _$StoryImpl _value,
    $Res Function(_$StoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? expiresAt = null,
    Object? viewers = null,
  }) {
    return _then(
      _$StoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        viewers: null == viewers
            ? _value._viewers
            : viewers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryImpl implements _Story {
  const _$StoryImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'asset_url') required this.imageUrl,
    @JsonKey(name: 'asset_type') required this.type,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'expires_at') required this.expiresAt,
    final List<String> viewers = const [],
  }) : _viewers = viewers;

  factory _$StoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'asset_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'asset_type')
  final String type;
  // 'image' or 'video'
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  final List<String> _viewers;
  @override
  @JsonKey()
  List<String> get viewers {
    if (_viewers is EqualUnmodifiableListView) return _viewers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewers);
  }

  @override
  String toString() {
    return 'Story(id: $id, imageUrl: $imageUrl, type: $type, createdAt: $createdAt, expiresAt: $expiresAt, viewers: $viewers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._viewers, _viewers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    type,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_viewers),
  );

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      __$$StoryImplCopyWithImpl<_$StoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryImplToJson(this);
  }
}

abstract class _Story implements Story {
  const factory _Story({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'asset_url') required final String imageUrl,
    @JsonKey(name: 'asset_type') required final String type,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'expires_at') required final DateTime expiresAt,
    final List<String> viewers,
  }) = _$StoryImpl;

  factory _Story.fromJson(Map<String, dynamic> json) = _$StoryImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'asset_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'asset_type')
  String get type; // 'image' or 'video'
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  List<String> get viewers;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StoryBundle {
  @JsonKey(name: 'author')
  User get user => throw _privateConstructorUsedError;
  List<Story> get stories => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasUnviewed')
  bool get hasUnviewed => throw _privateConstructorUsedError;

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryBundleCopyWith<StoryBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryBundleCopyWith<$Res> {
  factory $StoryBundleCopyWith(
    StoryBundle value,
    $Res Function(StoryBundle) then,
  ) = _$StoryBundleCopyWithImpl<$Res, StoryBundle>;
  @useResult
  $Res call({
    @JsonKey(name: 'author') User user,
    List<Story> stories,
    @JsonKey(name: 'hasUnviewed') bool hasUnviewed,
  });

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$StoryBundleCopyWithImpl<$Res, $Val extends StoryBundle>
    implements $StoryBundleCopyWith<$Res> {
  _$StoryBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? stories = null,
    Object? hasUnviewed = null,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User,
            stories: null == stories
                ? _value.stories
                : stories // ignore: cast_nullable_to_non_nullable
                      as List<Story>,
            hasUnviewed: null == hasUnviewed
                ? _value.hasUnviewed
                : hasUnviewed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryBundleImplCopyWith<$Res>
    implements $StoryBundleCopyWith<$Res> {
  factory _$$StoryBundleImplCopyWith(
    _$StoryBundleImpl value,
    $Res Function(_$StoryBundleImpl) then,
  ) = __$$StoryBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'author') User user,
    List<Story> stories,
    @JsonKey(name: 'hasUnviewed') bool hasUnviewed,
  });

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$StoryBundleImplCopyWithImpl<$Res>
    extends _$StoryBundleCopyWithImpl<$Res, _$StoryBundleImpl>
    implements _$$StoryBundleImplCopyWith<$Res> {
  __$$StoryBundleImplCopyWithImpl(
    _$StoryBundleImpl _value,
    $Res Function(_$StoryBundleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? stories = null,
    Object? hasUnviewed = null,
  }) {
    return _then(
      _$StoryBundleImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        stories: null == stories
            ? _value._stories
            : stories // ignore: cast_nullable_to_non_nullable
                  as List<Story>,
        hasUnviewed: null == hasUnviewed
            ? _value.hasUnviewed
            : hasUnviewed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$StoryBundleImpl extends _StoryBundle {
  const _$StoryBundleImpl({
    @JsonKey(name: 'author') required this.user,
    required final List<Story> stories,
    @JsonKey(name: 'hasUnviewed') this.hasUnviewed = false,
  }) : _stories = stories,
       super._();

  @override
  @JsonKey(name: 'author')
  final User user;
  final List<Story> _stories;
  @override
  List<Story> get stories {
    if (_stories is EqualUnmodifiableListView) return _stories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stories);
  }

  @override
  @JsonKey(name: 'hasUnviewed')
  final bool hasUnviewed;

  @override
  String toString() {
    return 'StoryBundle(user: $user, stories: $stories, hasUnviewed: $hasUnviewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryBundleImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._stories, _stories) &&
            (identical(other.hasUnviewed, hasUnviewed) ||
                other.hasUnviewed == hasUnviewed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    const DeepCollectionEquality().hash(_stories),
    hasUnviewed,
  );

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryBundleImplCopyWith<_$StoryBundleImpl> get copyWith =>
      __$$StoryBundleImplCopyWithImpl<_$StoryBundleImpl>(this, _$identity);
}

abstract class _StoryBundle extends StoryBundle {
  const factory _StoryBundle({
    @JsonKey(name: 'author') required final User user,
    required final List<Story> stories,
    @JsonKey(name: 'hasUnviewed') final bool hasUnviewed,
  }) = _$StoryBundleImpl;
  const _StoryBundle._() : super._();

  @override
  @JsonKey(name: 'author')
  User get user;
  @override
  List<Story> get stories;
  @override
  @JsonKey(name: 'hasUnviewed')
  bool get hasUnviewed;

  /// Create a copy of StoryBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryBundleImplCopyWith<_$StoryBundleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
