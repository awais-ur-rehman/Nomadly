// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };

_$RegisterResponseImpl _$$RegisterResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterResponseImpl(
  userId: json['userId'] as String,
  email: json['email'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$$RegisterResponseImplToJson(
  _$RegisterResponseImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'isActive': instance.isActive,
};
