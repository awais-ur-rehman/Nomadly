import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_point.freezed.dart';
part 'geo_point.g.dart';

@freezed
class GeoPoint with _$GeoPoint {
  // Private constructor required for adding getters to Freezed class
  const GeoPoint._();

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

  /// Get latitude from coordinates array (GeoJSON format: [lng, lat])
  double get latitude => coordinates.length >= 2 ? coordinates[1] : 0.0;

  /// Get longitude from coordinates array (GeoJSON format: [lng, lat])
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
}

