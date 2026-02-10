// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommended_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecommendedUser _$RecommendedUserFromJson(Map<String, dynamic> json) {
  return _RecommendedUser.fromJson(json);
}

/// @nodoc
mixin _$RecommendedUser {
  User get user => throw _privateConstructorUsedError;
  CompatibilityScore? get compatibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;

  /// Serializes this RecommendedUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedUserCopyWith<RecommendedUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedUserCopyWith<$Res> {
  factory $RecommendedUserCopyWith(
    RecommendedUser value,
    $Res Function(RecommendedUser) then,
  ) = _$RecommendedUserCopyWithImpl<$Res, RecommendedUser>;
  @useResult
  $Res call({
    User user,
    CompatibilityScore? compatibility,
    @JsonKey(name: 'distance_km') double? distanceKm,
  });

  $UserCopyWith<$Res> get user;
  $CompatibilityScoreCopyWith<$Res>? get compatibility;
}

/// @nodoc
class _$RecommendedUserCopyWithImpl<$Res, $Val extends RecommendedUser>
    implements $RecommendedUserCopyWith<$Res> {
  _$RecommendedUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? compatibility = freezed,
    Object? distanceKm = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User,
            compatibility: freezed == compatibility
                ? _value.compatibility
                : compatibility // ignore: cast_nullable_to_non_nullable
                      as CompatibilityScore?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompatibilityScoreCopyWith<$Res>? get compatibility {
    if (_value.compatibility == null) {
      return null;
    }

    return $CompatibilityScoreCopyWith<$Res>(_value.compatibility!, (value) {
      return _then(_value.copyWith(compatibility: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendedUserImplCopyWith<$Res>
    implements $RecommendedUserCopyWith<$Res> {
  factory _$$RecommendedUserImplCopyWith(
    _$RecommendedUserImpl value,
    $Res Function(_$RecommendedUserImpl) then,
  ) = __$$RecommendedUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    User user,
    CompatibilityScore? compatibility,
    @JsonKey(name: 'distance_km') double? distanceKm,
  });

  @override
  $UserCopyWith<$Res> get user;
  @override
  $CompatibilityScoreCopyWith<$Res>? get compatibility;
}

/// @nodoc
class __$$RecommendedUserImplCopyWithImpl<$Res>
    extends _$RecommendedUserCopyWithImpl<$Res, _$RecommendedUserImpl>
    implements _$$RecommendedUserImplCopyWith<$Res> {
  __$$RecommendedUserImplCopyWithImpl(
    _$RecommendedUserImpl _value,
    $Res Function(_$RecommendedUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? compatibility = freezed,
    Object? distanceKm = freezed,
  }) {
    return _then(
      _$RecommendedUserImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        compatibility: freezed == compatibility
            ? _value.compatibility
            : compatibility // ignore: cast_nullable_to_non_nullable
                  as CompatibilityScore?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedUserImpl extends _RecommendedUser {
  const _$RecommendedUserImpl({
    required this.user,
    this.compatibility,
    @JsonKey(name: 'distance_km') this.distanceKm,
  }) : super._();

  factory _$RecommendedUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedUserImplFromJson(json);

  @override
  final User user;
  @override
  final CompatibilityScore? compatibility;
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;

  @override
  String toString() {
    return 'RecommendedUser(user: $user, compatibility: $compatibility, distanceKm: $distanceKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedUserImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.compatibility, compatibility) ||
                other.compatibility == compatibility) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, compatibility, distanceKm);

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedUserImplCopyWith<_$RecommendedUserImpl> get copyWith =>
      __$$RecommendedUserImplCopyWithImpl<_$RecommendedUserImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedUserImplToJson(this);
  }
}

abstract class _RecommendedUser extends RecommendedUser {
  const factory _RecommendedUser({
    required final User user,
    final CompatibilityScore? compatibility,
    @JsonKey(name: 'distance_km') final double? distanceKm,
  }) = _$RecommendedUserImpl;
  const _RecommendedUser._() : super._();

  factory _RecommendedUser.fromJson(Map<String, dynamic> json) =
      _$RecommendedUserImpl.fromJson;

  @override
  User get user;
  @override
  CompatibilityScore? get compatibility;
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm;

  /// Create a copy of RecommendedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedUserImplCopyWith<_$RecommendedUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
