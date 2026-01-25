import 'package:freezed_annotation/freezed_annotation.dart';
import 'geo_point.dart';
import 'user.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String title,
    required String description,
    required String type, // 'hike', 'surf', 'yoga', 'meal', 'social', 'cowork', 'other'
    required GeoPoint location,
    required DateTime startTime,
    DateTime? endTime,
    required User creator,
    @Default([]) List<User> participants,
    @Default(0) int maxParticipants,
    String? imageUrl,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
