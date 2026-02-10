import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'compatibility_score.dart';

part 'recommended_user.freezed.dart';
part 'recommended_user.g.dart';

/// A user enriched with scoring data from the recommendations endpoint.
///
/// The backend returns each recommendation with the full user fields plus
/// `compatibility` (score breakdown) and `distance_km`. This model wraps
/// the parsed [User] together with those extra fields so the matching UI
/// can display scores and distance without modifying the core User model.
@freezed
class RecommendedUser with _$RecommendedUser {
  const RecommendedUser._();

  const factory RecommendedUser({
    required User user,
    CompatibilityScore? compatibility,
    @JsonKey(name: 'distance_km') double? distanceKm,
  }) = _RecommendedUser;

  /// Parses the flat recommendation JSON from the backend into a
  /// [RecommendedUser]. The backend response is a single flat object
  /// containing user fields + `compatibility` + `distance_km`.
  factory RecommendedUser.fromRecommendationJson(Map<String, dynamic> json) {
    final compatibility = json['compatibility'] != null
        ? CompatibilityScore.fromJson(
            Map<String, dynamic>.from(json['compatibility']))
        : null;
    final distanceKm = (json['distance_km'] as num?)?.toDouble();

    return RecommendedUser(
      user: User.fromJson(json),
      compatibility: compatibility,
      distanceKm: distanceKm,
    );
  }

  factory RecommendedUser.fromJson(Map<String, dynamic> json) =>
      _$RecommendedUserFromJson(json);
}
