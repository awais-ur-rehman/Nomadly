// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get matchedUserId => throw _privateConstructorUsedError;
  String get swipeAction =>
      throw _privateConstructorUsedError; // 'left', 'right', 'star'
  bool get isMutual => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String matchedUserId,
    String swipeAction,
    bool isMutual,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? matchedUserId = null,
    Object? swipeAction = null,
    Object? isMutual = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            matchedUserId: null == matchedUserId
                ? _value.matchedUserId
                : matchedUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            swipeAction: null == swipeAction
                ? _value.swipeAction
                : swipeAction // ignore: cast_nullable_to_non_nullable
                      as String,
            isMutual: null == isMutual
                ? _value.isMutual
                : isMutual // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
    _$MatchImpl value,
    $Res Function(_$MatchImpl) then,
  ) = __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String matchedUserId,
    String swipeAction,
    bool isMutual,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
    _$MatchImpl _value,
    $Res Function(_$MatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? matchedUserId = null,
    Object? swipeAction = null,
    Object? isMutual = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$MatchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        matchedUserId: null == matchedUserId
            ? _value.matchedUserId
            : matchedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        swipeAction: null == swipeAction
            ? _value.swipeAction
            : swipeAction // ignore: cast_nullable_to_non_nullable
                  as String,
        isMutual: null == isMutual
            ? _value.isMutual
            : isMutual // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl({
    @JsonKey(name: '_id') required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.swipeAction,
    this.isMutual = false,
    this.createdAt,
  });

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String matchedUserId;
  @override
  final String swipeAction;
  // 'left', 'right', 'star'
  @override
  @JsonKey()
  final bool isMutual;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Match(id: $id, userId: $userId, matchedUserId: $matchedUserId, swipeAction: $swipeAction, isMutual: $isMutual, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.matchedUserId, matchedUserId) ||
                other.matchedUserId == matchedUserId) &&
            (identical(other.swipeAction, swipeAction) ||
                other.swipeAction == swipeAction) &&
            (identical(other.isMutual, isMutual) ||
                other.isMutual == isMutual) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    matchedUserId,
    swipeAction,
    isMutual,
    createdAt,
  );

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(this);
  }
}

