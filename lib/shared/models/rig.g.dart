// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RigImpl _$$RigImplFromJson(Map<String, dynamic> json) => _$RigImpl(
  type: json['type'] as String?,
  crewType: json['crew_type'] as String?,
  petFriendly: json['petFriendly'] as bool? ?? false,
);

Map<String, dynamic> _$$RigImplToJson(_$RigImpl instance) => <String, dynamic>{
  'type': instance.type,
  'crew_type': instance.crewType,
  'petFriendly': instance.petFriendly,
};
