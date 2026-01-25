// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beacon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Beacon _$BeaconFromJson(Map<String, dynamic> json) {
  return _Beacon.fromJson(json);
}

/// @nodoc
mixin _$Beacon {
  String get id => throw _privateConstructorUsedError;
  User get author => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  GeoPoint get location => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;

  /// Serializes this Beacon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BeaconCopyWith<Beacon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeaconCopyWith<$Res> {
  factory $BeaconCopyWith(Beacon value, $Res Function(Beacon) then) =
      _$BeaconCopyWithImpl<$Res, Beacon>;
  @useResult
  $Res call({
    String id,
    User author,
    String message,
    GeoPoint location,
    DateTime createdAt,
    DateTime expiresAt,
    List<String> likes,
  });

  $UserCopyWith<$Res> get author;
  $GeoPointCopyWith<$Res> get location;
}

/// @nodoc
class _$BeaconCopyWithImpl<$Res, $Val extends Beacon>
    implements $BeaconCopyWith<$Res> {
  _$BeaconCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? message = null,
    Object? location = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? likes = null,
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
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as GeoPoint,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get author {
    return $UserCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res> get location {
    return $GeoPointCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BeaconImplCopyWith<$Res> implements $BeaconCopyWith<$Res> {
  factory _$$BeaconImplCopyWith(
    _$BeaconImpl value,
    $Res Function(_$BeaconImpl) then,
  ) = __$$BeaconImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    User author,
    String message,
    GeoPoint location,
    DateTime createdAt,
    DateTime expiresAt,
    List<String> likes,
  });

  @override
  $UserCopyWith<$Res> get author;
  @override
  $GeoPointCopyWith<$Res> get location;
}

/// @nodoc
class __$$BeaconImplCopyWithImpl<$Res>
    extends _$BeaconCopyWithImpl<$Res, _$BeaconImpl>
    implements _$$BeaconImplCopyWith<$Res> {
  __$$BeaconImplCopyWithImpl(
    _$BeaconImpl _value,
    $Res Function(_$BeaconImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? message = null,
    Object? location = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? likes = null,
  }) {
    return _then(
      _$BeaconImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as User,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as GeoPoint,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        likes: null == likes
            ? _value._likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BeaconImpl implements _Beacon {
  const _$BeaconImpl({
    required this.id,
    required this.author,
    required this.message,
    required this.location,
    required this.createdAt,
    required this.expiresAt,
    final List<String> likes = const [],
  }) : _likes = likes;

  factory _$BeaconImpl.fromJson(Map<String, dynamic> json) =>
      _$$BeaconImplFromJson(json);

  @override
  final String id;
  @override
  final User author;
  @override
  final String message;
  @override
  final GeoPoint location;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  final List<String> _likes;
  @override
  @JsonKey()
  List<String> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  @override
  String toString() {
    return 'Beacon(id: $id, author: $author, message: $message, location: $location, createdAt: $createdAt, expiresAt: $expiresAt, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeaconImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._likes, _likes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    author,
    message,
    location,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_likes),
  );

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BeaconImplCopyWith<_$BeaconImpl> get copyWith =>
      __$$BeaconImplCopyWithImpl<_$BeaconImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BeaconImplToJson(this);
  }
}

abstract class _Beacon implements Beacon {
  const factory _Beacon({
    required final String id,
    required final User author,
    required final String message,
    required final GeoPoint location,
    required final DateTime createdAt,
    required final DateTime expiresAt,
    final List<String> likes,
  }) = _$BeaconImpl;

  factory _Beacon.fromJson(Map<String, dynamic> json) = _$BeaconImpl.fromJson;

  @override
  String get id;
  @override
  User get author;
  @override
  String get message;
  @override
  GeoPoint get location;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  List<String> get likes;

  /// Create a copy of Beacon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BeaconImplCopyWith<_$BeaconImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
