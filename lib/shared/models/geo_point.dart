import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_point.freezed.dart';
part 'geo_point.g.dart';

@freezed
class GeoPoint with _$GeoPoint {
  const factory GeoPoint({
    required String type, // 'Point'
    required List<double> coordinates, // [longitude, latitude]
  }) = _GeoPoint;

  factory GeoPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoPointFromJson(json);

  factory GeoPoint.fromLatLng(double lat, double lng) {
    return GeoPoint(
      type: 'Point',
      coordinates: [lng, lat], // GeoJSON format: [longitude, latitude]
    );
  }
}

extension GeoPointExtension on GeoPoint {
  double get latitude => coordinates[1];
  double get longitude => coordinates[0];
}
