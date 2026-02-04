import 'package:freezed_annotation/freezed_annotation.dart';

part 'matching_profile.freezed.dart';
part 'matching_profile.g.dart';

@freezed
class MatchingProfile with _$MatchingProfile {
  const factory MatchingProfile({
    @Default('friends') String intent,
    @Default(MatchingPreferences()) MatchingPreferences preferences,
    @JsonKey(name: 'is_discoverable') @Default(true) bool isDiscoverable,
  }) = _MatchingProfile;

  factory MatchingProfile.fromJson(Map<String, dynamic> json) => _$MatchingProfileFromJson(json);
}

@freezed
class MatchingPreferences with _$MatchingPreferences {
  const factory MatchingPreferences({
    @JsonKey(name: 'gender_interest') @Default([]) List<String> genderInterest,
    @JsonKey(name: 'min_age') @Default(18) int minAge,
    @JsonKey(name: 'max_age') @Default(100) int maxAge,
    @JsonKey(name: 'max_distance_km') @Default(100) int maxDistanceKm,
  }) = _MatchingPreferences;

  factory MatchingPreferences.fromJson(Map<String, dynamic> json) => _$MatchingPreferencesFromJson(json);
}
