// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedUserImpl _$$RecommendedUserImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendedUserImpl(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  compatibility: json['compatibility'] == null
      ? null
      : CompatibilityScore.fromJson(
          json['compatibility'] as Map<String, dynamic>,
        ),
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$RecommendedUserImplToJson(
  _$RecommendedUserImpl instance,
) => <String, dynamic>{
  'user': instance.user,
  'compatibility': instance.compatibility,
  'distance_km': instance.distanceKm,
};
