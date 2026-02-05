// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compatibility_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompatibilityScoreImpl _$$CompatibilityScoreImplFromJson(
  Map<String, dynamic> json,
) => _$CompatibilityScoreImpl(
  routeOverlap: (json['route_overlap'] as num?)?.toInt() ?? 0,
  temporalOverlap: (json['temporal_overlap'] as num?)?.toInt() ?? 0,
  hobbyMatch: (json['hobby_match'] as num?)?.toInt() ?? 0,
  proximity: (json['proximity'] as num?)?.toInt() ?? 0,
  trust: (json['trust'] as num?)?.toInt() ?? 0,
  rigCompatibility: (json['rig_compatibility'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$CompatibilityScoreImplToJson(
  _$CompatibilityScoreImpl instance,
) => <String, dynamic>{
  'route_overlap': instance.routeOverlap,
  'temporal_overlap': instance.temporalOverlap,
  'hobby_match': instance.hobbyMatch,
  'proximity': instance.proximity,
  'trust': instance.trust,
  'rig_compatibility': instance.rigCompatibility,
  'total': instance.total,
};
