import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';
import 'rig.dart';
import 'travel_route.dart';
import 'nomad_id.dart';
import 'verification.dart';
import 'matching_profile.dart';
import 'post.dart';

export 'profile.dart';
export 'rig.dart';
export 'travel_route.dart';
export 'nomad_id.dart';
export 'verification.dart';
export 'matching_profile.dart';
export 'post.dart';

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
    @JsonKey(name: 'travel_route') TravelRoute? travelRoute,
    @JsonKey(name: 'is_builder') @Default(false) bool isBuilder,
    @JsonKey(name: 'is_private') @Default(false) bool isPrivate,
    @JsonKey(name: 'nomad_id') NomadId? nomadId,
    Verification? verification,
    @JsonKey(name: 'matching_profile') MatchingProfile? matchingProfile,
    @JsonKey(name: 'invited_by') String? invitedBy,
    @JsonKey(name: 'invite_count') @Default(0) int inviteCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(false) bool isFollowing,
    @Default(false) bool followsMe,
    @Default(false) bool isFollowingPending,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  String get uid => id ?? idSecondary ?? '';

  /// Verification level (0-5). Falls back to legacy nomadId check.
  int get verificationLevel => verification?.level ?? (nomadId?.verified == true ? 3 : 0);

  /// Human-readable badge name for display.
  String get verificationBadge => verification?.badge ?? 'none';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
