// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockedByInfoImpl _$$BlockedByInfoImplFromJson(Map<String, dynamic> json) =>
    _$BlockedByInfoImpl(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$BlockedByInfoImplToJson(_$BlockedByInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': _$TaskStatusEnumMap[instance.status]!,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'To-Do',
  TaskStatus.inProgress: 'In Progress',
  TaskStatus.done: 'Done',
};

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      dueDate: DateTime.parse((json['due_date'] as String?) ?? DateTime.now().toIso8601String()),
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.todo,
      blockedById: (json['blocked_by_id'] as num?)?.toInt(),
      blockedBy: json['blocked_by'] == null
          ? null
          : BlockedByInfo.fromJson(json['blocked_by'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'due_date': instance.dueDate.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'blocked_by_id': instance.blockedById,
      'blocked_by': instance.blockedBy?.toJson(),
    };

_$TaskDraftImpl _$$TaskDraftImplFromJson(Map<String, dynamic> json) =>
    _$TaskDraftImpl(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.todo,
      blockedById: (json['blockedById'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TaskDraftImplToJson(_$TaskDraftImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate?.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'blockedById': instance.blockedById,
    };
