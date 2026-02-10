// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobApplication _$JobApplicationFromJson(Map<String, dynamic> json) {
  return _JobApplication.fromJson(json);
}

/// @nodoc
mixin _$JobApplication {
  @JsonKey(name: '_id', readValue: _readId)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_id', readValue: _readJob)
  Job? get job => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_id', readValue: _readApplicant)
  User? get applicant => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_letter')
  String get coverLetter => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JobApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobApplicationCopyWith<JobApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobApplicationCopyWith<$Res> {
  factory $JobApplicationCopyWith(
    JobApplication value,
    $Res Function(JobApplication) then,
  ) = _$JobApplicationCopyWithImpl<$Res, JobApplication>;
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    @JsonKey(name: 'job_id', readValue: _readJob) Job? job,
    @JsonKey(name: 'applicant_id', readValue: _readApplicant) User? applicant,
    @JsonKey(name: 'cover_letter') String coverLetter,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  $JobCopyWith<$Res>? get job;
  $UserCopyWith<$Res>? get applicant;
}

/// @nodoc
class _$JobApplicationCopyWithImpl<$Res, $Val extends JobApplication>
    implements $JobApplicationCopyWith<$Res> {
  _$JobApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? job = freezed,
    Object? applicant = freezed,
    Object? coverLetter = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            job: freezed == job
                ? _value.job
                : job // ignore: cast_nullable_to_non_nullable
                      as Job?,
            applicant: freezed == applicant
                ? _value.applicant
                : applicant // ignore: cast_nullable_to_non_nullable
                      as User?,
            coverLetter: null == coverLetter
                ? _value.coverLetter
                : coverLetter // ignore: cast_nullable_to_non_nullable
                      as String,
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

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobCopyWith<$Res>? get job {
    if (_value.job == null) {
      return null;
    }

    return $JobCopyWith<$Res>(_value.job!, (value) {
      return _then(_value.copyWith(job: value) as $Val);
    });
  }

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get applicant {
    if (_value.applicant == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.applicant!, (value) {
      return _then(_value.copyWith(applicant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobApplicationImplCopyWith<$Res>
    implements $JobApplicationCopyWith<$Res> {
  factory _$$JobApplicationImplCopyWith(
    _$JobApplicationImpl value,
    $Res Function(_$JobApplicationImpl) then,
  ) = __$$JobApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id', readValue: _readId) String id,
    @JsonKey(name: 'job_id', readValue: _readJob) Job? job,
    @JsonKey(name: 'applicant_id', readValue: _readApplicant) User? applicant,
    @JsonKey(name: 'cover_letter') String coverLetter,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  @override
  $JobCopyWith<$Res>? get job;
  @override
  $UserCopyWith<$Res>? get applicant;
}

/// @nodoc
class __$$JobApplicationImplCopyWithImpl<$Res>
    extends _$JobApplicationCopyWithImpl<$Res, _$JobApplicationImpl>
    implements _$$JobApplicationImplCopyWith<$Res> {
  __$$JobApplicationImplCopyWithImpl(
    _$JobApplicationImpl _value,
    $Res Function(_$JobApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? job = freezed,
    Object? applicant = freezed,
    Object? coverLetter = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$JobApplicationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        job: freezed == job
            ? _value.job
            : job // ignore: cast_nullable_to_non_nullable
                  as Job?,
        applicant: freezed == applicant
            ? _value.applicant
            : applicant // ignore: cast_nullable_to_non_nullable
                  as User?,
        coverLetter: null == coverLetter
            ? _value.coverLetter
            : coverLetter // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$JobApplicationImpl implements _JobApplication {
  const _$JobApplicationImpl({
    @JsonKey(name: '_id', readValue: _readId) required this.id,
    @JsonKey(name: 'job_id', readValue: _readJob) this.job,
    @JsonKey(name: 'applicant_id', readValue: _readApplicant) this.applicant,
    @JsonKey(name: 'cover_letter') required this.coverLetter,
    this.status = 'pending',
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$JobApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobApplicationImplFromJson(json);

  @override
  @JsonKey(name: '_id', readValue: _readId)
  final String id;
  @override
  @JsonKey(name: 'job_id', readValue: _readJob)
  final Job? job;
  @override
  @JsonKey(name: 'applicant_id', readValue: _readApplicant)
  final User? applicant;
  @override
  @JsonKey(name: 'cover_letter')
  final String coverLetter;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'JobApplication(id: $id, job: $job, applicant: $applicant, coverLetter: $coverLetter, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.job, job) || other.job == job) &&
            (identical(other.applicant, applicant) ||
                other.applicant == applicant) &&
            (identical(other.coverLetter, coverLetter) ||
                other.coverLetter == coverLetter) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    job,
    applicant,
    coverLetter,
    status,
    createdAt,
  );

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobApplicationImplCopyWith<_$JobApplicationImpl> get copyWith =>
      __$$JobApplicationImplCopyWithImpl<_$JobApplicationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobApplicationImplToJson(this);
  }
}

abstract class _JobApplication implements JobApplication {
  const factory _JobApplication({
    @JsonKey(name: '_id', readValue: _readId) required final String id,
    @JsonKey(name: 'job_id', readValue: _readJob) final Job? job,
    @JsonKey(name: 'applicant_id', readValue: _readApplicant)
    final User? applicant,
    @JsonKey(name: 'cover_letter') required final String coverLetter,
    final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$JobApplicationImpl;

  factory _JobApplication.fromJson(Map<String, dynamic> json) =
      _$JobApplicationImpl.fromJson;

  @override
  @JsonKey(name: '_id', readValue: _readId)
  String get id;
  @override
  @JsonKey(name: 'job_id', readValue: _readJob)
  Job? get job;
  @override
  @JsonKey(name: 'applicant_id', readValue: _readApplicant)
  User? get applicant;
  @override
  @JsonKey(name: 'cover_letter')
  String get coverLetter;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobApplicationImplCopyWith<_$JobApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
