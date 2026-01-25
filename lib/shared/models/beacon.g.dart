// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BeaconImpl _$$BeaconImplFromJson(Map<String, dynamic> json) => _$BeaconImpl(
  id: json['id'] as String,
  author: User.fromJson(json['author'] as Map<String, dynamic>),
  message: json['message'] as String,
  location: GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  likes:
      (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$BeaconImplToJson(_$BeaconImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'message': instance.message,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'likes': instance.likes,
    };
