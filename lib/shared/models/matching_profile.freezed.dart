// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matching_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchingProfile _$MatchingProfileFromJson(Map<String, dynamic> json) {
  return _MatchingProfile.fromJson(json);
}

/// @nodoc
mixin _$MatchingProfile {
  String get intent => throw _privateConstructorUsedError;
  MatchingPreferences get preferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_discoverable')
  bool get isDiscoverable => throw _privateConstructorUsedError;

  /// Serializes this MatchingProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchingProfileCopyWith<MatchingProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingProfileCopyWith<$Res> {
  factory $MatchingProfileCopyWith(
    MatchingProfile value,
    $Res Function(MatchingProfile) then,
  ) = _$MatchingProfileCopyWithImpl<$Res, MatchingProfile>;
  @useResult
  $Res call({
    String intent,
    MatchingPreferences preferences,
    @JsonKey(name: 'is_discoverable') bool isDiscoverable,
  });

  $MatchingPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$MatchingProfileCopyWithImpl<$Res, $Val extends MatchingProfile>
    implements $MatchingProfileCopyWith<$Res> {
  _$MatchingProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intent = null,
    Object? preferences = null,
    Object? isDiscoverable = null,
  }) {
    return _then(
      _value.copyWith(
            intent: null == intent
                ? _value.intent
                : intent // ignore: cast_nullable_to_non_nullable
                      as String,
            preferences: null == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as MatchingPreferences,
            isDiscoverable: null == isDiscoverable
                ? _value.isDiscoverable
                : isDiscoverable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchingPreferencesCopyWith<$Res> get preferences {
    return $MatchingPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchingProfileImplCopyWith<$Res>
    implements $MatchingProfileCopyWith<$Res> {
  factory _$$MatchingProfileImplCopyWith(
    _$MatchingProfileImpl value,
    $Res Function(_$MatchingProfileImpl) then,
  ) = __$$MatchingProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String intent,
    MatchingPreferences preferences,
    @JsonKey(name: 'is_discoverable') bool isDiscoverable,
  });

  @override
  $MatchingPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$MatchingProfileImplCopyWithImpl<$Res>
    extends _$MatchingProfileCopyWithImpl<$Res, _$MatchingProfileImpl>
    implements _$$MatchingProfileImplCopyWith<$Res> {
  __$$MatchingProfileImplCopyWithImpl(
    _$MatchingProfileImpl _value,
    $Res Function(_$MatchingProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intent = null,
    Object? preferences = null,
    Object? isDiscoverable = null,
  }) {
    return _then(
      _$MatchingProfileImpl(
        intent: null == intent
            ? _value.intent
            : intent // ignore: cast_nullable_to_non_nullable
                  as String,
        preferences: null == preferences
            ? _value.preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as MatchingPreferences,
        isDiscoverable: null == isDiscoverable
            ? _value.isDiscoverable
            : isDiscoverable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchingProfileImpl implements _MatchingProfile {
  const _$MatchingProfileImpl({
    this.intent = 'friends',
    this.preferences = const MatchingPreferences(),
    @JsonKey(name: 'is_discoverable') this.isDiscoverable = true,
  });

  factory _$MatchingProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchingProfileImplFromJson(json);

  @override
  @JsonKey()
  final String intent;
  @override
  @JsonKey()
  final MatchingPreferences preferences;
  @override
  @JsonKey(name: 'is_discoverable')
  final bool isDiscoverable;

  @override
  String toString() {
    return 'MatchingProfile(intent: $intent, preferences: $preferences, isDiscoverable: $isDiscoverable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchingProfileImpl &&
            (identical(other.intent, intent) || other.intent == intent) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            (identical(other.isDiscoverable, isDiscoverable) ||
                other.isDiscoverable == isDiscoverable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, intent, preferences, isDiscoverable);

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchingProfileImplCopyWith<_$MatchingProfileImpl> get copyWith =>
      __$$MatchingProfileImplCopyWithImpl<_$MatchingProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchingProfileImplToJson(this);
  }
}

abstract class _MatchingProfile implements MatchingProfile {
  const factory _MatchingProfile({
    final String intent,
    final MatchingPreferences preferences,
    @JsonKey(name: 'is_discoverable') final bool isDiscoverable,
  }) = _$MatchingProfileImpl;

  factory _MatchingProfile.fromJson(Map<String, dynamic> json) =
      _$MatchingProfileImpl.fromJson;

  @override
  String get intent;
  @override
  MatchingPreferences get preferences;
  @override
  @JsonKey(name: 'is_discoverable')
  bool get isDiscoverable;

  /// Create a copy of MatchingProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchingProfileImplCopyWith<_$MatchingProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchingPreferences _$MatchingPreferencesFromJson(Map<String, dynamic> json) {
  return _MatchingPreferences.fromJson(json);
}

/// @nodoc
mixin _$MatchingPreferences {
  @JsonKey(name: 'gender_interest')
  List<String> get genderInterest => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_age')
  int get minAge => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_age')
  int get maxAge => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_distance_km')
  int get maxDistanceKm => throw _privateConstructorUsedError;

  /// Serializes this MatchingPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchingPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchingPreferencesCopyWith<MatchingPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingPreferencesCopyWith<$Res> {
  factory $MatchingPreferencesCopyWith(
    MatchingPreferences value,
    $Res Function(MatchingPreferences) then,
  ) = _$MatchingPreferencesCopyWithImpl<$Res, MatchingPreferences>;
  @useResult
  $Res call({
    @JsonKey(name: 'gender_interest') List<String> genderInterest,
    @JsonKey(name: 'min_age') int minAge,
    @JsonKey(name: 'max_age') int maxAge,
    @JsonKey(name: 'max_distance_km') int maxDistanceKm,
  });
}

/// @nodoc
class _$MatchingPreferencesCopyWithImpl<$Res, $Val extends MatchingPreferences>
    implements $MatchingPreferencesCopyWith<$Res> {
  _$MatchingPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genderInterest = null,
    Object? minAge = null,
    Object? maxAge = null,
    Object? maxDistanceKm = null,
  }) {
    return _then(
      _value.copyWith(
            genderInterest: null == genderInterest
                ? _value.genderInterest
                : genderInterest // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            minAge: null == minAge
                ? _value.minAge
                : minAge // ignore: cast_nullable_to_non_nullable
                      as int,
            maxAge: null == maxAge
                ? _value.maxAge
                : maxAge // ignore: cast_nullable_to_non_nullable
                      as int,
            maxDistanceKm: null == maxDistanceKm
                ? _value.maxDistanceKm
                : maxDistanceKm // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchingPreferencesImplCopyWith<$Res>
    implements $MatchingPreferencesCopyWith<$Res> {
  factory _$$MatchingPreferencesImplCopyWith(
    _$MatchingPreferencesImpl value,
    $Res Function(_$MatchingPreferencesImpl) then,
  ) = __$$MatchingPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'gender_interest') List<String> genderInterest,
    @JsonKey(name: 'min_age') int minAge,
    @JsonKey(name: 'max_age') int maxAge,
    @JsonKey(name: 'max_distance_km') int maxDistanceKm,
  });
}

/// @nodoc
class __$$MatchingPreferencesImplCopyWithImpl<$Res>
    extends _$MatchingPreferencesCopyWithImpl<$Res, _$MatchingPreferencesImpl>
    implements _$$MatchingPreferencesImplCopyWith<$Res> {
  __$$MatchingPreferencesImplCopyWithImpl(
    _$MatchingPreferencesImpl _value,
    $Res Function(_$MatchingPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genderInterest = null,
    Object? minAge = null,
    Object? maxAge = null,
    Object? maxDistanceKm = null,
  }) {
    return _then(
      _$MatchingPreferencesImpl(
        genderInterest: null == genderInterest
            ? _value._genderInterest
            : genderInterest // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        minAge: null == minAge
            ? _value.minAge
            : minAge // ignore: cast_nullable_to_non_nullable
                  as int,
        maxAge: null == maxAge
            ? _value.maxAge
            : maxAge // ignore: cast_nullable_to_non_nullable
                  as int,
        maxDistanceKm: null == maxDistanceKm
            ? _value.maxDistanceKm
            : maxDistanceKm // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchingPreferencesImpl implements _MatchingPreferences {
  const _$MatchingPreferencesImpl({
    @JsonKey(name: 'gender_interest')
    final List<String> genderInterest = const [],
    @JsonKey(name: 'min_age') this.minAge = 18,
    @JsonKey(name: 'max_age') this.maxAge = 100,
    @JsonKey(name: 'max_distance_km') this.maxDistanceKm = 100,
  }) : _genderInterest = genderInterest;

  factory _$MatchingPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchingPreferencesImplFromJson(json);

  final List<String> _genderInterest;
  @override
  @JsonKey(name: 'gender_interest')
  List<String> get genderInterest {
    if (_genderInterest is EqualUnmodifiableListView) return _genderInterest;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genderInterest);
  }

  @override
  @JsonKey(name: 'min_age')
  final int minAge;
  @override
  @JsonKey(name: 'max_age')
  final int maxAge;
  @override
  @JsonKey(name: 'max_distance_km')
  final int maxDistanceKm;

  @override
  String toString() {
    return 'MatchingPreferences(genderInterest: $genderInterest, minAge: $minAge, maxAge: $maxAge, maxDistanceKm: $maxDistanceKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchingPreferencesImpl &&
            const DeepCollectionEquality().equals(
              other._genderInterest,
              _genderInterest,
            ) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_genderInterest),
    minAge,
    maxAge,
    maxDistanceKm,
  );

  /// Create a copy of MatchingPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchingPreferencesImplCopyWith<_$MatchingPreferencesImpl> get copyWith =>
      __$$MatchingPreferencesImplCopyWithImpl<_$MatchingPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchingPreferencesImplToJson(this);
  }
}

abstract class _MatchingPreferences implements MatchingPreferences {
  const factory _MatchingPreferences({
    @JsonKey(name: 'gender_interest') final List<String> genderInterest,
    @JsonKey(name: 'min_age') final int minAge,
    @JsonKey(name: 'max_age') final int maxAge,
    @JsonKey(name: 'max_distance_km') final int maxDistanceKm,
  }) = _$MatchingPreferencesImpl;

  factory _MatchingPreferences.fromJson(Map<String, dynamic> json) =
      _$MatchingPreferencesImpl.fromJson;

  @override
  @JsonKey(name: 'gender_interest')
  List<String> get genderInterest;
  @override
  @JsonKey(name: 'min_age')
  int get minAge;
  @override
  @JsonKey(name: 'max_age')
  int get maxAge;
  @override
  @JsonKey(name: 'max_distance_km')
  int get maxDistanceKm;

  /// Create a copy of MatchingPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchingPreferencesImplCopyWith<_$MatchingPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
