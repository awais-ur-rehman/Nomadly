// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobApplicationImpl _$$JobApplicationImplFromJson(Map<String, dynamic> json) =>
    _$JobApplicationImpl(
      id: _readId(json, '_id') as String,
      job: _readJob(json, 'job_id') == null
          ? null
          : Job.fromJson(_readJob(json, 'job_id') as Map<String, dynamic>),
      applicant: _readApplicant(json, 'applicant_id') == null
          ? null
          : User.fromJson(
              _readApplicant(json, 'applicant_id') as Map<String, dynamic>,
            ),
      coverLetter: json['cover_letter'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$JobApplicationImplToJson(
  _$JobApplicationImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'job_id': instance.job,
  'applicant_id': instance.applicant,
  'cover_letter': instance.coverLetter,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
};
