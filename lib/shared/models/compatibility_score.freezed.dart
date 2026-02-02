// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compatibility_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompatibilityScore _$CompatibilityScoreFromJson(Map<String, dynamic> json) {
  return _CompatibilityScore.fromJson(json);
}

/// @nodoc
mixin _$CompatibilityScore {
  @JsonKey(name: 'route_overlap')
  int get routeOverlap => throw _privateConstructorUsedError;
  @JsonKey(name: 'temporal_overlap')
  int get temporalOverlap => throw _privateConstructorUsedError;
  @JsonKey(name: 'hobby_match')
  int get hobbyMatch => throw _privateConstructorUsedError;
  int get proximity => throw _privateConstructorUsedError;
  int get trust => throw _privateConstructorUsedError;
  @JsonKey(name: 'rig_compatibility')
  int get rigCompatibility => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this CompatibilityScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompatibilityScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompatibilityScoreCopyWith<CompatibilityScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompatibilityScoreCopyWith<$Res> {
  factory $CompatibilityScoreCopyWith(
    CompatibilityScore value,
    $Res Function(CompatibilityScore) then,
  ) = _$CompatibilityScoreCopyWithImpl<$Res, CompatibilityScore>;
  @useResult
  $Res call({
    @JsonKey(name: 'route_overlap') int routeOverlap,
    @JsonKey(name: 'temporal_overlap') int temporalOverlap,
    @JsonKey(name: 'hobby_match') int hobbyMatch,
    int proximity,
    int trust,
    @JsonKey(name: 'rig_compatibility') int rigCompatibility,
    int total,
  });
}

/// @nodoc
class _$CompatibilityScoreCopyWithImpl<$Res, $Val extends CompatibilityScore>
    implements $CompatibilityScoreCopyWith<$Res> {
  _$CompatibilityScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompatibilityScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routeOverlap = null,
    Object? temporalOverlap = null,
    Object? hobbyMatch = null,
    Object? proximity = null,
    Object? trust = null,
    Object? rigCompatibility = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            routeOverlap: null == routeOverlap
                ? _value.routeOverlap
                : routeOverlap // ignore: cast_nullable_to_non_nullable
                      as int,
            temporalOverlap: null == temporalOverlap
                ? _value.temporalOverlap
                : temporalOverlap // ignore: cast_nullable_to_non_nullable
                      as int,
            hobbyMatch: null == hobbyMatch
                ? _value.hobbyMatch
                : hobbyMatch // ignore: cast_nullable_to_non_nullable
                      as int,
            proximity: null == proximity
                ? _value.proximity
                : proximity // ignore: cast_nullable_to_non_nullable
                      as int,
            trust: null == trust
                ? _value.trust
                : trust // ignore: cast_nullable_to_non_nullable
                      as int,
            rigCompatibility: null == rigCompatibility
                ? _value.rigCompatibility
                : rigCompatibility // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompatibilityScoreImplCopyWith<$Res>
    implements $CompatibilityScoreCopyWith<$Res> {
  factory _$$CompatibilityScoreImplCopyWith(
    _$CompatibilityScoreImpl value,
    $Res Function(_$CompatibilityScoreImpl) then,
  ) = __$$CompatibilityScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'route_overlap') int routeOverlap,
    @JsonKey(name: 'temporal_overlap') int temporalOverlap,
    @JsonKey(name: 'hobby_match') int hobbyMatch,
    int proximity,
    int trust,
    @JsonKey(name: 'rig_compatibility') int rigCompatibility,
    int total,
  });
}

