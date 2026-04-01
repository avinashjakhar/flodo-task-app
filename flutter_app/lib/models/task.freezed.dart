// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BlockedByInfo _$BlockedByInfoFromJson(Map<String, dynamic> json) {
  return _BlockedByInfo.fromJson(json);
}

/// @nodoc
mixin _$BlockedByInfo {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;

  /// Serializes this BlockedByInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockedByInfoCopyWith<BlockedByInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockedByInfoCopyWith<$Res> {
  factory $BlockedByInfoCopyWith(
          BlockedByInfo value, $Res Function(BlockedByInfo) then) =
      _$BlockedByInfoCopyWithImpl<$Res, BlockedByInfo>;
  @useResult
  $Res call({int id, String title, TaskStatus status});
}

/// @nodoc
class _$BlockedByInfoCopyWithImpl<$Res, $Val extends BlockedByInfo>
    implements $BlockedByInfoCopyWith<$Res> {
  _$BlockedByInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlockedByInfoImplCopyWith<$Res>
    implements $BlockedByInfoCopyWith<$Res> {
  factory _$$BlockedByInfoImplCopyWith(
          _$BlockedByInfoImpl value, $Res Function(_$BlockedByInfoImpl) then) =
      __$$BlockedByInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, TaskStatus status});
}

/// @nodoc
class __$$BlockedByInfoImplCopyWithImpl<$Res>
    extends _$BlockedByInfoCopyWithImpl<$Res, _$BlockedByInfoImpl>
    implements _$$BlockedByInfoImplCopyWith<$Res> {
  __$$BlockedByInfoImplCopyWithImpl(
      _$BlockedByInfoImpl _value, $Res Function(_$BlockedByInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlockedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
  }) {
    return _then(_$BlockedByInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockedByInfoImpl implements _BlockedByInfo {
  const _$BlockedByInfoImpl(
      {required this.id, required this.title, required this.status});

  factory _$BlockedByInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockedByInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final TaskStatus status;

  @override
  String toString() {
    return 'BlockedByInfo(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockedByInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, status);

  /// Create a copy of BlockedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockedByInfoImplCopyWith<_$BlockedByInfoImpl> get copyWith =>
      __$$BlockedByInfoImplCopyWithImpl<_$BlockedByInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockedByInfoImplToJson(
      this,
    );
  }
}

abstract class _BlockedByInfo implements BlockedByInfo {
  const factory _BlockedByInfo(
      {required final int id,
      required final String title,
      required final TaskStatus status}) = _$BlockedByInfoImpl;

  factory _BlockedByInfo.fromJson(Map<String, dynamic> json) =
      _$BlockedByInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  TaskStatus get status;

  /// Create a copy of BlockedByInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockedByInfoImplCopyWith<_$BlockedByInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  int? get blockedById => throw _privateConstructorUsedError;
  BlockedByInfo? get blockedBy => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      DateTime dueDate,
      TaskStatus status,
      int? blockedById,
      BlockedByInfo? blockedBy});

  $BlockedByInfoCopyWith<$Res>? get blockedBy;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? status = null,
    Object? blockedById = freezed,
    Object? blockedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      blockedById: freezed == blockedById
          ? _value.blockedById
          : blockedById // ignore: cast_nullable_to_non_nullable
              as int?,
      blockedBy: freezed == blockedBy
          ? _value.blockedBy
          : blockedBy // ignore: cast_nullable_to_non_nullable
              as BlockedByInfo?,
    ) as $Val);
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockedByInfoCopyWith<$Res>? get blockedBy {
    if (_value.blockedBy == null) {
      return null;
    }

    return $BlockedByInfoCopyWith<$Res>(_value.blockedBy!, (value) {
      return _then(_value.copyWith(blockedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      DateTime dueDate,
      TaskStatus status,
      int? blockedById,
      BlockedByInfo? blockedBy});

  @override
  $BlockedByInfoCopyWith<$Res>? get blockedBy;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? status = null,
    Object? blockedById = freezed,
    Object? blockedBy = freezed,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      blockedById: freezed == blockedById
          ? _value.blockedById
          : blockedById // ignore: cast_nullable_to_non_nullable
              as int?,
      blockedBy: freezed == blockedBy
          ? _value.blockedBy
          : blockedBy // ignore: cast_nullable_to_non_nullable
              as BlockedByInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      this.description = '',
      required this.dueDate,
      this.status = TaskStatus.todo,
      this.blockedById,
      this.blockedBy});

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime dueDate;
  @override
  @JsonKey()
  final TaskStatus status;
  @override
  final int? blockedById;
  @override
  final BlockedByInfo? blockedBy;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, status: $status, blockedById: $blockedById, blockedBy: $blockedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.blockedById, blockedById) ||
                other.blockedById == blockedById) &&
            (identical(other.blockedBy, blockedBy) ||
                other.blockedBy == blockedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, dueDate,
      status, blockedById, blockedBy);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final int id,
      required final String title,
      final String description,
      required final DateTime dueDate,
      final TaskStatus status,
      final int? blockedById,
      final BlockedByInfo? blockedBy}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get dueDate;
  @override
  TaskStatus get status;
  @override
  int? get blockedById;
  @override
  BlockedByInfo? get blockedBy;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskDraft _$TaskDraftFromJson(Map<String, dynamic> json) {
  return _TaskDraft.fromJson(json);
}

