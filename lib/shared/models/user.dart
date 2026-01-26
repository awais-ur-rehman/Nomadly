import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';
import 'rig.dart';
import 'travel_route.dart';
import 'nomad_id.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    @JsonKey(name: '_id', includeIfNull: false) String? idSecondary,
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    String? email,
    String? username,
    String? phone,
    Profile? profile,
    Rig? rig,
    TravelRoute? travelRoute,
    @JsonKey(name: 'is_builder') @Default(false) bool isBuilder,
    @JsonKey(name: 'is_private') @Default(false) bool isPrivate,
    @JsonKey(name: 'nomad_id') NomadId? nomadId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(false) bool isFollowing,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  String get uid => id ?? idSecondary ?? '';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
