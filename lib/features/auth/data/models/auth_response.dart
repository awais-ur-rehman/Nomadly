import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    required String token,
    required String refreshToken,
    required User user,
  }) = _AuthResponse;

  String get uid => user.uid;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class RegisterResponse with _$RegisterResponse {
  const RegisterResponse._();

  const factory RegisterResponse({
    @JsonKey(name: 'userId', includeIfNull: false) String? userIdSecondary,
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    required String email,
    required bool isActive,
  }) = _RegisterResponse;

  String get userId => userIdSecondary ?? id ?? '';

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
