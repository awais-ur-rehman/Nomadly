// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  matchedUserId: json['matchedUserId'] as String,
  swipeAction: json['swipeAction'] as String,
  isMutual: json['isMutual'] as bool? ?? false,
  matchedUser: json['matchedUser'] == null
      ? null
      : User.fromJson(json['matchedUser'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'matchedUserId': instance.matchedUserId,
      'swipeAction': instance.swipeAction,
      'isMutual': instance.isMutual,
      'matchedUser': instance.matchedUser,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$DiscoveryUserImpl _$$DiscoveryUserImplFromJson(Map<String, dynamic> json) =>
    _$DiscoveryUserImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      intersection: json['intersection'] == null
          ? null
          : GeoPoint.fromJson(json['intersection'] as Map<String, dynamic>),
      distance: (json['distance'] as num?)?.toDouble(),
      score: (json['score'] as num?)?.toInt(),
      commonHobbies:
          (json['commonHobbies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DiscoveryUserImplToJson(_$DiscoveryUserImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'intersection': instance.intersection,
      'distance': instance.distance,
      'score': instance.score,
      'commonHobbies': instance.commonHobbies,
    };
