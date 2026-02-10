// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripInterestImpl _$$TripInterestImplFromJson(Map<String, dynamic> json) =>
    _$TripInterestImpl(
      user: User.fromJson(json['user_id'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TripInterestImplToJson(_$TripInterestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.user,
      'message': instance.message,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$TripLocationImpl _$$TripLocationImplFromJson(Map<String, dynamic> json) =>
    _$TripLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      placeName: json['place_name'] as String?,
    );

Map<String, dynamic> _$$TripLocationImplToJson(_$TripLocationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'place_name': instance.placeName,
    };

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
  id: json['_id'] as String,
  creator: User.fromJson(json['creator_id'] as Map<String, dynamic>),
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  origin: TripLocation.fromJson(json['origin'] as Map<String, dynamic>),
  destination: TripLocation.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
  startDate: DateTime.parse(json['start_date'] as String),
  durationDays: (json['duration_days'] as num).toInt(),
  lookingForCompanions: json['looking_for_companions'] as bool? ?? true,
  maxCompanions: (json['max_companions'] as num?)?.toInt() ?? 4,
  interestedUsers:
      (json['interested_users'] as List<dynamic>?)
          ?.map((e) => TripInterest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  companions:
      (json['companions'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  status: json['status'] as String? ?? 'planning',
  visibility: json['visibility'] as String? ?? 'public',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  isCreator: json['isCreator'] as bool? ?? false,
  isCompanion: json['isCompanion'] as bool? ?? false,
  myInterestStatus: json['myInterestStatus'] as String?,
  pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
  spotsLeft: (json['spotsLeft'] as num?)?.toInt(),
  companionCount: (json['companionCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'creator_id': instance.creator,
      'title': instance.title,
      'description': instance.description,
      'origin': instance.origin,
      'destination': instance.destination,
      'start_date': instance.startDate.toIso8601String(),
      'duration_days': instance.durationDays,
      'looking_for_companions': instance.lookingForCompanions,
      'max_companions': instance.maxCompanions,
      'interested_users': instance.interestedUsers,
      'companions': instance.companions,
      'status': instance.status,
      'visibility': instance.visibility,
      'created_at': instance.createdAt?.toIso8601String(),
      'isCreator': instance.isCreator,
      'isCompanion': instance.isCompanion,
      'myInterestStatus': instance.myInterestStatus,
      'pendingCount': instance.pendingCount,
      'spotsLeft': instance.spotsLeft,
      'companionCount': instance.companionCount,
    };
