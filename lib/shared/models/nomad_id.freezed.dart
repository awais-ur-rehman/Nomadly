// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nomad_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NomadId _$NomadIdFromJson(Map<String, dynamic> json) {
  return _NomadId.fromJson(json);
}

/// @nodoc
mixin _$NomadId {
  bool get verified => throw _privateConstructorUsedError;
  DateTime get memberSince => throw _privateConstructorUsedError;
  int get vouchCount => throw _privateConstructorUsedError;

  /// Serializes this NomadId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NomadId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NomadIdCopyWith<NomadId> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NomadIdCopyWith<$Res> {
  factory $NomadIdCopyWith(NomadId value, $Res Function(NomadId) then) =
      _$NomadIdCopyWithImpl<$Res, NomadId>;
  @useResult
  $Res call({bool verified, DateTime memberSince, int vouchCount});
}

/// @nodoc
class _$NomadIdCopyWithImpl<$Res, $Val extends NomadId>
    implements $NomadIdCopyWith<$Res> {
  _$NomadIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NomadId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verified = null,
    Object? memberSince = null,
    Object? vouchCount = null,
  }) {
    return _then(
      _value.copyWith(
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            memberSince: null == memberSince
                ? _value.memberSince
                : memberSince // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            vouchCount: null == vouchCount
                ? _value.vouchCount
                : vouchCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NomadIdImplCopyWith<$Res> implements $NomadIdCopyWith<$Res> {
  factory _$$NomadIdImplCopyWith(
    _$NomadIdImpl value,
    $Res Function(_$NomadIdImpl) then,
  ) = __$$NomadIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool verified, DateTime memberSince, int vouchCount});
}

/// @nodoc
class __$$NomadIdImplCopyWithImpl<$Res>
    extends _$NomadIdCopyWithImpl<$Res, _$NomadIdImpl>
    implements _$$NomadIdImplCopyWith<$Res> {
  __$$NomadIdImplCopyWithImpl(
    _$NomadIdImpl _value,
    $Res Function(_$NomadIdImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NomadId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verified = null,
    Object? memberSince = null,
    Object? vouchCount = null,
  }) {
    return _then(
      _$NomadIdImpl(
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        memberSince: null == memberSince
            ? _value.memberSince
            : memberSince // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        vouchCount: null == vouchCount
            ? _value.vouchCount
            : vouchCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NomadIdImpl implements _NomadId {
  const _$NomadIdImpl({
    this.verified = false,
    required this.memberSince,
    this.vouchCount = 0,
  });

  factory _$NomadIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$NomadIdImplFromJson(json);

  @override
  @JsonKey()
  final bool verified;
  @override
  final DateTime memberSince;
  @override
  @JsonKey()
  final int vouchCount;

  @override
  String toString() {
    return 'NomadId(verified: $verified, memberSince: $memberSince, vouchCount: $vouchCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NomadIdImpl &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.memberSince, memberSince) ||
                other.memberSince == memberSince) &&
            (identical(other.vouchCount, vouchCount) ||
                other.vouchCount == vouchCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, verified, memberSince, vouchCount);

  /// Create a copy of NomadId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NomadIdImplCopyWith<_$NomadIdImpl> get copyWith =>
      __$$NomadIdImplCopyWithImpl<_$NomadIdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NomadIdImplToJson(this);
  }
}

abstract class _NomadId implements NomadId {
  const factory _NomadId({
    final bool verified,
    required final DateTime memberSince,
    final int vouchCount,
  }) = _$NomadIdImpl;

  factory _NomadId.fromJson(Map<String, dynamic> json) = _$NomadIdImpl.fromJson;

  @override
  bool get verified;
  @override
  DateTime get memberSince;
  @override
  int get vouchCount;

  /// Create a copy of NomadId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NomadIdImplCopyWith<_$NomadIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
