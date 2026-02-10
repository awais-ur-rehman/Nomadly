// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'travel_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TravelRoute _$TravelRouteFromJson(Map<String, dynamic> json) {
  return _TravelRoute.fromJson(json);
}

/// @nodoc
mixin _$TravelRoute {
  GeoPoint? get origin => throw _privateConstructorUsedError;
  GeoPoint? get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int? get durationDays => throw _privateConstructorUsedError;

  /// Serializes this TravelRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TravelRouteCopyWith<TravelRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TravelRouteCopyWith<$Res> {
  factory $TravelRouteCopyWith(
    TravelRoute value,
    $Res Function(TravelRoute) then,
  ) = _$TravelRouteCopyWithImpl<$Res, TravelRoute>;
  @useResult
  $Res call({
    GeoPoint? origin,
    GeoPoint? destination,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'duration_days') int? durationDays,
  });

  $GeoPointCopyWith<$Res>? get origin;
  $GeoPointCopyWith<$Res>? get destination;
}

/// @nodoc
class _$TravelRouteCopyWithImpl<$Res, $Val extends TravelRoute>
    implements $TravelRouteCopyWith<$Res> {
  _$TravelRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? origin = freezed,
    Object? destination = freezed,
    Object? startDate = freezed,
    Object? durationDays = freezed,
  }) {
    return _then(
      _value.copyWith(
            origin: freezed == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as GeoPoint?,
            destination: freezed == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GeoPoint?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationDays: freezed == durationDays
                ? _value.durationDays
                : durationDays // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get origin {
    if (_value.origin == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_value.origin!, (value) {
      return _then(_value.copyWith(origin: value) as $Val);
    });
  }

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get destination {
    if (_value.destination == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_value.destination!, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TravelRouteImplCopyWith<$Res>
    implements $TravelRouteCopyWith<$Res> {
  factory _$$TravelRouteImplCopyWith(
    _$TravelRouteImpl value,
    $Res Function(_$TravelRouteImpl) then,
  ) = __$$TravelRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GeoPoint? origin,
    GeoPoint? destination,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'duration_days') int? durationDays,
  });

  @override
  $GeoPointCopyWith<$Res>? get origin;
  @override
  $GeoPointCopyWith<$Res>? get destination;
}

/// @nodoc
class __$$TravelRouteImplCopyWithImpl<$Res>
    extends _$TravelRouteCopyWithImpl<$Res, _$TravelRouteImpl>
    implements _$$TravelRouteImplCopyWith<$Res> {
  __$$TravelRouteImplCopyWithImpl(
    _$TravelRouteImpl _value,
    $Res Function(_$TravelRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? origin = freezed,
    Object? destination = freezed,
    Object? startDate = freezed,
    Object? durationDays = freezed,
  }) {
    return _then(
      _$TravelRouteImpl(
        origin: freezed == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as GeoPoint?,
        destination: freezed == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as GeoPoint?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationDays: freezed == durationDays
            ? _value.durationDays
            : durationDays // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TravelRouteImpl implements _TravelRoute {
  const _$TravelRouteImpl({
    this.origin,
    this.destination,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'duration_days') this.durationDays,
  });

  factory _$TravelRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$TravelRouteImplFromJson(json);

  @override
  final GeoPoint? origin;
  @override
  final GeoPoint? destination;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'duration_days')
  final int? durationDays;

  @override
  String toString() {
    return 'TravelRoute(origin: $origin, destination: $destination, startDate: $startDate, durationDays: $durationDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TravelRouteImpl &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, origin, destination, startDate, durationDays);

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TravelRouteImplCopyWith<_$TravelRouteImpl> get copyWith =>
      __$$TravelRouteImplCopyWithImpl<_$TravelRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TravelRouteImplToJson(this);
  }
}

abstract class _TravelRoute implements TravelRoute {
  const factory _TravelRoute({
    final GeoPoint? origin,
    final GeoPoint? destination,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'duration_days') final int? durationDays,
  }) = _$TravelRouteImpl;

  factory _TravelRoute.fromJson(Map<String, dynamic> json) =
      _$TravelRouteImpl.fromJson;

  @override
  GeoPoint? get origin;
  @override
  GeoPoint? get destination;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'duration_days')
  int? get durationDays;

  /// Create a copy of TravelRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TravelRouteImplCopyWith<_$TravelRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
