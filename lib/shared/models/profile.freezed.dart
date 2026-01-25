// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get name => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  List<String> get hobbies => throw _privateConstructorUsedError;
  String get intent =>
      throw _privateConstructorUsedError; // 'friends', 'dating', 'both'
  String? get bio => throw _privateConstructorUsedError;

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call({
    String name,
    int? age,
    String? gender,
    String? photoUrl,
    List<String> hobbies,
    String intent,
    String? bio,
  });
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? photoUrl = freezed,
    Object? hobbies = null,
    Object? intent = null,
    Object? bio = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            hobbies: null == hobbies
                ? _value.hobbies
                : hobbies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            intent: null == intent
                ? _value.intent
                : intent // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
    _$ProfileImpl value,
    $Res Function(_$ProfileImpl) then,
  ) = __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int? age,
    String? gender,
    String? photoUrl,
    List<String> hobbies,
    String intent,
    String? bio,
  });
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
    _$ProfileImpl _value,
    $Res Function(_$ProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? photoUrl = freezed,
    Object? hobbies = null,
    Object? intent = null,
    Object? bio = freezed,
  }) {
    return _then(
      _$ProfileImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        hobbies: null == hobbies
            ? _value._hobbies
            : hobbies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        intent: null == intent
            ? _value.intent
            : intent // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl({
    required this.name,
    this.age,
    this.gender,
    this.photoUrl,
    final List<String> hobbies = const [],
    this.intent = 'friends',
    this.bio,
  }) : _hobbies = hobbies;

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  final String name;
  @override
  final int? age;
  @override
  final String? gender;
  @override
  final String? photoUrl;
  final List<String> _hobbies;
  @override
  @JsonKey()
  List<String> get hobbies {
    if (_hobbies is EqualUnmodifiableListView) return _hobbies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hobbies);
  }

  @override
  @JsonKey()
  final String intent;
  // 'friends', 'dating', 'both'
  @override
  final String? bio;

  @override
  String toString() {
    return 'Profile(name: $name, age: $age, gender: $gender, photoUrl: $photoUrl, hobbies: $hobbies, intent: $intent, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            const DeepCollectionEquality().equals(other._hobbies, _hobbies) &&
            (identical(other.intent, intent) || other.intent == intent) &&
            (identical(other.bio, bio) || other.bio == bio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    age,
    gender,
    photoUrl,
    const DeepCollectionEquality().hash(_hobbies),
    intent,
    bio,
  );

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(this);
  }
}

abstract class _Profile implements Profile {
  const factory _Profile({
    required final String name,
    final int? age,
    final String? gender,
    final String? photoUrl,
    final List<String> hobbies,
    final String intent,
    final String? bio,
  }) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  String get name;
  @override
  int? get age;
  @override
  String? get gender;
  @override
  String? get photoUrl;
  @override
  List<String> get hobbies;
  @override
  String get intent; // 'friends', 'dating', 'both'
  @override
  String? get bio;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