abstract class _Match implements Match {
  const factory _Match({
    @JsonKey(name: '_id') required final String id,
    required final String userId,
    required final String matchedUserId,
    required final String swipeAction,
    final bool isMutual,
    final DateTime? createdAt,
  }) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get matchedUserId;
  @override
  String get swipeAction; // 'left', 'right', 'star'
  @override
  bool get isMutual;
  @override
  DateTime? get createdAt;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiscoveryUser _$DiscoveryUserFromJson(Map<String, dynamic> json) {
  return _DiscoveryUser.fromJson(json);
}

/// @nodoc
mixin _$DiscoveryUser {
  User get user => throw _privateConstructorUsedError;
  GeoPoint? get intersection => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  List<String> get commonHobbies => throw _privateConstructorUsedError;

  /// Serializes this DiscoveryUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoveryUserCopyWith<DiscoveryUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoveryUserCopyWith<$Res> {
  factory $DiscoveryUserCopyWith(
    DiscoveryUser value,
    $Res Function(DiscoveryUser) then,
  ) = _$DiscoveryUserCopyWithImpl<$Res, DiscoveryUser>;
  @useResult
  $Res call({
    User user,
    GeoPoint? intersection,
    double? distance,
    int? score,
    List<String> commonHobbies,
  });

  $UserCopyWith<$Res> get user;
  $GeoPointCopyWith<$Res>? get intersection;
}

/// @nodoc
class _$DiscoveryUserCopyWithImpl<$Res, $Val extends DiscoveryUser>
    implements $DiscoveryUserCopyWith<$Res> {
  _$DiscoveryUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? intersection = freezed,
    Object? distance = freezed,
    Object? score = freezed,
    Object? commonHobbies = null,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User,
            intersection: freezed == intersection
                ? _value.intersection
                : intersection // ignore: cast_nullable_to_non_nullable
                      as GeoPoint?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
            commonHobbies: null == commonHobbies
                ? _value.commonHobbies
                : commonHobbies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get intersection {
    if (_value.intersection == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_value.intersection!, (value) {
      return _then(_value.copyWith(intersection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscoveryUserImplCopyWith<$Res>
    implements $DiscoveryUserCopyWith<$Res> {
  factory _$$DiscoveryUserImplCopyWith(
    _$DiscoveryUserImpl value,
    $Res Function(_$DiscoveryUserImpl) then,
  ) = __$$DiscoveryUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    User user,
    GeoPoint? intersection,
    double? distance,
    int? score,
    List<String> commonHobbies,
  });

  @override
  $UserCopyWith<$Res> get user;
  @override
  $GeoPointCopyWith<$Res>? get intersection;
}

/// @nodoc
class __$$DiscoveryUserImplCopyWithImpl<$Res>
    extends _$DiscoveryUserCopyWithImpl<$Res, _$DiscoveryUserImpl>
    implements _$$DiscoveryUserImplCopyWith<$Res> {
  __$$DiscoveryUserImplCopyWithImpl(
    _$DiscoveryUserImpl _value,
    $Res Function(_$DiscoveryUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? intersection = freezed,
    Object? distance = freezed,
    Object? score = freezed,
    Object? commonHobbies = null,
  }) {
    return _then(
      _$DiscoveryUserImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        intersection: freezed == intersection
            ? _value.intersection
            : intersection // ignore: cast_nullable_to_non_nullable
                  as GeoPoint?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
        commonHobbies: null == commonHobbies
            ? _value._commonHobbies
            : commonHobbies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscoveryUserImpl implements _DiscoveryUser {
  const _$DiscoveryUserImpl({
    required this.user,
    this.intersection,
    this.distance,
    this.score,
    final List<String> commonHobbies = const [],
  }) : _commonHobbies = commonHobbies;

  factory _$DiscoveryUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscoveryUserImplFromJson(json);

  @override
  final User user;
  @override
  final GeoPoint? intersection;
  @override
  final double? distance;
  @override
  final int? score;
  final List<String> _commonHobbies;
  @override
  @JsonKey()
  List<String> get commonHobbies {
    if (_commonHobbies is EqualUnmodifiableListView) return _commonHobbies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonHobbies);
  }

  @override
  String toString() {
    return 'DiscoveryUser(user: $user, intersection: $intersection, distance: $distance, score: $score, commonHobbies: $commonHobbies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoveryUserImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.intersection, intersection) ||
                other.intersection == intersection) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.score, score) || other.score == score) &&
            const DeepCollectionEquality().equals(
              other._commonHobbies,
              _commonHobbies,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    intersection,
    distance,
    score,
    const DeepCollectionEquality().hash(_commonHobbies),
  );

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoveryUserImplCopyWith<_$DiscoveryUserImpl> get copyWith =>
      __$$DiscoveryUserImplCopyWithImpl<_$DiscoveryUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoveryUserImplToJson(this);
  }
}

abstract class _DiscoveryUser implements DiscoveryUser {
  const factory _DiscoveryUser({
    required final User user,
    final GeoPoint? intersection,
    final double? distance,
    final int? score,
    final List<String> commonHobbies,
  }) = _$DiscoveryUserImpl;

  factory _DiscoveryUser.fromJson(Map<String, dynamic> json) =
      _$DiscoveryUserImpl.fromJson;

  @override
  User get user;
  @override
  GeoPoint? get intersection;
  @override
  double? get distance;
  @override
  int? get score;
  @override
  List<String> get commonHobbies;

  /// Create a copy of DiscoveryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoveryUserImplCopyWith<_$DiscoveryUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
