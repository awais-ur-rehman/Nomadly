// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(name: '_id', includeIfNull: false)
  String? get idSecondary => throw _privateConstructorUsedError;
  @JsonKey(name: 'id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  Rig? get rig => throw _privateConstructorUsedError;
  TravelRoute? get travelRoute => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_builder')
  bool get isBuilder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_private')
  bool get isPrivate => throw _privateConstructorUsedError;
  @JsonKey(name: 'nomad_id')
  NomadId? get nomadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    @JsonKey(name: '_id', includeIfNull: false) String? idSecondary,
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    String? email,
    String? username,
    String? phone,
    Profile? profile,
    Rig? rig,
    TravelRoute? travelRoute,
    @JsonKey(name: 'is_builder') bool isBuilder,
    @JsonKey(name: 'is_private') bool isPrivate,
    @JsonKey(name: 'nomad_id') NomadId? nomadId,
    @JsonKey(name: 'is_active') bool isActive,
    int followerCount,
    int followingCount,
    bool isFollowing,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });

  $ProfileCopyWith<$Res>? get profile;
  $RigCopyWith<$Res>? get rig;
  $TravelRouteCopyWith<$Res>? get travelRoute;
  $NomadIdCopyWith<$Res>? get nomadId;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSecondary = freezed,
    Object? id = freezed,
    Object? email = freezed,
    Object? username = freezed,
    Object? phone = freezed,
    Object? profile = freezed,
    Object? rig = freezed,
    Object? travelRoute = freezed,
    Object? isBuilder = null,
    Object? isPrivate = null,
    Object? nomadId = freezed,
    Object? isActive = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            idSecondary: freezed == idSecondary
                ? _value.idSecondary
                : idSecondary // ignore: cast_nullable_to_non_nullable
                      as String?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as Profile?,
            rig: freezed == rig
                ? _value.rig
                : rig // ignore: cast_nullable_to_non_nullable
                      as Rig?,
            travelRoute: freezed == travelRoute
                ? _value.travelRoute
                : travelRoute // ignore: cast_nullable_to_non_nullable
                      as TravelRoute?,
            isBuilder: null == isBuilder
                ? _value.isBuilder
                : isBuilder // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            nomadId: freezed == nomadId
                ? _value.nomadId
                : nomadId // ignore: cast_nullable_to_non_nullable
                      as NomadId?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isFollowing: null == isFollowing
                ? _value.isFollowing
                : isFollowing // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RigCopyWith<$Res>? get rig {
    if (_value.rig == null) {
      return null;
    }

    return $RigCopyWith<$Res>(_value.rig!, (value) {
      return _then(_value.copyWith(rig: value) as $Val);
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TravelRouteCopyWith<$Res>? get travelRoute {
    if (_value.travelRoute == null) {
      return null;
    }

    return $TravelRouteCopyWith<$Res>(_value.travelRoute!, (value) {
      return _then(_value.copyWith(travelRoute: value) as $Val);
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NomadIdCopyWith<$Res>? get nomadId {
    if (_value.nomadId == null) {
      return null;
    }

    return $NomadIdCopyWith<$Res>(_value.nomadId!, (value) {
      return _then(_value.copyWith(nomadId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id', includeIfNull: false) String? idSecondary,
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    String? email,
    String? username,
    String? phone,
    Profile? profile,
    Rig? rig,
    TravelRoute? travelRoute,
    @JsonKey(name: 'is_builder') bool isBuilder,
    @JsonKey(name: 'is_private') bool isPrivate,
    @JsonKey(name: 'nomad_id') NomadId? nomadId,
    @JsonKey(name: 'is_active') bool isActive,
    int followerCount,
    int followingCount,
    bool isFollowing,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });

  @override
  $ProfileCopyWith<$Res>? get profile;
  @override
  $RigCopyWith<$Res>? get rig;
  @override
  $TravelRouteCopyWith<$Res>? get travelRoute;
  @override
  $NomadIdCopyWith<$Res>? get nomadId;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSecondary = freezed,
    Object? id = freezed,
    Object? email = freezed,
    Object? username = freezed,
    Object? phone = freezed,
    Object? profile = freezed,
    Object? rig = freezed,
    Object? travelRoute = freezed,
    Object? isBuilder = null,
    Object? isPrivate = null,
    Object? nomadId = freezed,
    Object? isActive = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserImpl(
        idSecondary: freezed == idSecondary
            ? _value.idSecondary
            : idSecondary // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as Profile?,
        rig: freezed == rig
            ? _value.rig
            : rig // ignore: cast_nullable_to_non_nullable
                  as Rig?,
        travelRoute: freezed == travelRoute
            ? _value.travelRoute
            : travelRoute // ignore: cast_nullable_to_non_nullable
                  as TravelRoute?,
        isBuilder: null == isBuilder
            ? _value.isBuilder
            : isBuilder // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        nomadId: freezed == nomadId
            ? _value.nomadId
            : nomadId // ignore: cast_nullable_to_non_nullable
                  as NomadId?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isFollowing: null == isFollowing
            ? _value.isFollowing
            : isFollowing // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({
    @JsonKey(name: '_id', includeIfNull: false) this.idSecondary,
    @JsonKey(name: 'id', includeIfNull: false) this.id,
    this.email,
    this.username,
    this.phone,
    this.profile,
    this.rig,
    this.travelRoute,
    @JsonKey(name: 'is_builder') this.isBuilder = false,
    @JsonKey(name: 'is_private') this.isPrivate = false,
    @JsonKey(name: 'nomad_id') this.nomadId,
    @JsonKey(name: 'is_active') this.isActive = true,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(name: '_id', includeIfNull: false)
  final String? idSecondary;
  @override
  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @override
  final String? email;
  @override
  final String? username;
  @override
  final String? phone;
  @override
  final Profile? profile;
  @override
  final Rig? rig;
  @override
  final TravelRoute? travelRoute;
  @override
  @JsonKey(name: 'is_builder')
  final bool isBuilder;
  @override
  @JsonKey(name: 'is_private')
  final bool isPrivate;
  @override
  @JsonKey(name: 'nomad_id')
  final NomadId? nomadId;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @JsonKey()
  final bool isFollowing;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'User(idSecondary: $idSecondary, id: $id, email: $email, username: $username, phone: $phone, profile: $profile, rig: $rig, travelRoute: $travelRoute, isBuilder: $isBuilder, isPrivate: $isPrivate, nomadId: $nomadId, isActive: $isActive, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.idSecondary, idSecondary) ||
                other.idSecondary == idSecondary) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.rig, rig) || other.rig == rig) &&
            (identical(other.travelRoute, travelRoute) ||
                other.travelRoute == travelRoute) &&
            (identical(other.isBuilder, isBuilder) ||
                other.isBuilder == isBuilder) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.nomadId, nomadId) || other.nomadId == nomadId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    idSecondary,
    id,
    email,
    username,
    phone,
    profile,
    rig,
    travelRoute,
    isBuilder,
    isPrivate,
    nomadId,
    isActive,
    followerCount,
    followingCount,
    isFollowing,
    createdAt,
    updatedAt,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User extends User {
  const factory _User({
    @JsonKey(name: '_id', includeIfNull: false) final String? idSecondary,
    @JsonKey(name: 'id', includeIfNull: false) final String? id,
    final String? email,
    final String? username,
    final String? phone,
    final Profile? profile,
    final Rig? rig,
    final TravelRoute? travelRoute,
    @JsonKey(name: 'is_builder') final bool isBuilder,
    @JsonKey(name: 'is_private') final bool isPrivate,
    @JsonKey(name: 'nomad_id') final NomadId? nomadId,
    @JsonKey(name: 'is_active') final bool isActive,
    final int followerCount,
    final int followingCount,
    final bool isFollowing,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(name: '_id', includeIfNull: false)
  String? get idSecondary;
  @override
  @JsonKey(name: 'id', includeIfNull: false)
  String? get id;
  @override
  String? get email;
  @override
  String? get username;
  @override
  String? get phone;
  @override
  Profile? get profile;
  @override
  Rig? get rig;
  @override
  TravelRoute? get travelRoute;
  @override
  @JsonKey(name: 'is_builder')
  bool get isBuilder;
  @override
  @JsonKey(name: 'is_private')
  bool get isPrivate;
  @override
  @JsonKey(name: 'nomad_id')
  NomadId? get nomadId;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  bool get isFollowing;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
