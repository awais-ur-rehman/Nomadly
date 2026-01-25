import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'builder.freezed.dart';
part 'builder.g.dart';

@freezed
class BuilderProfile with _$BuilderProfile {
  const factory BuilderProfile({
    required String id,
    required User user,
    required String businessName,
    required String description,
    @Default([]) List<String> specialty, // 'van', 'rv', 'bus', 'electrical', 'solar', etc.
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default([]) List<String> portfolioImageUrls,
    required bool isVerified,
    String? locationBase,
  }) = _BuilderProfile;

  factory BuilderProfile.fromJson(Map<String, dynamic> json) => _$BuilderProfileFromJson(json);
}

@freezed
class BuilderReview with _$BuilderReview {
  const factory BuilderReview({
    required String id,
    required String authorName,
    required String authorPhotoUrl,
    required double rating,
    required String comment,
    required DateTime createdAt,
  }) = _BuilderReview;

  factory BuilderReview.fromJson(Map<String, dynamic> json) => _$BuilderReviewFromJson(json);
}
