// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyJob _$MyJobFromJson(Map<String, dynamic> json) {
  return _MyJob.fromJson(json);
}

/// @nodoc
mixin _$MyJob {
  @JsonKey(name: '_id', readValue: _readId)
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get budget => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_type')
  String get budgetType => throw _privateConstructorUsedError;
  MyJobLocation get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_remote')
  bool get isRemote => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_count')
  int get applicationCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MyJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyJobCopyWith<MyJob> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyJobCopyWith<$Res> {
  factory $MyJobCopyWith(MyJob value, $Res Function(MyJob) then) =
      _$MyJobCopyWithImpl<$Res, MyJob>;
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    String title,
    String description,
    String category,
    double budget,
    @JsonKey(name: 'budget_type') String budgetType,
    MyJobLocation location,
    @JsonKey(name: 'is_remote') bool isRemote,
    String status,
    @JsonKey(name: 'application_count') int applicationCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  $MyJobLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$MyJobCopyWithImpl<$Res, $Val extends MyJob>
    implements $MyJobCopyWith<$Res> {
  _$MyJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = null,
    Object? budgetType = null,
    Object? location = null,
    Object? isRemote = null,
    Object? status = null,
    Object? applicationCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            budget: null == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                      as double,
            budgetType: null == budgetType
                ? _value.budgetType
                : budgetType // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as MyJobLocation,
            isRemote: null == isRemote
                ? _value.isRemote
                : isRemote // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            applicationCount: null == applicationCount
                ? _value.applicationCount
                : applicationCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyJobLocationCopyWith<$Res> get location {
    return $MyJobLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MyJobImplCopyWith<$Res> implements $MyJobCopyWith<$Res> {
  factory _$$MyJobImplCopyWith(
    _$MyJobImpl value,
    $Res Function(_$MyJobImpl) then,
  ) = __$$MyJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    String title,
    String description,
    String category,
    double budget,
    @JsonKey(name: 'budget_type') String budgetType,
    MyJobLocation location,
    @JsonKey(name: 'is_remote') bool isRemote,
    String status,
    @JsonKey(name: 'application_count') int applicationCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  @override
  $MyJobLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$MyJobImplCopyWithImpl<$Res>
    extends _$MyJobCopyWithImpl<$Res, _$MyJobImpl>
    implements _$$MyJobImplCopyWith<$Res> {
  __$$MyJobImplCopyWithImpl(
    _$MyJobImpl _value,
    $Res Function(_$MyJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = null,
    Object? budgetType = null,
    Object? location = null,
    Object? isRemote = null,
    Object? status = null,
    Object? applicationCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MyJobImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        budget: null == budget
            ? _value.budget
            : budget // ignore: cast_nullable_to_non_nullable
                  as double,
        budgetType: null == budgetType
            ? _value.budgetType
            : budgetType // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as MyJobLocation,
        isRemote: null == isRemote
            ? _value.isRemote
            : isRemote // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        applicationCount: null == applicationCount
            ? _value.applicationCount
            : applicationCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyJobImpl implements _MyJob {
  const _$MyJobImpl({
    @JsonKey(name: '_id', readValue: _readId) required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    @JsonKey(name: 'budget_type') required this.budgetType,
    required this.location,
    @JsonKey(name: 'is_remote') this.isRemote = false,
    this.status = 'open',
    @JsonKey(name: 'application_count') this.applicationCount = 0,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$MyJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyJobImplFromJson(json);

  @override
  @JsonKey(name: '_id', readValue: _readId)
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final double budget;
  @override
  @JsonKey(name: 'budget_type')
  final String budgetType;
  @override
  final MyJobLocation location;
  @override
  @JsonKey(name: 'is_remote')
  final bool isRemote;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'application_count')
  final int applicationCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'MyJob(id: $id, title: $title, description: $description, category: $category, budget: $budget, budgetType: $budgetType, location: $location, isRemote: $isRemote, status: $status, applicationCount: $applicationCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.budgetType, budgetType) ||
                other.budgetType == budgetType) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isRemote, isRemote) ||
                other.isRemote == isRemote) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applicationCount, applicationCount) ||
                other.applicationCount == applicationCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    budget,
    budgetType,
    location,
    isRemote,
    status,
    applicationCount,
    createdAt,
  );

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyJobImplCopyWith<_$MyJobImpl> get copyWith =>
      __$$MyJobImplCopyWithImpl<_$MyJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyJobImplToJson(this);
  }
}

abstract class _MyJob implements MyJob {
  const factory _MyJob({
    @JsonKey(name: '_id', readValue: _readId) required final String id,
    required final String title,
    required final String description,
    required final String category,
    required final double budget,
    @JsonKey(name: 'budget_type') required final String budgetType,
    required final MyJobLocation location,
    @JsonKey(name: 'is_remote') final bool isRemote,
    final String status,
    @JsonKey(name: 'application_count') final int applicationCount,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$MyJobImpl;

  factory _MyJob.fromJson(Map<String, dynamic> json) = _$MyJobImpl.fromJson;

  @override
  @JsonKey(name: '_id', readValue: _readId)
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  double get budget;
  @override
  @JsonKey(name: 'budget_type')
  String get budgetType;
  @override
  MyJobLocation get location;
  @override
  @JsonKey(name: 'is_remote')
  bool get isRemote;
  @override
  String get status;
  @override
  @JsonKey(name: 'application_count')
  int get applicationCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of MyJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyJobImplCopyWith<_$MyJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MyJobLocation _$MyJobLocationFromJson(Map<String, dynamic> json) {
  return _MyJobLocation.fromJson(json);
}

/// @nodoc
mixin _$MyJobLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;

  /// Serializes this MyJobLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyJobLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyJobLocationCopyWith<MyJobLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyJobLocationCopyWith<$Res> {
  factory $MyJobLocationCopyWith(
    MyJobLocation value,
    $Res Function(MyJobLocation) then,
  ) = _$MyJobLocationCopyWithImpl<$Res, MyJobLocation>;
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class _$MyJobLocationCopyWithImpl<$Res, $Val extends MyJobLocation>
    implements $MyJobLocationCopyWith<$Res> {
  _$MyJobLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyJobLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? coordinates = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyJobLocationImplCopyWith<$Res>
    implements $MyJobLocationCopyWith<$Res> {
  factory _$$MyJobLocationImplCopyWith(
    _$MyJobLocationImpl value,
    $Res Function(_$MyJobLocationImpl) then,
  ) = __$$MyJobLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class __$$MyJobLocationImplCopyWithImpl<$Res>
    extends _$MyJobLocationCopyWithImpl<$Res, _$MyJobLocationImpl>
    implements _$$MyJobLocationImplCopyWith<$Res> {
  __$$MyJobLocationImplCopyWithImpl(
    _$MyJobLocationImpl _value,
    $Res Function(_$MyJobLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyJobLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? coordinates = null}) {
    return _then(
      _$MyJobLocationImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        coordinates: null == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyJobLocationImpl implements _MyJobLocation {
  const _$MyJobLocationImpl({
    required this.type,
    required final List<double> coordinates,
  }) : _coordinates = coordinates;

  factory _$MyJobLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyJobLocationImplFromJson(json);

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
  String toString() {
    return 'MyJobLocation(type: $type, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyJobLocationImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._coordinates,
              _coordinates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_coordinates),
  );

  /// Create a copy of MyJobLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyJobLocationImplCopyWith<_$MyJobLocationImpl> get copyWith =>
      __$$MyJobLocationImplCopyWithImpl<_$MyJobLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyJobLocationImplToJson(this);
  }
}

abstract class _MyJobLocation implements MyJobLocation {
  const factory _MyJobLocation({
    required final String type,
    required final List<double> coordinates,
  }) = _$MyJobLocationImpl;

  factory _MyJobLocation.fromJson(Map<String, dynamic> json) =
      _$MyJobLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;

  /// Create a copy of MyJobLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyJobLocationImplCopyWith<_$MyJobLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
