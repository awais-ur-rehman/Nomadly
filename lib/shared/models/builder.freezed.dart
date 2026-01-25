// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'builder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BuilderProfile _$BuilderProfileFromJson(Map<String, dynamic> json) {
  return _BuilderProfile.fromJson(json);
}

/// @nodoc
mixin _$BuilderProfile {
  String get id => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get specialty =>
      throw _privateConstructorUsedError; // 'van', 'rv', 'bus', 'electrical', 'solar', etc.
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<String> get portfolioImageUrls => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get locationBase => throw _privateConstructorUsedError;

  /// Serializes this BuilderProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderProfileCopyWith<BuilderProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderProfileCopyWith<$Res> {
  factory $BuilderProfileCopyWith(
    BuilderProfile value,
    $Res Function(BuilderProfile) then,
  ) = _$BuilderProfileCopyWithImpl<$Res, BuilderProfile>;
  @useResult
  $Res call({
    String id,
    User user,
    String businessName,
    String description,
    List<String> specialty,
    double rating,
    int reviewCount,
    List<String> portfolioImageUrls,
    bool isVerified,
    String? locationBase,
  });

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$BuilderProfileCopyWithImpl<$Res, $Val extends BuilderProfile>
    implements $BuilderProfileCopyWith<$Res> {
  _$BuilderProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? businessName = null,
    Object? description = null,
    Object? specialty = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? portfolioImageUrls = null,
    Object? isVerified = null,
    Object? locationBase = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User,
            businessName: null == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            specialty: null == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            portfolioImageUrls: null == portfolioImageUrls
                ? _value.portfolioImageUrls
                : portfolioImageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            locationBase: freezed == locationBase
                ? _value.locationBase
                : locationBase // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BuilderProfile
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
abstract class _$$BuilderProfileImplCopyWith<$Res>
    implements $BuilderProfileCopyWith<$Res> {
  factory _$$BuilderProfileImplCopyWith(
    _$BuilderProfileImpl value,
    $Res Function(_$BuilderProfileImpl) then,
  ) = __$$BuilderProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    User user,
    String businessName,
    String description,
    List<String> specialty,
    double rating,
    int reviewCount,
    List<String> portfolioImageUrls,
    bool isVerified,
    String? locationBase,
  });

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$BuilderProfileImplCopyWithImpl<$Res>
    extends _$BuilderProfileCopyWithImpl<$Res, _$BuilderProfileImpl>
    implements _$$BuilderProfileImplCopyWith<$Res> {
  __$$BuilderProfileImplCopyWithImpl(
    _$BuilderProfileImpl _value,
    $Res Function(_$BuilderProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BuilderProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? businessName = null,
    Object? description = null,
    Object? specialty = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? portfolioImageUrls = null,
    Object? isVerified = null,
    Object? locationBase = freezed,
  }) {
    return _then(
      _$BuilderProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        businessName: null == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        specialty: null == specialty
            ? _value._specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        portfolioImageUrls: null == portfolioImageUrls
            ? _value._portfolioImageUrls
            : portfolioImageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        locationBase: freezed == locationBase
            ? _value.locationBase
            : locationBase // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BuilderProfileImpl implements _BuilderProfile {
  const _$BuilderProfileImpl({
    required this.id,
    required this.user,
    required this.businessName,
    required this.description,
    final List<String> specialty = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    final List<String> portfolioImageUrls = const [],
    required this.isVerified,
    this.locationBase,
  }) : _specialty = specialty,
       _portfolioImageUrls = portfolioImageUrls;

  factory _$BuilderProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderProfileImplFromJson(json);

  @override
  final String id;
  @override
  final User user;
  @override
  final String businessName;
  @override
  final String description;
  final List<String> _specialty;
  @override
  @JsonKey()
  List<String> get specialty {
    if (_specialty is EqualUnmodifiableListView) return _specialty;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialty);
  }

  // 'van', 'rv', 'bus', 'electrical', 'solar', etc.
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  final List<String> _portfolioImageUrls;
  @override
  @JsonKey()
  List<String> get portfolioImageUrls {
    if (_portfolioImageUrls is EqualUnmodifiableListView)
      return _portfolioImageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolioImageUrls);
  }

  @override
  final bool isVerified;
  @override
  final String? locationBase;

  @override
  String toString() {
    return 'BuilderProfile(id: $id, user: $user, businessName: $businessName, description: $description, specialty: $specialty, rating: $rating, reviewCount: $reviewCount, portfolioImageUrls: $portfolioImageUrls, isVerified: $isVerified, locationBase: $locationBase)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._specialty,
              _specialty,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(
              other._portfolioImageUrls,
              _portfolioImageUrls,
            ) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.locationBase, locationBase) ||
                other.locationBase == locationBase));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    user,
    businessName,
    description,
    const DeepCollectionEquality().hash(_specialty),
    rating,
    reviewCount,
    const DeepCollectionEquality().hash(_portfolioImageUrls),
    isVerified,
    locationBase,
  );

  /// Create a copy of BuilderProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderProfileImplCopyWith<_$BuilderProfileImpl> get copyWith =>
      __$$BuilderProfileImplCopyWithImpl<_$BuilderProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderProfileImplToJson(this);
  }
}

