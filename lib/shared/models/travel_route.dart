import 'package:freezed_annotation/freezed_annotation.dart';
import 'geo_point.dart';

part 'travel_route.freezed.dart';
part 'travel_route.g.dart';

@freezed
class TravelRoute with _$TravelRoute {
  const factory TravelRoute({
    required GeoPoint origin,
    required GeoPoint destination,
    required DateTime startDate,
    required int durationDays,
  }) = _TravelRoute;

  factory TravelRoute.fromJson(Map<String, dynamic> json) =>
      _$TravelRouteFromJson(json);
}
