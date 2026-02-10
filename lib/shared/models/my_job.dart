import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_job.freezed.dart';
part 'my_job.g.dart';

@freezed
class MyJob with _$MyJob {
  const factory MyJob({
    @JsonKey(name: '_id', readValue: _readId) required String id,
    required String title,
    required String description,
    required String category,
    required double budget,
    @JsonKey(name: 'budget_type') required String budgetType,
    required MyJobLocation location,
    @JsonKey(name: 'is_remote') @Default(false) bool isRemote,
    @Default('open') String status,
    @JsonKey(name: 'application_count') @Default(0) int applicationCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MyJob;

  factory MyJob.fromJson(Map<String, dynamic> json) => _$MyJobFromJson(json);
}

Object? _readId(Map json, String key) => json['id'] ?? json['_id'];

@freezed
class MyJobLocation with _$MyJobLocation {
  const factory MyJobLocation({
    required String type,
    required List<double> coordinates,
  }) = _MyJobLocation;

  factory MyJobLocation.fromJson(Map<String, dynamic> json) =>
      _$MyJobLocationFromJson(json);
}
