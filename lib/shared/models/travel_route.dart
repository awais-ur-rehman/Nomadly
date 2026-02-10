import 'package:freezed_annotation/freezed_annotation.dart';
import 'geo_point.dart';

part 'travel_route.freezed.dart';
part 'travel_route.g.dart';

@freezed
class TravelRoute with _$TravelRoute {
  const factory TravelRoute({
    GeoPoint? origin,
    GeoPoint? destination,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'duration_days') int? durationDays,
  }) = _TravelRoute;

  factory TravelRoute.fromJson(Map<String, dynamic> json) =>
      _$TravelRouteFromJson(json);
}
