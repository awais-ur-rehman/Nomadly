import 'package:freezed_annotation/freezed_annotation.dart';
import 'job.dart';
import 'user.dart';

part 'job_application.freezed.dart';
part 'job_application.g.dart';

@freezed
class JobApplication with _$JobApplication {
  const factory JobApplication({
    @JsonKey(name: '_id', readValue: _readId) required String id,
    @JsonKey(name: 'job_id', readValue: _readJob) Job? job,
    @JsonKey(name: 'applicant_id', readValue: _readApplicant) User? applicant,
    @JsonKey(name: 'cover_letter') required String coverLetter,
    @Default('pending') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _JobApplication;

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);
}

Object? _readId(Map json, String key) => json['id'] ?? json['_id'];

Object? _readJob(Map json, String key) {
  final value = json['job_id'];
  if (value is String) {
    return null;
  }
  return value;
}

Object? _readApplicant(Map json, String key) {
  final value = json['applicant_id'];
  if (value is String) {
    return {'_id': value, 'id': value, 'username': 'Unknown'};
  }
  return value;
}
