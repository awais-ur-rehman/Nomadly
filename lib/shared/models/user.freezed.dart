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
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  Rig? get rig => throw _privateConstructorUsedError;
  TravelRoute? get travelRoute => throw _privateConstructorUsedError;
  bool get isBuilder => throw _privateConstructorUsedError;
  NomadId? get nomadId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
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
    @JsonKey(name: '_id') String id,
    String email,
    String? phone,
    Profile? profile,
    Rig? rig,
    TravelRoute? travelRoute,
    bool isBuilder,
    NomadId? nomadId,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? profile = freezed,
    Object? rig = freezed,
    Object? travelRoute = freezed,
    Object? isBuilder = null,
    Object? nomadId = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
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
            nomadId: freezed == nomadId
                ? _value.nomadId
                : nomadId // ignore: cast_nullable_to_non_nullable
                      as NomadId?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: '_id') String id,
    String email,
    String? phone,
    Profile? profile,
    Rig? rig,
    TravelRoute? travelRoute,
    bool isBuilder,
    NomadId? nomadId,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? profile = freezed,
    Object? rig = freezed,
    Object? travelRoute = freezed,
    Object? isBuilder = null,
    Object? nomadId = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
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
        nomadId: freezed == nomadId
            ? _value.nomadId
            : nomadId // ignore: cast_nullable_to_non_nullable
                  as NomadId?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
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
class _$UserImpl implements _User {
  const _$UserImpl({
    @JsonKey(name: '_id') required this.id,
    required this.email,
    this.phone,
    this.profile,
    this.rig,
    this.travelRoute,
    this.isBuilder = false,
    this.nomadId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final Profile? profile;
  @override
  final Rig? rig;
  @override
  final TravelRoute? travelRoute;
  @override
  @JsonKey()
  final bool isBuilder;
  @override
  final NomadId? nomadId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'User(id: $id, email: $email, phone: $phone, profile: $profile, rig: $rig, travelRoute: $travelRoute, isBuilder: $isBuilder, nomadId: $nomadId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.rig, rig) || other.rig == rig) &&
            (identical(other.travelRoute, travelRoute) ||
                other.travelRoute == travelRoute) &&
            (identical(other.isBuilder, isBuilder) ||
                other.isBuilder == isBuilder) &&
            (identical(other.nomadId, nomadId) || other.nomadId == nomadId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    phone,
    profile,
    rig,
    travelRoute,
    isBuilder,
    nomadId,
    isActive,
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

abstract class _User implements User {
  const factory _User({
    @JsonKey(name: '_id') required final String id,
    required final String email,
    final String? phone,
    final Profile? profile,
    final Rig? rig,
    final TravelRoute? travelRoute,
    final bool isBuilder,
    final NomadId? nomadId,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get email;
  @override
  String? get phone;
  @override
  Profile? get profile;
  @override
  Rig? get rig;
  @override
  TravelRoute? get travelRoute;
  @override
  bool get isBuilder;
  @override
  NomadId? get nomadId;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