abstract class _BuilderProfile implements BuilderProfile {
  const factory _BuilderProfile({
    required final String id,
    required final User user,
    required final String businessName,
    required final String description,
    final List<String> specialty,
    final double rating,
    final int reviewCount,
    final List<String> portfolioImageUrls,
    required final bool isVerified,
    final String? locationBase,
  }) = _$BuilderProfileImpl;

  factory _BuilderProfile.fromJson(Map<String, dynamic> json) =
      _$BuilderProfileImpl.fromJson;

  @override
  String get id;
  @override
  User get user;
  @override
  String get businessName;
  @override
  String get description;
  @override
  List<String> get specialty; // 'van', 'rv', 'bus', 'electrical', 'solar', etc.
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  List<String> get portfolioImageUrls;
  @override
  bool get isVerified;
  @override
  String? get locationBase;

  /// Create a copy of BuilderProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderProfileImplCopyWith<_$BuilderProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuilderReview _$BuilderReviewFromJson(Map<String, dynamic> json) {
  return _BuilderReview.fromJson(json);
}

/// @nodoc
mixin _$BuilderReview {
  String get id => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get authorPhotoUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BuilderReview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuilderReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuilderReviewCopyWith<BuilderReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuilderReviewCopyWith<$Res> {
  factory $BuilderReviewCopyWith(
    BuilderReview value,
    $Res Function(BuilderReview) then,
  ) = _$BuilderReviewCopyWithImpl<$Res, BuilderReview>;
  @useResult
  $Res call({
    String id,
    String authorName,
    String authorPhotoUrl,
    double rating,
    String comment,
    DateTime createdAt,
  });
}

/// @nodoc
class _$BuilderReviewCopyWithImpl<$Res, $Val extends BuilderReview>
    implements $BuilderReviewCopyWith<$Res> {
  _$BuilderReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuilderReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorName = null,
    Object? authorPhotoUrl = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorPhotoUrl: null == authorPhotoUrl
                ? _value.authorPhotoUrl
                : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            comment: null == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BuilderReviewImplCopyWith<$Res>
    implements $BuilderReviewCopyWith<$Res> {
  factory _$$BuilderReviewImplCopyWith(
    _$BuilderReviewImpl value,
    $Res Function(_$BuilderReviewImpl) then,
  ) = __$$BuilderReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String authorName,
    String authorPhotoUrl,
    double rating,
    String comment,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$BuilderReviewImplCopyWithImpl<$Res>
    extends _$BuilderReviewCopyWithImpl<$Res, _$BuilderReviewImpl>
    implements _$$BuilderReviewImplCopyWith<$Res> {
  __$$BuilderReviewImplCopyWithImpl(
    _$BuilderReviewImpl _value,
    $Res Function(_$BuilderReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BuilderReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorName = null,
    Object? authorPhotoUrl = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BuilderReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorPhotoUrl: null == authorPhotoUrl
            ? _value.authorPhotoUrl
            : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: null == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
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
class _$BuilderReviewImpl implements _BuilderReview {
  const _$BuilderReviewImpl({
    required this.id,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory _$BuilderReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuilderReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String authorName;
  @override
  final String authorPhotoUrl;
  @override
  final double rating;
  @override
  final String comment;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BuilderReview(id: $id, authorName: $authorName, authorPhotoUrl: $authorPhotoUrl, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuilderReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorPhotoUrl, authorPhotoUrl) ||
                other.authorPhotoUrl == authorPhotoUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorName,
    authorPhotoUrl,
    rating,
    comment,
    createdAt,
  );

  /// Create a copy of BuilderReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuilderReviewImplCopyWith<_$BuilderReviewImpl> get copyWith =>
      __$$BuilderReviewImplCopyWithImpl<_$BuilderReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuilderReviewImplToJson(this);
  }
}

abstract class _BuilderReview implements BuilderReview {
  const factory _BuilderReview({
    required final String id,
    required final String authorName,
    required final String authorPhotoUrl,
    required final double rating,
    required final String comment,
    required final DateTime createdAt,
  }) = _$BuilderReviewImpl;

  factory _BuilderReview.fromJson(Map<String, dynamic> json) =
      _$BuilderReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get authorName;
  @override
  String get authorPhotoUrl;
  @override
  double get rating;
  @override
  String get comment;
  @override
  DateTime get createdAt;

  /// Create a copy of BuilderReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuilderReviewImplCopyWith<_$BuilderReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
