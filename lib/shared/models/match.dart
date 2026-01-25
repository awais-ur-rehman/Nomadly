import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'geo_point.dart';

part 'match.freezed.dart';
part 'match.g.dart';

@freezed
class Match with _$Match {
  const factory Match({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String matchedUserId,
    required String swipeAction, // 'left', 'right', 'star'
    @Default(false) bool isMutual,
    DateTime? createdAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class DiscoveryUser with _$DiscoveryUser {
  const factory DiscoveryUser({
    required User user,
    GeoPoint? intersection,
    double? distance,
    int? score,
    @Default([]) List<String> commonHobbies,
  }) = _DiscoveryUser;

  factory DiscoveryUser.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryUserFromJson(json);
}
