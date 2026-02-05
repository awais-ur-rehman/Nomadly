// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerificationItem _$VerificationItemFromJson(Map<String, dynamic> json) {
  return _VerificationItem.fromJson(json);
}

/// @nodoc
mixin _$VerificationItem {
  String get status =>
      throw _privateConstructorUsedError; // none, submitted, pending, verified, rejected
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  /// Serializes this VerificationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationItemCopyWith<VerificationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationItemCopyWith<$Res> {
  factory $VerificationItemCopyWith(
    VerificationItem value,
    $Res Function(VerificationItem) then,
  ) = _$VerificationItemCopyWithImpl<$Res, VerificationItem>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class _$VerificationItemCopyWithImpl<$Res, $Val extends VerificationItem>
    implements $VerificationItemCopyWith<$Res> {
  _$VerificationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? verifiedAt = freezed}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerificationItemImplCopyWith<$Res>
    implements $VerificationItemCopyWith<$Res> {
  factory _$$VerificationItemImplCopyWith(
    _$VerificationItemImpl value,
    $Res Function(_$VerificationItemImpl) then,
  ) = __$$VerificationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class __$$VerificationItemImplCopyWithImpl<$Res>
    extends _$VerificationItemCopyWithImpl<$Res, _$VerificationItemImpl>
    implements _$$VerificationItemImplCopyWith<$Res> {
  __$$VerificationItemImplCopyWithImpl(
    _$VerificationItemImpl _value,
    $Res Function(_$VerificationItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? verifiedAt = freezed}) {
    return _then(
      _$VerificationItemImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationItemImpl implements _VerificationItem {
  const _$VerificationItemImpl({
    this.status = 'none',
    @JsonKey(name: 'verified_at') this.verifiedAt,
  });

  factory _$VerificationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationItemImplFromJson(json);

  @override
  @JsonKey()
  final String status;
  // none, submitted, pending, verified, rejected
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'VerificationItem(status: $status, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationItemImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, verifiedAt);

  /// Create a copy of VerificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationItemImplCopyWith<_$VerificationItemImpl> get copyWith =>
      __$$VerificationItemImplCopyWithImpl<_$VerificationItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationItemImplToJson(this);
  }
}

abstract class _VerificationItem implements VerificationItem {
  const factory _VerificationItem({
    final String status,
    @JsonKey(name: 'verified_at') final DateTime? verifiedAt,
  }) = _$VerificationItemImpl;

  factory _VerificationItem.fromJson(Map<String, dynamic> json) =
      _$VerificationItemImpl.fromJson;

  @override
  String get status; // none, submitted, pending, verified, rejected
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;

  /// Create a copy of VerificationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationItemImplCopyWith<_$VerificationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhoneVerification _$PhoneVerificationFromJson(Map<String, dynamic> json) {
  return _PhoneVerification.fromJson(json);
}

/// @nodoc
mixin _$PhoneVerification {
  String get status => throw _privateConstructorUsedError;
  String? get number => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  /// Serializes this PhoneVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneVerificationCopyWith<PhoneVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneVerificationCopyWith<$Res> {
  factory $PhoneVerificationCopyWith(
    PhoneVerification value,
    $Res Function(PhoneVerification) then,
  ) = _$PhoneVerificationCopyWithImpl<$Res, PhoneVerification>;
  @useResult
  $Res call({
    String status,
    String? number,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class _$PhoneVerificationCopyWithImpl<$Res, $Val extends PhoneVerification>
    implements $PhoneVerificationCopyWith<$Res> {
  _$PhoneVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? number = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            number: freezed == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String?,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhoneVerificationImplCopyWith<$Res>
    implements $PhoneVerificationCopyWith<$Res> {
  factory _$$PhoneVerificationImplCopyWith(
    _$PhoneVerificationImpl value,
    $Res Function(_$PhoneVerificationImpl) then,
  ) = __$$PhoneVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    String? number,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class __$$PhoneVerificationImplCopyWithImpl<$Res>
    extends _$PhoneVerificationCopyWithImpl<$Res, _$PhoneVerificationImpl>
    implements _$$PhoneVerificationImplCopyWith<$Res> {
  __$$PhoneVerificationImplCopyWithImpl(
    _$PhoneVerificationImpl _value,
    $Res Function(_$PhoneVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? number = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _$PhoneVerificationImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        number: freezed == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String?,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneVerificationImpl implements _PhoneVerification {
  const _$PhoneVerificationImpl({
    this.status = 'none',
    this.number,
    @JsonKey(name: 'verified_at') this.verifiedAt,
  });

  factory _$PhoneVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneVerificationImplFromJson(json);

  @override
  @JsonKey()
  final String status;
  @override
  final String? number;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'PhoneVerification(status: $status, number: $number, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneVerificationImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, number, verifiedAt);

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneVerificationImplCopyWith<_$PhoneVerificationImpl> get copyWith =>
      __$$PhoneVerificationImplCopyWithImpl<_$PhoneVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneVerificationImplToJson(this);
  }
}

abstract class _PhoneVerification implements PhoneVerification {
  const factory _PhoneVerification({
    final String status,
    final String? number,
    @JsonKey(name: 'verified_at') final DateTime? verifiedAt,
  }) = _$PhoneVerificationImpl;

  factory _PhoneVerification.fromJson(Map<String, dynamic> json) =
      _$PhoneVerificationImpl.fromJson;

  @override
  String get status;
  @override
  String? get number;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneVerificationImplCopyWith<_$PhoneVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhotoVerification _$PhotoVerificationFromJson(Map<String, dynamic> json) {
  return _PhotoVerification.fromJson(json);
}

/// @nodoc
mixin _$PhotoVerification {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'selfie_url')
  String? get selfieUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Serializes this PhotoVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoVerificationCopyWith<PhotoVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoVerificationCopyWith<$Res> {
  factory $PhotoVerificationCopyWith(
    PhotoVerification value,
    $Res Function(PhotoVerification) then,
  ) = _$PhotoVerificationCopyWithImpl<$Res, PhotoVerification>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'selfie_url') String? selfieUrl,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  });
}

/// @nodoc
class _$PhotoVerificationCopyWithImpl<$Res, $Val extends PhotoVerification>
    implements $PhotoVerificationCopyWith<$Res> {
  _$PhotoVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? selfieUrl = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            selfieUrl: freezed == selfieUrl
                ? _value.selfieUrl
                : selfieUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoVerificationImplCopyWith<$Res>
    implements $PhotoVerificationCopyWith<$Res> {
  factory _$$PhotoVerificationImplCopyWith(
    _$PhotoVerificationImpl value,
    $Res Function(_$PhotoVerificationImpl) then,
  ) = __$$PhotoVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'selfie_url') String? selfieUrl,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  });
}

/// @nodoc
class __$$PhotoVerificationImplCopyWithImpl<$Res>
    extends _$PhotoVerificationCopyWithImpl<$Res, _$PhotoVerificationImpl>
    implements _$$PhotoVerificationImplCopyWith<$Res> {
  __$$PhotoVerificationImplCopyWithImpl(
    _$PhotoVerificationImpl _value,
    $Res Function(_$PhotoVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? selfieUrl = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _$PhotoVerificationImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        selfieUrl: freezed == selfieUrl
            ? _value.selfieUrl
            : selfieUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoVerificationImpl implements _PhotoVerification {
  const _$PhotoVerificationImpl({
    this.status = 'none',
    @JsonKey(name: 'selfie_url') this.selfieUrl,
    @JsonKey(name: 'submitted_at') this.submittedAt,
    @JsonKey(name: 'verified_at') this.verifiedAt,
    @JsonKey(name: 'rejection_reason') this.rejectionReason,
  });

  factory _$PhotoVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoVerificationImplFromJson(json);

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'selfie_url')
  final String? selfieUrl;
  @override
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @override
  String toString() {
    return 'PhotoVerification(status: $status, selfieUrl: $selfieUrl, submittedAt: $submittedAt, verifiedAt: $verifiedAt, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoVerificationImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selfieUrl, selfieUrl) ||
                other.selfieUrl == selfieUrl) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    selfieUrl,
    submittedAt,
    verifiedAt,
    rejectionReason,
  );

  /// Create a copy of PhotoVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoVerificationImplCopyWith<_$PhotoVerificationImpl> get copyWith =>
      __$$PhotoVerificationImplCopyWithImpl<_$PhotoVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoVerificationImplToJson(this);
  }
}

abstract class _PhotoVerification implements PhotoVerification {
  const factory _PhotoVerification({
    final String status,
    @JsonKey(name: 'selfie_url') final String? selfieUrl,
    @JsonKey(name: 'submitted_at') final DateTime? submittedAt,
    @JsonKey(name: 'verified_at') final DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') final String? rejectionReason,
  }) = _$PhotoVerificationImpl;

  factory _PhotoVerification.fromJson(Map<String, dynamic> json) =
      _$PhotoVerificationImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(name: 'selfie_url')
  String? get selfieUrl;
  @override
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;

  /// Create a copy of PhotoVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoVerificationImplCopyWith<_$PhotoVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IdDocVerification _$IdDocVerificationFromJson(Map<String, dynamic> json) {
  return _IdDocVerification.fromJson(json);
}

/// @nodoc
mixin _$IdDocVerification {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_url')
  String? get documentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  String? get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Serializes this IdDocVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IdDocVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdDocVerificationCopyWith<IdDocVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdDocVerificationCopyWith<$Res> {
  factory $IdDocVerificationCopyWith(
    IdDocVerification value,
    $Res Function(IdDocVerification) then,
  ) = _$IdDocVerificationCopyWithImpl<$Res, IdDocVerification>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  });
}

/// @nodoc
class _$IdDocVerificationCopyWithImpl<$Res, $Val extends IdDocVerification>
    implements $IdDocVerificationCopyWith<$Res> {
  _$IdDocVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IdDocVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? documentUrl = freezed,
    Object? documentType = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            documentUrl: freezed == documentUrl
                ? _value.documentUrl
                : documentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentType: freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IdDocVerificationImplCopyWith<$Res>
    implements $IdDocVerificationCopyWith<$Res> {
  factory _$$IdDocVerificationImplCopyWith(
    _$IdDocVerificationImpl value,
    $Res Function(_$IdDocVerificationImpl) then,
  ) = __$$IdDocVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  });
}

/// @nodoc
class __$$IdDocVerificationImplCopyWithImpl<$Res>
    extends _$IdDocVerificationCopyWithImpl<$Res, _$IdDocVerificationImpl>
    implements _$$IdDocVerificationImplCopyWith<$Res> {
  __$$IdDocVerificationImplCopyWithImpl(
    _$IdDocVerificationImpl _value,
    $Res Function(_$IdDocVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IdDocVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? documentUrl = freezed,
    Object? documentType = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _$IdDocVerificationImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        documentUrl: freezed == documentUrl
            ? _value.documentUrl
            : documentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentType: freezed == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IdDocVerificationImpl implements _IdDocVerification {
  const _$IdDocVerificationImpl({
    this.status = 'none',
    @JsonKey(name: 'document_url') this.documentUrl,
    @JsonKey(name: 'document_type') this.documentType,
    @JsonKey(name: 'submitted_at') this.submittedAt,
    @JsonKey(name: 'verified_at') this.verifiedAt,
    @JsonKey(name: 'rejection_reason') this.rejectionReason,
  });

  factory _$IdDocVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdDocVerificationImplFromJson(json);

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'document_url')
  final String? documentUrl;
  @override
  @JsonKey(name: 'document_type')
  final String? documentType;
  @override
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @override
  String toString() {
    return 'IdDocVerification(status: $status, documentUrl: $documentUrl, documentType: $documentType, submittedAt: $submittedAt, verifiedAt: $verifiedAt, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdDocVerificationImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    documentUrl,
    documentType,
    submittedAt,
    verifiedAt,
    rejectionReason,
  );

  /// Create a copy of IdDocVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdDocVerificationImplCopyWith<_$IdDocVerificationImpl> get copyWith =>
      __$$IdDocVerificationImplCopyWithImpl<_$IdDocVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IdDocVerificationImplToJson(this);
  }
}

abstract class _IdDocVerification implements IdDocVerification {
  const factory _IdDocVerification({
    final String status,
    @JsonKey(name: 'document_url') final String? documentUrl,
    @JsonKey(name: 'document_type') final String? documentType,
    @JsonKey(name: 'submitted_at') final DateTime? submittedAt,
    @JsonKey(name: 'verified_at') final DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') final String? rejectionReason,
  }) = _$IdDocVerificationImpl;

  factory _IdDocVerification.fromJson(Map<String, dynamic> json) =
      _$IdDocVerificationImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(name: 'document_url')
  String? get documentUrl;
  @override
  @JsonKey(name: 'document_type')
  String? get documentType;
  @override
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;

  /// Create a copy of IdDocVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdDocVerificationImplCopyWith<_$IdDocVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityVerification _$CommunityVerificationFromJson(
  Map<String, dynamic> json,
) {
  return _CommunityVerification.fromJson(json);
}

/// @nodoc
mixin _$CommunityVerification {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'vouch_count')
  int get vouchCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  /// Serializes this CommunityVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityVerificationCopyWith<CommunityVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityVerificationCopyWith<$Res> {
  factory $CommunityVerificationCopyWith(
    CommunityVerification value,
    $Res Function(CommunityVerification) then,
  ) = _$CommunityVerificationCopyWithImpl<$Res, CommunityVerification>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'vouch_count') int vouchCount,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class _$CommunityVerificationCopyWithImpl<
  $Res,
  $Val extends CommunityVerification
>
    implements $CommunityVerificationCopyWith<$Res> {
  _$CommunityVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? vouchCount = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            vouchCount: null == vouchCount
                ? _value.vouchCount
                : vouchCount // ignore: cast_nullable_to_non_nullable
                      as int,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityVerificationImplCopyWith<$Res>
    implements $CommunityVerificationCopyWith<$Res> {
  factory _$$CommunityVerificationImplCopyWith(
    _$CommunityVerificationImpl value,
    $Res Function(_$CommunityVerificationImpl) then,
  ) = __$$CommunityVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'vouch_count') int vouchCount,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  });
}

/// @nodoc
class __$$CommunityVerificationImplCopyWithImpl<$Res>
    extends
        _$CommunityVerificationCopyWithImpl<$Res, _$CommunityVerificationImpl>
    implements _$$CommunityVerificationImplCopyWith<$Res> {
  __$$CommunityVerificationImplCopyWithImpl(
    _$CommunityVerificationImpl _value,
    $Res Function(_$CommunityVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? vouchCount = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _$CommunityVerificationImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        vouchCount: null == vouchCount
            ? _value.vouchCount
            : vouchCount // ignore: cast_nullable_to_non_nullable
                  as int,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityVerificationImpl implements _CommunityVerification {
  const _$CommunityVerificationImpl({
    this.status = 'none',
    @JsonKey(name: 'vouch_count') this.vouchCount = 0,
    @JsonKey(name: 'verified_at') this.verifiedAt,
  });

  factory _$CommunityVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityVerificationImplFromJson(json);

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'vouch_count')
  final int vouchCount;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'CommunityVerification(status: $status, vouchCount: $vouchCount, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityVerificationImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.vouchCount, vouchCount) ||
                other.vouchCount == vouchCount) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, vouchCount, verifiedAt);

  /// Create a copy of CommunityVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityVerificationImplCopyWith<_$CommunityVerificationImpl>
  get copyWith =>
      __$$CommunityVerificationImplCopyWithImpl<_$CommunityVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityVerificationImplToJson(this);
  }
}

abstract class _CommunityVerification implements CommunityVerification {
  const factory _CommunityVerification({
    final String status,
    @JsonKey(name: 'vouch_count') final int vouchCount,
    @JsonKey(name: 'verified_at') final DateTime? verifiedAt,
  }) = _$CommunityVerificationImpl;

  factory _CommunityVerification.fromJson(Map<String, dynamic> json) =
      _$CommunityVerificationImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(name: 'vouch_count')
  int get vouchCount;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;

  /// Create a copy of CommunityVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityVerificationImplCopyWith<_$CommunityVerificationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

Verification _$VerificationFromJson(Map<String, dynamic> json) {
  return _Verification.fromJson(json);
}

/// @nodoc
mixin _$Verification {
  VerificationItem? get email => throw _privateConstructorUsedError;
  PhoneVerification? get phone => throw _privateConstructorUsedError;
  PhotoVerification? get photo => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_document')
  IdDocVerification? get idDocument => throw _privateConstructorUsedError;
  CommunityVerification? get community => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  String get badge => throw _privateConstructorUsedError;

  /// Serializes this Verification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationCopyWith<Verification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationCopyWith<$Res> {
  factory $VerificationCopyWith(
    Verification value,
    $Res Function(Verification) then,
  ) = _$VerificationCopyWithImpl<$Res, Verification>;
  @useResult
  $Res call({
    VerificationItem? email,
    PhoneVerification? phone,
    PhotoVerification? photo,
    @JsonKey(name: 'id_document') IdDocVerification? idDocument,
    CommunityVerification? community,
    int level,
    String badge,
  });

  $VerificationItemCopyWith<$Res>? get email;
  $PhoneVerificationCopyWith<$Res>? get phone;
  $PhotoVerificationCopyWith<$Res>? get photo;
  $IdDocVerificationCopyWith<$Res>? get idDocument;
  $CommunityVerificationCopyWith<$Res>? get community;
}

/// @nodoc
class _$VerificationCopyWithImpl<$Res, $Val extends Verification>
    implements $VerificationCopyWith<$Res> {
  _$VerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? phone = freezed,
    Object? photo = freezed,
    Object? idDocument = freezed,
    Object? community = freezed,
    Object? level = null,
    Object? badge = null,
  }) {
    return _then(
      _value.copyWith(
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as VerificationItem?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as PhoneVerification?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as PhotoVerification?,
            idDocument: freezed == idDocument
                ? _value.idDocument
                : idDocument // ignore: cast_nullable_to_non_nullable
                      as IdDocVerification?,
            community: freezed == community
                ? _value.community
                : community // ignore: cast_nullable_to_non_nullable
                      as CommunityVerification?,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            badge: null == badge
                ? _value.badge
                : badge // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerificationItemCopyWith<$Res>? get email {
    if (_value.email == null) {
      return null;
    }

    return $VerificationItemCopyWith<$Res>(_value.email!, (value) {
      return _then(_value.copyWith(email: value) as $Val);
    });
  }

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PhoneVerificationCopyWith<$Res>? get phone {
    if (_value.phone == null) {
      return null;
    }

    return $PhoneVerificationCopyWith<$Res>(_value.phone!, (value) {
      return _then(_value.copyWith(phone: value) as $Val);
    });
  }

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PhotoVerificationCopyWith<$Res>? get photo {
    if (_value.photo == null) {
      return null;
    }

    return $PhotoVerificationCopyWith<$Res>(_value.photo!, (value) {
      return _then(_value.copyWith(photo: value) as $Val);
    });
  }

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IdDocVerificationCopyWith<$Res>? get idDocument {
    if (_value.idDocument == null) {
      return null;
    }

    return $IdDocVerificationCopyWith<$Res>(_value.idDocument!, (value) {
      return _then(_value.copyWith(idDocument: value) as $Val);
    });
  }

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunityVerificationCopyWith<$Res>? get community {
    if (_value.community == null) {
      return null;
    }

    return $CommunityVerificationCopyWith<$Res>(_value.community!, (value) {
      return _then(_value.copyWith(community: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationImplCopyWith<$Res>
    implements $VerificationCopyWith<$Res> {
  factory _$$VerificationImplCopyWith(
    _$VerificationImpl value,
    $Res Function(_$VerificationImpl) then,
  ) = __$$VerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    VerificationItem? email,
    PhoneVerification? phone,
    PhotoVerification? photo,
    @JsonKey(name: 'id_document') IdDocVerification? idDocument,
    CommunityVerification? community,
    int level,
    String badge,
  });

  @override
  $VerificationItemCopyWith<$Res>? get email;
  @override
  $PhoneVerificationCopyWith<$Res>? get phone;
  @override
  $PhotoVerificationCopyWith<$Res>? get photo;
  @override
  $IdDocVerificationCopyWith<$Res>? get idDocument;
  @override
  $CommunityVerificationCopyWith<$Res>? get community;
}

/// @nodoc
class __$$VerificationImplCopyWithImpl<$Res>
    extends _$VerificationCopyWithImpl<$Res, _$VerificationImpl>
    implements _$$VerificationImplCopyWith<$Res> {
  __$$VerificationImplCopyWithImpl(
    _$VerificationImpl _value,
    $Res Function(_$VerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? phone = freezed,
    Object? photo = freezed,
    Object? idDocument = freezed,
    Object? community = freezed,
    Object? level = null,
    Object? badge = null,
  }) {
    return _then(
      _$VerificationImpl(
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as VerificationItem?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as PhoneVerification?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as PhotoVerification?,
        idDocument: freezed == idDocument
            ? _value.idDocument
            : idDocument // ignore: cast_nullable_to_non_nullable
                  as IdDocVerification?,
        community: freezed == community
            ? _value.community
            : community // ignore: cast_nullable_to_non_nullable
                  as CommunityVerification?,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        badge: null == badge
            ? _value.badge
            : badge // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationImpl extends _Verification {
  const _$VerificationImpl({
    this.email,
    this.phone,
    this.photo,
    @JsonKey(name: 'id_document') this.idDocument,
    this.community,
    this.level = 0,
    this.badge = 'none',
  }) : super._();

  factory _$VerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationImplFromJson(json);

  @override
  final VerificationItem? email;
  @override
  final PhoneVerification? phone;
  @override
  final PhotoVerification? photo;
  @override
  @JsonKey(name: 'id_document')
  final IdDocVerification? idDocument;
  @override
  final CommunityVerification? community;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final String badge;

  @override
  String toString() {
    return 'Verification(email: $email, phone: $phone, photo: $photo, idDocument: $idDocument, community: $community, level: $level, badge: $badge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.idDocument, idDocument) ||
                other.idDocument == idDocument) &&
            (identical(other.community, community) ||
                other.community == community) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.badge, badge) || other.badge == badge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    phone,
    photo,
    idDocument,
    community,
    level,
    badge,
  );

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationImplCopyWith<_$VerificationImpl> get copyWith =>
      __$$VerificationImplCopyWithImpl<_$VerificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationImplToJson(this);
  }
}

abstract class _Verification extends Verification {
  const factory _Verification({
    final VerificationItem? email,
    final PhoneVerification? phone,
    final PhotoVerification? photo,
    @JsonKey(name: 'id_document') final IdDocVerification? idDocument,
    final CommunityVerification? community,
    final int level,
    final String badge,
  }) = _$VerificationImpl;
  const _Verification._() : super._();

  factory _Verification.fromJson(Map<String, dynamic> json) =
      _$VerificationImpl.fromJson;

  @override
  VerificationItem? get email;
  @override
  PhoneVerification? get phone;
  @override
  PhotoVerification? get photo;
  @override
  @JsonKey(name: 'id_document')
  IdDocVerification? get idDocument;
  @override
  CommunityVerification? get community;
  @override
  int get level;
  @override
  String get badge;

  /// Create a copy of Verification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationImplCopyWith<_$VerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
