// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  idSecondary: json['_id'] as String?,
  id: json['id'] as String?,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  rig: json['rig'] == null
      ? null
      : Rig.fromJson(json['rig'] as Map<String, dynamic>),
  travelRoute: json['travelRoute'] == null
      ? null
      : TravelRoute.fromJson(json['travelRoute'] as Map<String, dynamic>),
  isBuilder: json['isBuilder'] as bool? ?? false,
  nomadId: json['nomadId'] == null
      ? null
      : NomadId.fromJson(json['nomadId'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      if (instance.idSecondary case final value?) '_id': value,
      if (instance.id case final value?) 'id': value,
      'email': instance.email,
      'phone': instance.phone,
      'profile': instance.profile,
      'rig': instance.rig,
      'travelRoute': instance.travelRoute,
      'isBuilder': instance.isBuilder,
      'nomadId': instance.nomadId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
