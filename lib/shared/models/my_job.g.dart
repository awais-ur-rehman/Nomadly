// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MyJobImpl _$$MyJobImplFromJson(Map<String, dynamic> json) => _$MyJobImpl(
  id: _readId(json, '_id') as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  budget: (json['budget'] as num).toDouble(),
  budgetType: json['budget_type'] as String,
  location: MyJobLocation.fromJson(json['location'] as Map<String, dynamic>),
  isRemote: json['is_remote'] as bool? ?? false,
  status: json['status'] as String? ?? 'open',
  applicationCount: (json['application_count'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$MyJobImplToJson(_$MyJobImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'budget': instance.budget,
      'budget_type': instance.budgetType,
      'location': instance.location,
      'is_remote': instance.isRemote,
      'status': instance.status,
      'application_count': instance.applicationCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$MyJobLocationImpl _$$MyJobLocationImplFromJson(Map<String, dynamic> json) =>
    _$MyJobLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$MyJobLocationImplToJson(_$MyJobLocationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
