import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String name,
    int? age,
    String? gender,
    String? photoUrl,
    @Default([]) List<String> hobbies,
    @Default('friends') String intent, // 'friends', 'dating', 'both'
    String? bio,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
