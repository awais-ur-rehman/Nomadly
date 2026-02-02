// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  List<User> get participants => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'direct', 'group'
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
    Conversation value,
    $Res Function(Conversation) then,
  ) = _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    List<User> participants,
    String type,
    String? lastMessage,
    DateTime? lastMessageTime,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participants = null,
    Object? type = null,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<User>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageTime: freezed == lastMessageTime
                ? _value.lastMessageTime
                : lastMessageTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
    _$ConversationImpl value,
    $Res Function(_$ConversationImpl) then,
  ) = __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    List<User> participants,
    String type,
    String? lastMessage,
    DateTime? lastMessageTime,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
    _$ConversationImpl _value,
    $Res Function(_$ConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participants = null,
    Object? type = null,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ConversationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<User>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageTime: freezed == lastMessageTime
            ? _value.lastMessageTime
            : lastMessageTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl({
    @JsonKey(name: '_id') required this.id,
    final List<User> participants = const [],
    this.type = 'direct',
    this.lastMessage,
    this.lastMessageTime,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _participants = participants;

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  final List<User> _participants;
  @override
  @JsonKey()
  List<User> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final String type;
  // 'direct', 'group'
  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageTime;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Conversation(id: $id, participants: $participants, type: $type, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_participants),
    type,
    lastMessage,
    lastMessageTime,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(this);
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation({
    @JsonKey(name: '_id') required final String id,
    final List<User> participants,
    final String type,
    final String? lastMessage,
    final DateTime? lastMessageTime,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  List<User> get participants;
  @override
  String get type; // 'direct', 'group'
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageTime;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
