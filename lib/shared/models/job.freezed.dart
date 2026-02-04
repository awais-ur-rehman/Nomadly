// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Job _$JobFromJson(Map<String, dynamic> json) {
  return _Job.fromJson(json);
}

/// @nodoc
mixin _$Job {
  @JsonKey(name: '_id', readValue: _readId)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_id', readValue: _readAuthor)
  User get author => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get budget => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_type')
  String get budgetType => throw _privateConstructorUsedError;
  JobLocation get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_remote')
  bool get isRemote => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res, Job>;
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    @JsonKey(name: 'author_id', readValue: _readAuthor) User author,
    String title,
    String description,
    String category,
    double budget,
    @JsonKey(name: 'budget_type') String budgetType,
    JobLocation location,
    @JsonKey(name: 'is_remote') bool isRemote,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  $UserCopyWith<$Res> get author;
  $JobLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$JobCopyWithImpl<$Res, $Val extends Job> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = null,
    Object? budgetType = null,
    Object? location = null,
    Object? isRemote = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as User,
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
                      as JobLocation,
            isRemote: null == isRemote
                ? _value.isRemote
                : isRemote // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get author {
    return $UserCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobLocationCopyWith<$Res> get location {
    return $JobLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobImplCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$JobImplCopyWith(_$JobImpl value, $Res Function(_$JobImpl) then) =
      __$$JobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    @JsonKey(name: 'author_id', readValue: _readAuthor) User author,
    String title,
    String description,
    String category,
    double budget,
    @JsonKey(name: 'budget_type') String budgetType,
    JobLocation location,
    @JsonKey(name: 'is_remote') bool isRemote,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  @override
  $UserCopyWith<$Res> get author;
  @override
  $JobLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$JobImplCopyWithImpl<$Res> extends _$JobCopyWithImpl<$Res, _$JobImpl>
    implements _$$JobImplCopyWith<$Res> {
  __$$JobImplCopyWithImpl(_$JobImpl _value, $Res Function(_$JobImpl) _then)
    : super(_value, _then);

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = null,
    Object? budgetType = null,
    Object? location = null,
    Object? isRemote = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$JobImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as User,
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
                  as JobLocation,
        isRemote: null == isRemote
            ? _value.isRemote
            : isRemote // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$JobImpl implements _Job {
  const _$JobImpl({
    @JsonKey(name: '_id', readValue: _readId) required this.id,
    @JsonKey(name: 'author_id', readValue: _readAuthor) required this.author,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    @JsonKey(name: 'budget_type') required this.budgetType,
    required this.location,
    @JsonKey(name: 'is_remote') this.isRemote = false,
    this.status = 'open',
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$JobImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobImplFromJson(json);

  @override
  @JsonKey(name: '_id', readValue: _readId)
  final String id;
  @override
  @JsonKey(name: 'author_id', readValue: _readAuthor)
  final User author;
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
  final JobLocation location;
  @override
  @JsonKey(name: 'is_remote')
  final bool isRemote;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'Job(id: $id, author: $author, title: $title, description: $description, category: $category, budget: $budget, budgetType: $budgetType, location: $location, isRemote: $isRemote, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    author,
    title,
    description,
    category,
    budget,
    budgetType,
    location,
    isRemote,
    status,
    createdAt,
  );

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      __$$JobImplCopyWithImpl<_$JobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobImplToJson(this);
  }
}

abstract class _Job implements Job {
  const factory _Job({
    @JsonKey(name: '_id', readValue: _readId) required final String id,
    @JsonKey(name: 'author_id', readValue: _readAuthor)
    required final User author,
    required final String title,
    required final String description,
    required final String category,
    required final double budget,
    @JsonKey(name: 'budget_type') required final String budgetType,
    required final JobLocation location,
    @JsonKey(name: 'is_remote') final bool isRemote,
    final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$JobImpl;

  factory _Job.fromJson(Map<String, dynamic> json) = _$JobImpl.fromJson;

  @override
  @JsonKey(name: '_id', readValue: _readId)
  String get id;
  @override
  @JsonKey(name: 'author_id', readValue: _readAuthor)
  User get author;
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
  JobLocation get location;
  @override
  @JsonKey(name: 'is_remote')
  bool get isRemote;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobLocation _$JobLocationFromJson(Map<String, dynamic> json) {
  return _JobLocation.fromJson(json);
}

/// @nodoc
mixin _$JobLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;

  /// Serializes this JobLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobLocationCopyWith<JobLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobLocationCopyWith<$Res> {
  factory $JobLocationCopyWith(
    JobLocation value,
    $Res Function(JobLocation) then,
  ) = _$JobLocationCopyWithImpl<$Res, JobLocation>;
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class _$JobLocationCopyWithImpl<$Res, $Val extends JobLocation>
    implements $JobLocationCopyWith<$Res> {
  _$JobLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobLocation
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
abstract class _$$JobLocationImplCopyWith<$Res>
    implements $JobLocationCopyWith<$Res> {
  factory _$$JobLocationImplCopyWith(
    _$JobLocationImpl value,
    $Res Function(_$JobLocationImpl) then,
  ) = __$$JobLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class __$$JobLocationImplCopyWithImpl<$Res>
    extends _$JobLocationCopyWithImpl<$Res, _$JobLocationImpl>
    implements _$$JobLocationImplCopyWith<$Res> {
  __$$JobLocationImplCopyWithImpl(
    _$JobLocationImpl _value,
    $Res Function(_$JobLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? coordinates = null}) {
    return _then(
      _$JobLocationImpl(
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
class _$JobLocationImpl implements _JobLocation {
  const _$JobLocationImpl({
    required this.type,
    required final List<double> coordinates,
  }) : _coordinates = coordinates;

  factory _$JobLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobLocationImplFromJson(json);

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
    return 'JobLocation(type: $type, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobLocationImpl &&
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

  /// Create a copy of JobLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobLocationImplCopyWith<_$JobLocationImpl> get copyWith =>
      __$$JobLocationImplCopyWithImpl<_$JobLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobLocationImplToJson(this);
  }
}

abstract class _JobLocation implements JobLocation {
  const factory _JobLocation({
    required final String type,
    required final List<double> coordinates,
  }) = _$JobLocationImpl;

  factory _JobLocation.fromJson(Map<String, dynamic> json) =
      _$JobLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;

  /// Create a copy of JobLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobLocationImplCopyWith<_$JobLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
