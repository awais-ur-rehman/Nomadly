// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  idSecondary: json['_id'] as String?,
  id: json['id'] as String?,
  email: json['email'] as String?,
  username: json['username'] as String?,
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
  isBuilder: json['is_builder'] as bool? ?? false,
  isPrivate: json['is_private'] as bool? ?? false,
  nomadId: json['nomad_id'] == null
      ? null
      : NomadId.fromJson(json['nomad_id'] as Map<String, dynamic>),
  isActive: json['is_active'] as bool? ?? true,
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
  isFollowing: json['isFollowing'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      if (instance.idSecondary case final value?) '_id': value,
      if (instance.id case final value?) 'id': value,
      'email': instance.email,
      'username': instance.username,
      'phone': instance.phone,
      'profile': instance.profile,
      'rig': instance.rig,
      'travelRoute': instance.travelRoute,
      'is_builder': instance.isBuilder,
      'is_private': instance.isPrivate,
      'nomad_id': instance.nomadId,
      'is_active': instance.isActive,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'isFollowing': instance.isFollowing,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
