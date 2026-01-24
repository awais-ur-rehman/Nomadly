// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TravelRouteImpl _$$TravelRouteImplFromJson(Map<String, dynamic> json) =>
    _$TravelRouteImpl(
      origin: GeoPoint.fromJson(json['origin'] as Map<String, dynamic>),
      destination: GeoPoint.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      durationDays: (json['durationDays'] as num).toInt(),
    );

Map<String, dynamic> _$$TravelRouteImplToJson(_$TravelRouteImpl instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'durationDays': instance.durationDays,
    };
