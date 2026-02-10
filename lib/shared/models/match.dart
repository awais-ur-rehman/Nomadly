import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'geo_point.dart';

part 'match.freezed.dart';
part 'match.g.dart';

@freezed
class Match with _$Match {
  const Match._();

  const factory Match({
    @JsonKey(name: '_id') String? id,
    String? userId,
    String? matchedUserId,
    @JsonKey(name: 'conversation_id') dynamic conversationId,
    @Default(false) bool isMutual,
    User? matchedUser,
    DateTime? createdAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  String get safeId => id ?? '';

  String? get safeConversationId {
    if (conversationId is String) return conversationId as String;
    if (conversationId is Map) return (conversationId as Map)['_id'] as String?;
    return null;
  }
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
