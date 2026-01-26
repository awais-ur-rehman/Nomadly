// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nomad_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NomadIdImpl _$$NomadIdImplFromJson(Map<String, dynamic> json) =>
    _$NomadIdImpl(
      verified: json['verified'] as bool? ?? false,
      memberSince: json['member_since'] == null
          ? null
          : DateTime.parse(json['member_since'] as String),
      vouchCount: (json['vouch_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NomadIdImplToJson(_$NomadIdImpl instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'member_since': instance.memberSince?.toIso8601String(),
      'vouch_count': instance.vouchCount,
    };
