// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchingProfileImpl _$$MatchingProfileImplFromJson(
  Map<String, dynamic> json,
) => _$MatchingProfileImpl(
  intent: json['intent'] as String? ?? 'friends',
  preferences: json['preferences'] == null
      ? const MatchingPreferences()
      : MatchingPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>,
        ),
  isDiscoverable: json['is_discoverable'] as bool? ?? true,
);

Map<String, dynamic> _$$MatchingProfileImplToJson(
  _$MatchingProfileImpl instance,
) => <String, dynamic>{
  'intent': instance.intent,
  'preferences': instance.preferences,
  'is_discoverable': instance.isDiscoverable,
};

_$MatchingPreferencesImpl _$$MatchingPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$MatchingPreferencesImpl(
  genderInterest:
      (json['gender_interest'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  minAge: (json['min_age'] as num?)?.toInt() ?? 18,
  maxAge: (json['max_age'] as num?)?.toInt() ?? 100,
  maxDistanceKm: (json['max_distance_km'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$$MatchingPreferencesImplToJson(
  _$MatchingPreferencesImpl instance,
) => <String, dynamic>{
  'gender_interest': instance.genderInterest,
  'min_age': instance.minAge,
  'max_age': instance.maxAge,
  'max_distance_km': instance.maxDistanceKm,
};
