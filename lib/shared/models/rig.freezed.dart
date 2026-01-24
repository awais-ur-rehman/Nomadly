// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rig.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Rig _$RigFromJson(Map<String, dynamic> json) {
  return _Rig.fromJson(json);
}

/// @nodoc
mixin _$Rig {
  String get type =>
      throw _privateConstructorUsedError; // 'sprinter', 'skoolie', 'suv', 'truck_camper'
  String get crewType =>
      throw _privateConstructorUsedError; // 'solo', 'couple', 'with_pets'
  bool get petFriendly => throw _privateConstructorUsedError;

  /// Serializes this Rig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Rig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RigCopyWith<Rig> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RigCopyWith<$Res> {
  factory $RigCopyWith(Rig value, $Res Function(Rig) then) =
      _$RigCopyWithImpl<$Res, Rig>;
  @useResult
  $Res call({String type, String crewType, bool petFriendly});
}

/// @nodoc
class _$RigCopyWithImpl<$Res, $Val extends Rig> implements $RigCopyWith<$Res> {
  _$RigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Rig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? crewType = null,
    Object? petFriendly = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            crewType: null == crewType
                ? _value.crewType
                : crewType // ignore: cast_nullable_to_non_nullable
                      as String,
            petFriendly: null == petFriendly
                ? _value.petFriendly
                : petFriendly // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RigImplCopyWith<$Res> implements $RigCopyWith<$Res> {
  factory _$$RigImplCopyWith(_$RigImpl value, $Res Function(_$RigImpl) then) =
      __$$RigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String crewType, bool petFriendly});
}

/// @nodoc
class __$$RigImplCopyWithImpl<$Res> extends _$RigCopyWithImpl<$Res, _$RigImpl>
    implements _$$RigImplCopyWith<$Res> {
  __$$RigImplCopyWithImpl(_$RigImpl _value, $Res Function(_$RigImpl) _then)
    : super(_value, _then);

  /// Create a copy of Rig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? crewType = null,
    Object? petFriendly = null,
  }) {
    return _then(
      _$RigImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        crewType: null == crewType
            ? _value.crewType
            : crewType // ignore: cast_nullable_to_non_nullable
                  as String,
        petFriendly: null == petFriendly
            ? _value.petFriendly
            : petFriendly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RigImpl implements _Rig {
  const _$RigImpl({
    required this.type,
    required this.crewType,
    this.petFriendly = false,
  });

  factory _$RigImpl.fromJson(Map<String, dynamic> json) =>
      _$$RigImplFromJson(json);

  @override
  final String type;
  // 'sprinter', 'skoolie', 'suv', 'truck_camper'
  @override
  final String crewType;
  // 'solo', 'couple', 'with_pets'
  @override
  @JsonKey()
  final bool petFriendly;

  @override
  String toString() {
    return 'Rig(type: $type, crewType: $crewType, petFriendly: $petFriendly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.crewType, crewType) ||
                other.crewType == crewType) &&
            (identical(other.petFriendly, petFriendly) ||
                other.petFriendly == petFriendly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, crewType, petFriendly);

  /// Create a copy of Rig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RigImplCopyWith<_$RigImpl> get copyWith =>
      __$$RigImplCopyWithImpl<_$RigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RigImplToJson(this);
  }
}

abstract class _Rig implements Rig {
  const factory _Rig({
    required final String type,
    required final String crewType,
    final bool petFriendly,
  }) = _$RigImpl;

  factory _Rig.fromJson(Map<String, dynamic> json) = _$RigImpl.fromJson;

  @override
  String get type; // 'sprinter', 'skoolie', 'suv', 'truck_camper'
  @override
  String get crewType; // 'solo', 'couple', 'with_pets'
  @override
  bool get petFriendly;

  /// Create a copy of Rig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RigImplCopyWith<_$RigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
