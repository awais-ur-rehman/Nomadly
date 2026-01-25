import 'package:freezed_annotation/freezed_annotation.dart';
import 'geo_point.dart';
import 'user.dart';

part 'beacon.freezed.dart';
part 'beacon.g.dart';

@freezed
class Beacon with _$Beacon {
  const factory Beacon({
    required String id,
    required User author,
    required String message,
    required GeoPoint location,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default([]) List<String> likes,
  }) = _Beacon;

  factory Beacon.fromJson(Map<String, dynamic> json) => _$BeaconFromJson(json);
}
