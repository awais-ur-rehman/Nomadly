// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripInterest _$TripInterestFromJson(Map<String, dynamic> json) {
  return _TripInterest.fromJson(json);
}

/// @nodoc
mixin _$TripInterest {
  @JsonKey(name: 'user_id')
  User get user => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TripInterest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripInterestCopyWith<TripInterest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripInterestCopyWith<$Res> {
  factory $TripInterestCopyWith(
    TripInterest value,
    $Res Function(TripInterest) then,
  ) = _$TripInterestCopyWithImpl<$Res, TripInterest>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') User user,
    String message,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$TripInterestCopyWithImpl<$Res, $Val extends TripInterest>
    implements $TripInterestCopyWith<$Res> {
  _$TripInterestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? message = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripInterestImplCopyWith<$Res>
    implements $TripInterestCopyWith<$Res> {
  factory _$$TripInterestImplCopyWith(
    _$TripInterestImpl value,
    $Res Function(_$TripInterestImpl) then,
  ) = __$$TripInterestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') User user,
    String message,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$TripInterestImplCopyWithImpl<$Res>
    extends _$TripInterestCopyWithImpl<$Res, _$TripInterestImpl>
    implements _$$TripInterestImplCopyWith<$Res> {
  __$$TripInterestImplCopyWithImpl(
    _$TripInterestImpl _value,
    $Res Function(_$TripInterestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? message = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TripInterestImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TripInterestImpl implements _TripInterest {
  const _$TripInterestImpl({
    @JsonKey(name: 'user_id') required this.user,
    this.message = '',
    this.status = 'pending',
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$TripInterestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripInterestImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final User user;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TripInterest(user: $user, message: $message, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripInterestImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, user, message, status, createdAt);

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripInterestImplCopyWith<_$TripInterestImpl> get copyWith =>
      __$$TripInterestImplCopyWithImpl<_$TripInterestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripInterestImplToJson(this);
  }
}

abstract class _TripInterest implements TripInterest {
  const factory _TripInterest({
    @JsonKey(name: 'user_id') required final User user,
    final String message,
    final String status,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$TripInterestImpl;

  factory _TripInterest.fromJson(Map<String, dynamic> json) =
      _$TripInterestImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  User get user;
  @override
  String get message;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of TripInterest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripInterestImplCopyWith<_$TripInterestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripLocation _$TripLocationFromJson(Map<String, dynamic> json) {
  return _TripLocation.fromJson(json);
}

/// @nodoc
mixin _$TripLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;
  @JsonKey(name: 'place_name')
  String? get placeName => throw _privateConstructorUsedError;

  /// Serializes this TripLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripLocationCopyWith<TripLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripLocationCopyWith<$Res> {
  factory $TripLocationCopyWith(
    TripLocation value,
    $Res Function(TripLocation) then,
  ) = _$TripLocationCopyWithImpl<$Res, TripLocation>;
  @useResult
  $Res call({
    String type,
    List<double> coordinates,
    @JsonKey(name: 'place_name') String? placeName,
  });
}

/// @nodoc
class _$TripLocationCopyWithImpl<$Res, $Val extends TripLocation>
    implements $TripLocationCopyWith<$Res> {
  _$TripLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? placeName = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            coordinates: null == coordinates
                ? _value.coordinates
                : coordinates // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            placeName: freezed == placeName
                ? _value.placeName
                : placeName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripLocationImplCopyWith<$Res>
    implements $TripLocationCopyWith<$Res> {
  factory _$$TripLocationImplCopyWith(
    _$TripLocationImpl value,
    $Res Function(_$TripLocationImpl) then,
  ) = __$$TripLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    List<double> coordinates,
    @JsonKey(name: 'place_name') String? placeName,
  });
}

/// @nodoc
class __$$TripLocationImplCopyWithImpl<$Res>
    extends _$TripLocationCopyWithImpl<$Res, _$TripLocationImpl>
    implements _$$TripLocationImplCopyWith<$Res> {
  __$$TripLocationImplCopyWithImpl(
    _$TripLocationImpl _value,
    $Res Function(_$TripLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? placeName = freezed,
  }) {
    return _then(
      _$TripLocationImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        coordinates: null == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        placeName: freezed == placeName
            ? _value.placeName
            : placeName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripLocationImpl extends _TripLocation {
  const _$TripLocationImpl({
    required this.type,
    required final List<double> coordinates,
    @JsonKey(name: 'place_name') this.placeName,
  }) : _coordinates = coordinates,
       super._();

  factory _$TripLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripLocationImplFromJson(json);

  @override
  final String type;
  final List<double> _coordinates;
  @override
  List<double> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  @JsonKey(name: 'place_name')
  final String? placeName;

  @override
  String toString() {
    return 'TripLocation(type: $type, coordinates: $coordinates, placeName: $placeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripLocationImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._coordinates,
              _coordinates,
            ) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_coordinates),
    placeName,
  );

  /// Create a copy of TripLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripLocationImplCopyWith<_$TripLocationImpl> get copyWith =>
      __$$TripLocationImplCopyWithImpl<_$TripLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripLocationImplToJson(this);
  }
}

abstract class _TripLocation extends TripLocation {
  const factory _TripLocation({
    required final String type,
    required final List<double> coordinates,
    @JsonKey(name: 'place_name') final String? placeName,
  }) = _$TripLocationImpl;
  const _TripLocation._() : super._();

  factory _TripLocation.fromJson(Map<String, dynamic> json) =
      _$TripLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;
  @override
  @JsonKey(name: 'place_name')
  String? get placeName;

  /// Create a copy of TripLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripLocationImplCopyWith<_$TripLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  User get creator => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TripLocation get origin => throw _privateConstructorUsedError;
  TripLocation get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int get durationDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'looking_for_companions')
  bool get lookingForCompanions => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_companions')
  int get maxCompanions => throw _privateConstructorUsedError;
  @JsonKey(name: 'interested_users')
  List<TripInterest> get interestedUsers => throw _privateConstructorUsedError;
  List<User> get companions => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get visibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Computed fields from backend
  bool get isCreator => throw _privateConstructorUsedError;
  bool get isCompanion => throw _privateConstructorUsedError;
  String? get myInterestStatus => throw _privateConstructorUsedError;
  int get pendingCount => throw _privateConstructorUsedError;
  int? get spotsLeft => throw _privateConstructorUsedError;
  int? get companionCount => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'creator_id') User creator,
    String title,
    String description,
    TripLocation origin,
    TripLocation destination,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'duration_days') int durationDays,
    @JsonKey(name: 'looking_for_companions') bool lookingForCompanions,
    @JsonKey(name: 'max_companions') int maxCompanions,
    @JsonKey(name: 'interested_users') List<TripInterest> interestedUsers,
    List<User> companions,
    String status,
    String visibility,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    bool isCreator,
    bool isCompanion,
    String? myInterestStatus,
    int pendingCount,
    int? spotsLeft,
    int? companionCount,
  });

  $UserCopyWith<$Res> get creator;
  $TripLocationCopyWith<$Res> get origin;
  $TripLocationCopyWith<$Res> get destination;
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creator = null,
    Object? title = null,
    Object? description = null,
    Object? origin = null,
    Object? destination = null,
    Object? startDate = null,
    Object? durationDays = null,
    Object? lookingForCompanions = null,
    Object? maxCompanions = null,
    Object? interestedUsers = null,
    Object? companions = null,
    Object? status = null,
    Object? visibility = null,
    Object? createdAt = freezed,
    Object? isCreator = null,
    Object? isCompanion = null,
    Object? myInterestStatus = freezed,
    Object? pendingCount = null,
    Object? spotsLeft = freezed,
    Object? companionCount = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            creator: null == creator
                ? _value.creator
                : creator // ignore: cast_nullable_to_non_nullable
                      as User,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            origin: null == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as TripLocation,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as TripLocation,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationDays: null == durationDays
                ? _value.durationDays
                : durationDays // ignore: cast_nullable_to_non_nullable
                      as int,
            lookingForCompanions: null == lookingForCompanions
                ? _value.lookingForCompanions
                : lookingForCompanions // ignore: cast_nullable_to_non_nullable
                      as bool,
            maxCompanions: null == maxCompanions
                ? _value.maxCompanions
                : maxCompanions // ignore: cast_nullable_to_non_nullable
                      as int,
            interestedUsers: null == interestedUsers
                ? _value.interestedUsers
                : interestedUsers // ignore: cast_nullable_to_non_nullable
                      as List<TripInterest>,
            companions: null == companions
                ? _value.companions
                : companions // ignore: cast_nullable_to_non_nullable
                      as List<User>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isCreator: null == isCreator
                ? _value.isCreator
                : isCreator // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompanion: null == isCompanion
                ? _value.isCompanion
                : isCompanion // ignore: cast_nullable_to_non_nullable
                      as bool,
            myInterestStatus: freezed == myInterestStatus
                ? _value.myInterestStatus
                : myInterestStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            pendingCount: null == pendingCount
                ? _value.pendingCount
                : pendingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            spotsLeft: freezed == spotsLeft
                ? _value.spotsLeft
                : spotsLeft // ignore: cast_nullable_to_non_nullable
                      as int?,
            companionCount: freezed == companionCount
                ? _value.companionCount
                : companionCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get creator {
    return $UserCopyWith<$Res>(_value.creator, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripLocationCopyWith<$Res> get origin {
    return $TripLocationCopyWith<$Res>(_value.origin, (value) {
      return _then(_value.copyWith(origin: value) as $Val);
    });
  }

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripLocationCopyWith<$Res> get destination {
    return $TripLocationCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'creator_id') User creator,
    String title,
    String description,
    TripLocation origin,
    TripLocation destination,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'duration_days') int durationDays,
    @JsonKey(name: 'looking_for_companions') bool lookingForCompanions,
    @JsonKey(name: 'max_companions') int maxCompanions,
    @JsonKey(name: 'interested_users') List<TripInterest> interestedUsers,
    List<User> companions,
    String status,
    String visibility,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    bool isCreator,
    bool isCompanion,
    String? myInterestStatus,
    int pendingCount,
    int? spotsLeft,
    int? companionCount,
  });

  @override
  $UserCopyWith<$Res> get creator;
  @override
  $TripLocationCopyWith<$Res> get origin;
  @override
  $TripLocationCopyWith<$Res> get destination;
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creator = null,
    Object? title = null,
    Object? description = null,
    Object? origin = null,
    Object? destination = null,
    Object? startDate = null,
    Object? durationDays = null,
    Object? lookingForCompanions = null,
    Object? maxCompanions = null,
    Object? interestedUsers = null,
    Object? companions = null,
    Object? status = null,
    Object? visibility = null,
    Object? createdAt = freezed,
    Object? isCreator = null,
    Object? isCompanion = null,
    Object? myInterestStatus = freezed,
    Object? pendingCount = null,
    Object? spotsLeft = freezed,
    Object? companionCount = freezed,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        creator: null == creator
            ? _value.creator
            : creator // ignore: cast_nullable_to_non_nullable
                  as User,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        origin: null == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as TripLocation,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as TripLocation,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationDays: null == durationDays
            ? _value.durationDays
            : durationDays // ignore: cast_nullable_to_non_nullable
                  as int,
        lookingForCompanions: null == lookingForCompanions
            ? _value.lookingForCompanions
            : lookingForCompanions // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxCompanions: null == maxCompanions
            ? _value.maxCompanions
            : maxCompanions // ignore: cast_nullable_to_non_nullable
                  as int,
        interestedUsers: null == interestedUsers
            ? _value._interestedUsers
            : interestedUsers // ignore: cast_nullable_to_non_nullable
                  as List<TripInterest>,
        companions: null == companions
            ? _value._companions
            : companions // ignore: cast_nullable_to_non_nullable
                  as List<User>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isCreator: null == isCreator
            ? _value.isCreator
            : isCreator // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompanion: null == isCompanion
            ? _value.isCompanion
            : isCompanion // ignore: cast_nullable_to_non_nullable
                  as bool,
        myInterestStatus: freezed == myInterestStatus
            ? _value.myInterestStatus
            : myInterestStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        pendingCount: null == pendingCount
            ? _value.pendingCount
            : pendingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        spotsLeft: freezed == spotsLeft
            ? _value.spotsLeft
            : spotsLeft // ignore: cast_nullable_to_non_nullable
                  as int?,
        companionCount: freezed == companionCount
            ? _value.companionCount
            : companionCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl extends _Trip {
  const _$TripImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'creator_id') required this.creator,
    required this.title,
    this.description = '',
    required this.origin,
    required this.destination,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'duration_days') required this.durationDays,
    @JsonKey(name: 'looking_for_companions') this.lookingForCompanions = true,
    @JsonKey(name: 'max_companions') this.maxCompanions = 4,
    @JsonKey(name: 'interested_users')
    final List<TripInterest> interestedUsers = const [],
    final List<User> companions = const [],
    this.status = 'planning',
    this.visibility = 'public',
    @JsonKey(name: 'created_at') this.createdAt,
    this.isCreator = false,
    this.isCompanion = false,
    this.myInterestStatus,
    this.pendingCount = 0,
    this.spotsLeft,
    this.companionCount,
  }) : _interestedUsers = interestedUsers,
       _companions = companions,
       super._();

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'creator_id')
  final User creator;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final TripLocation origin;
  @override
  final TripLocation destination;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @override
  @JsonKey(name: 'looking_for_companions')
  final bool lookingForCompanions;
  @override
  @JsonKey(name: 'max_companions')
  final int maxCompanions;
  final List<TripInterest> _interestedUsers;
  @override
  @JsonKey(name: 'interested_users')
  List<TripInterest> get interestedUsers {
    if (_interestedUsers is EqualUnmodifiableListView) return _interestedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestedUsers);
  }

  final List<User> _companions;
  @override
  @JsonKey()
  List<User> get companions {
    if (_companions is EqualUnmodifiableListView) return _companions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companions);
  }

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String visibility;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Computed fields from backend
  @override
  @JsonKey()
  final bool isCreator;
  @override
  @JsonKey()
  final bool isCompanion;
  @override
  final String? myInterestStatus;
  @override
  @JsonKey()
  final int pendingCount;
  @override
  final int? spotsLeft;
  @override
  final int? companionCount;

  @override
  String toString() {
    return 'Trip(id: $id, creator: $creator, title: $title, description: $description, origin: $origin, destination: $destination, startDate: $startDate, durationDays: $durationDays, lookingForCompanions: $lookingForCompanions, maxCompanions: $maxCompanions, interestedUsers: $interestedUsers, companions: $companions, status: $status, visibility: $visibility, createdAt: $createdAt, isCreator: $isCreator, isCompanion: $isCompanion, myInterestStatus: $myInterestStatus, pendingCount: $pendingCount, spotsLeft: $spotsLeft, companionCount: $companionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.lookingForCompanions, lookingForCompanions) ||
                other.lookingForCompanions == lookingForCompanions) &&
            (identical(other.maxCompanions, maxCompanions) ||
                other.maxCompanions == maxCompanions) &&
            const DeepCollectionEquality().equals(
              other._interestedUsers,
              _interestedUsers,
            ) &&
            const DeepCollectionEquality().equals(
              other._companions,
              _companions,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isCreator, isCreator) ||
                other.isCreator == isCreator) &&
            (identical(other.isCompanion, isCompanion) ||
                other.isCompanion == isCompanion) &&
            (identical(other.myInterestStatus, myInterestStatus) ||
                other.myInterestStatus == myInterestStatus) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.spotsLeft, spotsLeft) ||
                other.spotsLeft == spotsLeft) &&
            (identical(other.companionCount, companionCount) ||
                other.companionCount == companionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    creator,
    title,
    description,
    origin,
    destination,
    startDate,
    durationDays,
    lookingForCompanions,
    maxCompanions,
    const DeepCollectionEquality().hash(_interestedUsers),
    const DeepCollectionEquality().hash(_companions),
    status,
    visibility,
    createdAt,
    isCreator,
    isCompanion,
    myInterestStatus,
    pendingCount,
    spotsLeft,
    companionCount,
  ]);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(this);
  }
}

