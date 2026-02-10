import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/user.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  const factory Job({
    @JsonKey(name: '_id', readValue: _readId) required String id,
    @JsonKey(name: 'author_id', readValue: _readAuthor) required User author,
    required String title,
    required String description,
    required String category,
    required double budget,
    @JsonKey(name: 'budget_type') required String budgetType,
    required JobLocation location,
    @JsonKey(name: 'is_remote') @Default(false) bool isRemote,
    @Default('open') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

// Helper function to read id from either 'id' or '_id'
Object? _readId(Map json, String key) => json['id'] ?? json['_id'];

// Helper function to read author - handles both string ID and populated object
Object? _readAuthor(Map json, String key) {
  final value = json['author_id'];
  if (value is String) {
    // Return a minimal User object when only ID is provided
    return {'_id': value, 'id': value, 'username': 'Unknown'};
  }
  return value;
}

@freezed
class JobLocation with _$JobLocation {
  const factory JobLocation({
    required String type,
    required List<double> coordinates,
  }) = _JobLocation;

  factory JobLocation.fromJson(Map<String, dynamic> json) => _$JobLocationFromJson(json);
}
