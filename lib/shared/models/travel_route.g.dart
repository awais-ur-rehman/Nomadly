// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TravelRouteImpl _$$TravelRouteImplFromJson(Map<String, dynamic> json) =>
    _$TravelRouteImpl(
      origin: json['origin'] == null
          ? null
          : GeoPoint.fromJson(json['origin'] as Map<String, dynamic>),
      destination: json['destination'] == null
          ? null
          : GeoPoint.fromJson(json['destination'] as Map<String, dynamic>),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      durationDays: (json['duration_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TravelRouteImplToJson(_$TravelRouteImpl instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'start_date': instance.startDate?.toIso8601String(),
      'duration_days': instance.durationDays,
    };