abstract class _Trip extends Trip {
  const factory _Trip({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'creator_id') required final User creator,
    required final String title,
    final String description,
    required final TripLocation origin,
    required final TripLocation destination,
    @JsonKey(name: 'start_date') required final DateTime startDate,
    @JsonKey(name: 'duration_days') required final int durationDays,
    @JsonKey(name: 'looking_for_companions') final bool lookingForCompanions,
    @JsonKey(name: 'max_companions') final int maxCompanions,
    @JsonKey(name: 'interested_users') final List<TripInterest> interestedUsers,
    final List<User> companions,
    final String status,
    final String visibility,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    final bool isCreator,
    final bool isCompanion,
    final String? myInterestStatus,
    final int pendingCount,
    final int? spotsLeft,
    final int? companionCount,
  }) = _$TripImpl;
  const _Trip._() : super._();

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'creator_id')
  User get creator;
  @override
  String get title;
  @override
  String get description;
  @override
  TripLocation get origin;
  @override
  TripLocation get destination;
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'duration_days')
  int get durationDays;
  @override
  @JsonKey(name: 'looking_for_companions')
  bool get lookingForCompanions;
  @override
  @JsonKey(name: 'max_companions')
  int get maxCompanions;
  @override
  @JsonKey(name: 'interested_users')
  List<TripInterest> get interestedUsers;
  @override
  List<User> get companions;
  @override
  String get status;
  @override
  String get visibility;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Computed fields from backend
  @override
  bool get isCreator;
  @override
  bool get isCompanion;
  @override
  String? get myInterestStatus;
  @override
  int get pendingCount;
  @override
  int? get spotsLeft;
  @override
  int? get companionCount;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