/// @nodoc
class __$$CompatibilityScoreImplCopyWithImpl<$Res>
    extends _$CompatibilityScoreCopyWithImpl<$Res, _$CompatibilityScoreImpl>
    implements _$$CompatibilityScoreImplCopyWith<$Res> {
  __$$CompatibilityScoreImplCopyWithImpl(
    _$CompatibilityScoreImpl _value,
    $Res Function(_$CompatibilityScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompatibilityScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routeOverlap = null,
    Object? temporalOverlap = null,
    Object? hobbyMatch = null,
    Object? proximity = null,
    Object? trust = null,
    Object? rigCompatibility = null,
    Object? total = null,
  }) {
    return _then(
      _$CompatibilityScoreImpl(
        routeOverlap: null == routeOverlap
            ? _value.routeOverlap
            : routeOverlap // ignore: cast_nullable_to_non_nullable
                  as int,
        temporalOverlap: null == temporalOverlap
            ? _value.temporalOverlap
            : temporalOverlap // ignore: cast_nullable_to_non_nullable
                  as int,
        hobbyMatch: null == hobbyMatch
            ? _value.hobbyMatch
            : hobbyMatch // ignore: cast_nullable_to_non_nullable
                  as int,
        proximity: null == proximity
            ? _value.proximity
            : proximity // ignore: cast_nullable_to_non_nullable
                  as int,
        trust: null == trust
            ? _value.trust
            : trust // ignore: cast_nullable_to_non_nullable
                  as int,
        rigCompatibility: null == rigCompatibility
            ? _value.rigCompatibility
            : rigCompatibility // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompatibilityScoreImpl implements _CompatibilityScore {
  const _$CompatibilityScoreImpl({
    @JsonKey(name: 'route_overlap') this.routeOverlap = 0,
    @JsonKey(name: 'temporal_overlap') this.temporalOverlap = 0,
    @JsonKey(name: 'hobby_match') this.hobbyMatch = 0,
    this.proximity = 0,
    this.trust = 0,
    @JsonKey(name: 'rig_compatibility') this.rigCompatibility = 0,
    this.total = 0,
  });

  factory _$CompatibilityScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompatibilityScoreImplFromJson(json);

  @override
  @JsonKey(name: 'route_overlap')
  final int routeOverlap;
  @override
  @JsonKey(name: 'temporal_overlap')
  final int temporalOverlap;
  @override
  @JsonKey(name: 'hobby_match')
  final int hobbyMatch;
  @override
  @JsonKey()
  final int proximity;
  @override
  @JsonKey()
  final int trust;
  @override
  @JsonKey(name: 'rig_compatibility')
  final int rigCompatibility;
  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'CompatibilityScore(routeOverlap: $routeOverlap, temporalOverlap: $temporalOverlap, hobbyMatch: $hobbyMatch, proximity: $proximity, trust: $trust, rigCompatibility: $rigCompatibility, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompatibilityScoreImpl &&
            (identical(other.routeOverlap, routeOverlap) ||
                other.routeOverlap == routeOverlap) &&
            (identical(other.temporalOverlap, temporalOverlap) ||
                other.temporalOverlap == temporalOverlap) &&
            (identical(other.hobbyMatch, hobbyMatch) ||
                other.hobbyMatch == hobbyMatch) &&
            (identical(other.proximity, proximity) ||
                other.proximity == proximity) &&
            (identical(other.trust, trust) || other.trust == trust) &&
            (identical(other.rigCompatibility, rigCompatibility) ||
                other.rigCompatibility == rigCompatibility) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    routeOverlap,
    temporalOverlap,
    hobbyMatch,
    proximity,
    trust,
    rigCompatibility,
    total,
  );

  /// Create a copy of CompatibilityScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompatibilityScoreImplCopyWith<_$CompatibilityScoreImpl> get copyWith =>
      __$$CompatibilityScoreImplCopyWithImpl<_$CompatibilityScoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompatibilityScoreImplToJson(this);
  }
}

abstract class _CompatibilityScore implements CompatibilityScore {
  const factory _CompatibilityScore({
    @JsonKey(name: 'route_overlap') final int routeOverlap,
    @JsonKey(name: 'temporal_overlap') final int temporalOverlap,
    @JsonKey(name: 'hobby_match') final int hobbyMatch,
    final int proximity,
    final int trust,
    @JsonKey(name: 'rig_compatibility') final int rigCompatibility,
    final int total,
  }) = _$CompatibilityScoreImpl;

  factory _CompatibilityScore.fromJson(Map<String, dynamic> json) =
      _$CompatibilityScoreImpl.fromJson;

  @override
  @JsonKey(name: 'route_overlap')
  int get routeOverlap;
  @override
  @JsonKey(name: 'temporal_overlap')
  int get temporalOverlap;
  @override
  @JsonKey(name: 'hobby_match')
  int get hobbyMatch;
  @override
  int get proximity;
  @override
  int get trust;
  @override
  @JsonKey(name: 'rig_compatibility')
  int get rigCompatibility;
  @override
  int get total;

  /// Create a copy of CompatibilityScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompatibilityScoreImplCopyWith<_$CompatibilityScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
