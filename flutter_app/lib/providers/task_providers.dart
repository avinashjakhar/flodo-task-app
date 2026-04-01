import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/task_api_service.dart';
import '../services/draft_service.dart';

// ── API Service ──────────────────────────────────────────────
final apiServiceProvider = Provider<TaskApiService>((ref) => TaskApiService());
final draftServiceProvider = Provider<DraftService>((ref) => DraftService());

// ── Filter State ─────────────────────────────────────────────
class FilterState {
  final String searchQuery;
  final TaskStatus? statusFilter;

  const FilterState({this.searchQuery = '', this.statusFilter});

  FilterState copyWith({String? searchQuery, TaskStatus? statusFilter, bool clearStatus = false}) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatus ? null : statusFilter ?? this.statusFilter,
    );
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void setStatus(TaskStatus? status) => state = state.copyWith(
    statusFilter: status,
    clearStatus: status == null,
  );
}

// ── Tasks Provider ────────────────────────────────────────────
final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final filter = ref.watch(filterProvider);
    return _fetchTasks(filter);
  }

  Future<List<Task>> _fetchTasks(FilterState filter) {
    return ref.read(apiServiceProvider).getTasks(
          search: filter.searchQuery.isEmpty ? null : filter.searchQuery,
          status: filter.statusFilter,
        );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final filter = ref.read(filterProvider);
      return _fetchTasks(filter);
    });
  }

  Future<void> createTask(TaskDraft draft) async {
    state = await AsyncValue.guard(() async {
      await ref.read(apiServiceProvider).createTask(
            title: draft.title,
            description: draft.description,
            dueDate: draft.dueDate!,
            status: draft.status,
            blockedById: draft.blockedById,
          );
      final filter = ref.read(filterProvider);
      return _fetchTasks(filter);
    });
  }

  Future<void> updateTask(int id, TaskDraft draft) async {
    state = await AsyncValue.guard(() async {
      await ref.read(apiServiceProvider).updateTask(
            id,
            title: draft.title,
            description: draft.description,
            dueDate: draft.dueDate,
            status: draft.status,
            blockedById: draft.blockedById,
            clearBlockedBy: draft.blockedById == null,
          );
      final filter = ref.read(filterProvider);
      return _fetchTasks(filter);
    });
  }

  Future<void> deleteTask(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(apiServiceProvider).deleteTask(id);
      final filter = ref.read(filterProvider);
      return _fetchTasks(filter);
    });
  }
}

// ── Task Form State ────────────────────────────────────────────
class TaskFormState {
  final TaskDraft draft;
  final bool isSaving;
  final String? errorMessage;

  const TaskFormState({
    this.draft = const TaskDraft(),
    this.isSaving = false,
    this.errorMessage,
  });

  TaskFormState copyWith({
    TaskDraft? draft,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TaskFormState(
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final taskFormProvider =
    StateNotifierProvider.autoDispose<TaskFormNotifier, TaskFormState>(
  (ref) => TaskFormNotifier(ref),
);

class TaskFormNotifier extends StateNotifier<TaskFormState> {
  final Ref _ref;
  Timer? _draftSaveTimer;

  TaskFormNotifier(this._ref) : super(const TaskFormState());

  void loadDraft(TaskDraft draft) {
    state = state.copyWith(draft: draft);
  }

  void updateTitle(String title) {
    state = state.copyWith(
      draft: state.draft.copyWith(title: title),
      clearError: true,
    );
    _scheduleDraftSave();
  }

  void updateDescription(String desc) {
    state = state.copyWith(draft: state.draft.copyWith(description: desc));
    _scheduleDraftSave();
  }

  void updateDueDate(DateTime date) {
    state = state.copyWith(draft: state.draft.copyWith(dueDate: date));
    _scheduleDraftSave();
  }

  void updateStatus(TaskStatus status) {
    state = state.copyWith(draft: state.draft.copyWith(status: status));
    _scheduleDraftSave();
  }

  void updateBlockedById(int? id) {
    state = state.copyWith(draft: state.draft.copyWith(blockedById: id));
    _scheduleDraftSave();
  }

  void _scheduleDraftSave() {
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 500), () {
      _ref.read(draftServiceProvider).saveDraft(state.draft);
    });
  }

  Future<bool> submitCreate() async {
    if (!_validate()) return false;
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _ref.read(tasksProvider.notifier).createTask(state.draft);
      await _ref.read(draftServiceProvider).clearDraft();
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> submitUpdate(int taskId) async {
    if (!_validate()) return false;
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _ref.read(tasksProvider.notifier).updateTask(taskId, state.draft);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }

  bool _validate() {
    if (state.draft.title.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Title is required');
      return false;
    }
    if (state.draft.dueDate == null) {
      state = state.copyWith(errorMessage: 'Due date is required');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
    super.dispose();
  }
}

// ── Autocomplete Provider ─────────────────────────────────────
final autocompleteProvider =
    AsyncNotifierProvider.autoDispose<AutocompleteNotifier, List<Map<String, dynamic>>>(
  AutocompleteNotifier.new,
);

class AutocompleteNotifier
    extends AutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  Timer? _debounce;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    // 1. Tell Riverpod to cancel the timer when this provider is destroyed
    ref.onDispose(() {
      _debounce?.cancel();
    });
    
    // 2. Return your initial state
    return [];
  }

  void search(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () => ref.read(apiServiceProvider).autocomplete(query),
      );
    });
  }
}