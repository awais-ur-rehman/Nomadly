// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobImpl _$$JobImplFromJson(Map<String, dynamic> json) => _$JobImpl(
  id: _readId(json, '_id') as String,
  author: User.fromJson(_readAuthor(json, 'author_id') as Map<String, dynamic>),
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  budget: (json['budget'] as num).toDouble(),
  budgetType: json['budget_type'] as String,
  location: JobLocation.fromJson(json['location'] as Map<String, dynamic>),
  isRemote: json['is_remote'] as bool? ?? false,
  status: json['status'] as String? ?? 'open',
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$JobImplToJson(_$JobImpl instance) => <String, dynamic>{
  '_id': instance.id,
  'author_id': instance.author,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'budget': instance.budget,
  'budget_type': instance.budgetType,
  'location': instance.location,
  'is_remote': instance.isRemote,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
};

_$JobLocationImpl _$$JobLocationImplFromJson(Map<String, dynamic> json) =>
    _$JobLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$JobLocationImplToJson(_$JobLocationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
