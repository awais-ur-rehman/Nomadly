import 'package:freezed_annotation/freezed_annotation.dart';

part 'nomad_id.freezed.dart';
part 'nomad_id.g.dart';

@freezed
class NomadId with _$NomadId {
  const factory NomadId({
    @Default(false) bool verified,
    @JsonKey(name: 'member_since') DateTime? memberSince,
    @JsonKey(name: 'vouch_count') @Default(0) int vouchCount,
  }) = _NomadId;

  factory NomadId.fromJson(Map<String, dynamic> json) =>
      _$NomadIdFromJson(json);
}
