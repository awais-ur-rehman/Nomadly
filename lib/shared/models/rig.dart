import 'package:freezed_annotation/freezed_annotation.dart';

part 'rig.freezed.dart';
part 'rig.g.dart';

@freezed
class Rig with _$Rig {
  const factory Rig({
    String? type, // 'sprinter', 'skoolie', 'suv', 'truck_camper'
    @JsonKey(name: 'crew_type') String? crewType, // 'solo', 'couple', 'with_pets'
    @JsonKey(name: 'pet_friendly') @Default(false) bool petFriendly,
  }) = _Rig;

  factory Rig.fromJson(Map<String, dynamic> json) => _$RigFromJson(json);
}
