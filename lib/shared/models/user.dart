import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';
import 'rig.dart';
import 'travel_route.dart';
import 'nomad_id.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    required String email,
    String? phone,
    required Profile profile,
    Rig? rig,
    TravelRoute? travelRoute,
    @Default(false) bool isBuilder,
    NomadId? nomadId,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
