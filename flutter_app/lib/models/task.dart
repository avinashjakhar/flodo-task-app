import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus {
  @JsonValue('To-Do')
  todo,
  @JsonValue('In Progress')
  inProgress,
  @JsonValue('Done')
  done,
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

@freezed
class BlockedByInfo with _$BlockedByInfo {
  const factory BlockedByInfo({
    required int id,
    required String title,
    required TaskStatus status,
  }) = _BlockedByInfo;

  factory BlockedByInfo.fromJson(Map<String, dynamic> json) =>
      _$BlockedByInfoFromJson(json);
}

@freezed
class Task with _$Task {
  const factory Task({
    required int id,
    required String title,
    @Default('') String description,
    required DateTime dueDate,
    @Default(TaskStatus.todo) TaskStatus status,
    int? blockedById,
    BlockedByInfo? blockedBy,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class TaskDraft with _$TaskDraft {
  const factory TaskDraft({
    @Default('') String title,
    @Default('') String description,
    DateTime? dueDate,
    @Default(TaskStatus.todo) TaskStatus status,
    int? blockedById,
  }) = _TaskDraft;

  factory TaskDraft.fromJson(Map<String, dynamic> json) =>
      _$TaskDraftFromJson(json);
}
