import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

@freezed
class TripInterest with _$TripInterest {
  const factory TripInterest({
    @JsonKey(name: 'user_id') required User user,
    @Default('') String message,
    @Default('pending') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _TripInterest;

  factory TripInterest.fromJson(Map<String, dynamic> json) =>
      _$TripInterestFromJson(json);
}

@freezed
class TripLocation with _$TripLocation {
  const TripLocation._();

  const factory TripLocation({
    required String type,
    required List<double> coordinates,
    @JsonKey(name: 'place_name') String? placeName,
  }) = _TripLocation;

  factory TripLocation.fromJson(Map<String, dynamic> json) =>
      _$TripLocationFromJson(json);

  double get latitude => coordinates.length >= 2 ? coordinates[1] : 0.0;
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
}

@freezed
class Trip with _$Trip {
  const Trip._();

  const factory Trip({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'creator_id') required User creator,
    required String title,
    @Default('') String description,
    required TripLocation origin,
    required TripLocation destination,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'duration_days') required int durationDays,
    @JsonKey(name: 'looking_for_companions') @Default(true) bool lookingForCompanions,
    @JsonKey(name: 'max_companions') @Default(4) int maxCompanions,
    @JsonKey(name: 'interested_users') @Default([]) List<TripInterest> interestedUsers,
    @Default([]) List<User> companions,
    @Default('planning') String status,
    @Default('public') String visibility,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Computed fields from backend
    @Default(false) bool isCreator,
    @Default(false) bool isCompanion,
    String? myInterestStatus,
    @Default(0) int pendingCount,
    int? spotsLeft,
    int? companionCount,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  DateTime get endDate => startDate.add(Duration(days: durationDays - 1));

  bool get isActive {
    final now = DateTime.now();
    return startDate.isBefore(now) && endDate.isAfter(now);
  }

  bool get isUpcoming => startDate.isAfter(DateTime.now());

  int get availableSpots => spotsLeft ?? (maxCompanions - companions.length);
}