/// @nodoc
mixin _$TaskDraft {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  int? get blockedById => throw _privateConstructorUsedError;

  /// Serializes this TaskDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskDraftCopyWith<TaskDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskDraftCopyWith<$Res> {
  factory $TaskDraftCopyWith(TaskDraft value, $Res Function(TaskDraft) then) =
      _$TaskDraftCopyWithImpl<$Res, TaskDraft>;
  @useResult
  $Res call(
      {String title,
      String description,
      DateTime? dueDate,
      TaskStatus status,
      int? blockedById});
}

/// @nodoc
class _$TaskDraftCopyWithImpl<$Res, $Val extends TaskDraft>
    implements $TaskDraftCopyWith<$Res> {
  _$TaskDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? status = null,
    Object? blockedById = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      blockedById: freezed == blockedById
          ? _value.blockedById
          : blockedById // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskDraftImplCopyWith<$Res>
    implements $TaskDraftCopyWith<$Res> {
  factory _$$TaskDraftImplCopyWith(
          _$TaskDraftImpl value, $Res Function(_$TaskDraftImpl) then) =
      __$$TaskDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      DateTime? dueDate,
      TaskStatus status,
      int? blockedById});
}

/// @nodoc
class __$$TaskDraftImplCopyWithImpl<$Res>
    extends _$TaskDraftCopyWithImpl<$Res, _$TaskDraftImpl>
    implements _$$TaskDraftImplCopyWith<$Res> {
  __$$TaskDraftImplCopyWithImpl(
      _$TaskDraftImpl _value, $Res Function(_$TaskDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? status = null,
    Object? blockedById = freezed,
  }) {
    return _then(_$TaskDraftImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      blockedById: freezed == blockedById
          ? _value.blockedById
          : blockedById // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskDraftImpl implements _TaskDraft {
  const _$TaskDraftImpl(
      {this.title = '',
      this.description = '',
      this.dueDate,
      this.status = TaskStatus.todo,
      this.blockedById});

  factory _$TaskDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskDraftImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? dueDate;
  @override
  @JsonKey()
  final TaskStatus status;
  @override
  final int? blockedById;

  @override
  String toString() {
    return 'TaskDraft(title: $title, description: $description, dueDate: $dueDate, status: $status, blockedById: $blockedById)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskDraftImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.blockedById, blockedById) ||
                other.blockedById == blockedById));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, dueDate, status, blockedById);

  /// Create a copy of TaskDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskDraftImplCopyWith<_$TaskDraftImpl> get copyWith =>
      __$$TaskDraftImplCopyWithImpl<_$TaskDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskDraftImplToJson(
      this,
    );
  }
}

abstract class _TaskDraft implements TaskDraft {
  const factory _TaskDraft(
      {final String title,
      final String description,
      final DateTime? dueDate,
      final TaskStatus status,
      final int? blockedById}) = _$TaskDraftImpl;

  factory _TaskDraft.fromJson(Map<String, dynamic> json) =
      _$TaskDraftImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  DateTime? get dueDate;
  @override
  TaskStatus get status;
  @override
  int? get blockedById;

  /// Create a copy of TaskDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskDraftImplCopyWith<_$TaskDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
