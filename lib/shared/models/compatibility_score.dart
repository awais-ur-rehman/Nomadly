import 'package:freezed_annotation/freezed_annotation.dart';

part 'compatibility_score.freezed.dart';
part 'compatibility_score.g.dart';

@freezed
class CompatibilityScore with _$CompatibilityScore {
  const factory CompatibilityScore({
    @JsonKey(name: 'route_overlap') @Default(0) int routeOverlap,
    @JsonKey(name: 'temporal_overlap') @Default(0) int temporalOverlap,
    @JsonKey(name: 'hobby_match') @Default(0) int hobbyMatch,
    @Default(0) int proximity,
    @Default(0) int trust,
    @JsonKey(name: 'rig_compatibility') @Default(0) int rigCompatibility,
    @Default(0) int total,
  }) = _CompatibilityScore;

  factory CompatibilityScore.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityScoreFromJson(json);
}
