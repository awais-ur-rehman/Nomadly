// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuilderProfileImpl _$$BuilderProfileImplFromJson(Map<String, dynamic> json) =>
    _$BuilderProfileImpl(
      id: json['id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      businessName: json['businessName'] as String,
      description: json['description'] as String,
      specialty:
          (json['specialty'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      portfolioImageUrls:
          (json['portfolioImageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isVerified: json['isVerified'] as bool,
      locationBase: json['locationBase'] as String?,
    );

Map<String, dynamic> _$$BuilderProfileImplToJson(
  _$BuilderProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'businessName': instance.businessName,
  'description': instance.description,
  'specialty': instance.specialty,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'portfolioImageUrls': instance.portfolioImageUrls,
  'isVerified': instance.isVerified,
  'locationBase': instance.locationBase,
};

_$BuilderReviewImpl _$$BuilderReviewImplFromJson(Map<String, dynamic> json) =>
    _$BuilderReviewImpl(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      authorPhotoUrl: json['authorPhotoUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BuilderReviewImplToJson(_$BuilderReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorName': instance.authorName,
      'authorPhotoUrl': instance.authorPhotoUrl,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
    };
