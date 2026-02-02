import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification.freezed.dart';
part 'verification.g.dart';

@freezed
class VerificationItem with _$VerificationItem {
  const factory VerificationItem({
    @Default('none') String status, // none, submitted, pending, verified, rejected
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _VerificationItem;

  factory VerificationItem.fromJson(Map<String, dynamic> json) =>
      _$VerificationItemFromJson(json);
}

@freezed
class PhoneVerification with _$PhoneVerification {
  const factory PhoneVerification({
    @Default('none') String status,
    String? number,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _PhoneVerification;

  factory PhoneVerification.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerificationFromJson(json);
}

@freezed
class PhotoVerification with _$PhotoVerification {
  const factory PhotoVerification({
    @Default('none') String status,
    @JsonKey(name: 'selfie_url') String? selfieUrl,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  }) = _PhotoVerification;

  factory PhotoVerification.fromJson(Map<String, dynamic> json) =>
      _$PhotoVerificationFromJson(json);
}

@freezed
class IdDocVerification with _$IdDocVerification {
  const factory IdDocVerification({
    @Default('none') String status,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  }) = _IdDocVerification;

  factory IdDocVerification.fromJson(Map<String, dynamic> json) =>
      _$IdDocVerificationFromJson(json);
}

@freezed
class CommunityVerification with _$CommunityVerification {
  const factory CommunityVerification({
    @Default('none') String status,
    @JsonKey(name: 'vouch_count') @Default(0) int vouchCount,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _CommunityVerification;

  factory CommunityVerification.fromJson(Map<String, dynamic> json) =>
      _$CommunityVerificationFromJson(json);
}

@freezed
class Verification with _$Verification {
  const Verification._();

  const factory Verification({
    VerificationItem? email,
    PhoneVerification? phone,
    PhotoVerification? photo,
    @JsonKey(name: 'id_document') IdDocVerification? idDocument,
    CommunityVerification? community,
    @Default(0) int level,
    @Default('none') String badge,
  }) = _Verification;

  bool get isVerified => level >= 3;

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);
}
