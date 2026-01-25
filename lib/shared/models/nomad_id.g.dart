// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nomad_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NomadIdImpl _$$NomadIdImplFromJson(Map<String, dynamic> json) =>
    _$NomadIdImpl(
      verified: json['verified'] as bool? ?? false,
      memberSince: DateTime.parse(json['memberSince'] as String),
      vouchCount: (json['vouchCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NomadIdImplToJson(_$NomadIdImpl instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'memberSince': instance.memberSince.toIso8601String(),
      'vouchCount': instance.vouchCount,
    };
