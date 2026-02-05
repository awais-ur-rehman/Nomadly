// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationItemImpl _$$VerificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$VerificationItemImpl(
  status: json['status'] as String? ?? 'none',
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
);

Map<String, dynamic> _$$VerificationItemImplToJson(
  _$VerificationItemImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'verified_at': instance.verifiedAt?.toIso8601String(),
};

_$PhoneVerificationImpl _$$PhoneVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$PhoneVerificationImpl(
  status: json['status'] as String? ?? 'none',
  number: json['number'] as String?,
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
);

Map<String, dynamic> _$$PhoneVerificationImplToJson(
  _$PhoneVerificationImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'number': instance.number,
  'verified_at': instance.verifiedAt?.toIso8601String(),
};

_$PhotoVerificationImpl _$$PhotoVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$PhotoVerificationImpl(
  status: json['status'] as String? ?? 'none',
  selfieUrl: json['selfie_url'] as String?,
  submittedAt: json['submitted_at'] == null
      ? null
      : DateTime.parse(json['submitted_at'] as String),
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  rejectionReason: json['rejection_reason'] as String?,
);

Map<String, dynamic> _$$PhotoVerificationImplToJson(
  _$PhotoVerificationImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'selfie_url': instance.selfieUrl,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'rejection_reason': instance.rejectionReason,
};

_$IdDocVerificationImpl _$$IdDocVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$IdDocVerificationImpl(
  status: json['status'] as String? ?? 'none',
  documentUrl: json['document_url'] as String?,
  documentType: json['document_type'] as String?,
  submittedAt: json['submitted_at'] == null
      ? null
      : DateTime.parse(json['submitted_at'] as String),
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  rejectionReason: json['rejection_reason'] as String?,
);

Map<String, dynamic> _$$IdDocVerificationImplToJson(
  _$IdDocVerificationImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'document_url': instance.documentUrl,
  'document_type': instance.documentType,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'rejection_reason': instance.rejectionReason,
};

_$CommunityVerificationImpl _$$CommunityVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityVerificationImpl(
  status: json['status'] as String? ?? 'none',
  vouchCount: (json['vouch_count'] as num?)?.toInt() ?? 0,
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
);

Map<String, dynamic> _$$CommunityVerificationImplToJson(
  _$CommunityVerificationImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'vouch_count': instance.vouchCount,
  'verified_at': instance.verifiedAt?.toIso8601String(),
};

_$VerificationImpl _$$VerificationImplFromJson(Map<String, dynamic> json) =>
    _$VerificationImpl(
      email: json['email'] == null
          ? null
          : VerificationItem.fromJson(json['email'] as Map<String, dynamic>),
      phone: json['phone'] == null
          ? null
          : PhoneVerification.fromJson(json['phone'] as Map<String, dynamic>),
      photo: json['photo'] == null
          ? null
          : PhotoVerification.fromJson(json['photo'] as Map<String, dynamic>),
      idDocument: json['id_document'] == null
          ? null
          : IdDocVerification.fromJson(
              json['id_document'] as Map<String, dynamic>,
            ),
      community: json['community'] == null
          ? null
          : CommunityVerification.fromJson(
              json['community'] as Map<String, dynamic>,
            ),
      level: (json['level'] as num?)?.toInt() ?? 0,
      badge: json['badge'] as String? ?? 'none',
    );

Map<String, dynamic> _$$VerificationImplToJson(_$VerificationImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'photo': instance.photo,
      'id_document': instance.idDocument,
      'community': instance.community,
      'level': instance.level,
      'badge': instance.badge,
    };
