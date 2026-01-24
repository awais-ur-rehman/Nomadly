import 'package:freezed_annotation/freezed_annotation.dart';

part 'rig.freezed.dart';
part 'rig.g.dart';

@freezed
class Rig with _$Rig {
  const factory Rig({
    required String type, // 'sprinter', 'skoolie', 'suv', 'truck_camper'
    required String crewType, // 'solo', 'couple', 'with_pets'
    @Default(false) bool petFriendly,
  }) = _Rig;

  factory Rig.fromJson(Map<String, dynamic> json) => _$RigFromJson(json);
}
