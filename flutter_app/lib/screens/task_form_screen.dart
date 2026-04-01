import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../models/task.dart';
import '../providers/task_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? existingTask;

  const TaskFormScreen({super.key, this.existingTask});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isEditing) {
        final task = widget.existingTask!;
        final draft = TaskDraft(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          status: task.status,
          blockedById: task.blockedById,
        );
        ref.read(taskFormProvider.notifier).loadDraft(draft);
        _titleController.text = task.title;
        _descController.text = task.description;
      } else {
        // Load persisted draft for new task creation
        final saved = await ref.read(draftServiceProvider).loadDraft();
        if (saved != null && mounted) {
          ref.read(taskFormProvider.notifier).loadDraft(saved);
          _titleController.text = saved.title;
          _descController.text = saved.description;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final current = ref.read(taskFormProvider).draft.dueDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.accent),
          dialogBackgroundColor: AppTheme.surfaceElevated,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ref.read(taskFormProvider.notifier).updateDueDate(picked);
    }
  }

  Future<void> _submit() async {
    bool success;
    if (_isEditing) {
      success = await ref
          .read(taskFormProvider.notifier)
          .submitUpdate(widget.existingTask!.id);
    } else {
      success = await ref.read(taskFormProvider.notifier).submitCreate();
    }
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(taskFormProvider);
    final draft = formState.draft;

    // Sync controllers with state when loading draft
    if (_titleController.text != draft.title && !formState.isSaving) {
      _titleController.text = draft.title;
      _titleController.selection = TextSelection.collapsed(offset: draft.title.length);
    }

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'New Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: formState.isSaving ? null : _submit,
              child: Text(
                'Save',
                style: GoogleFonts.dmSans(
                  color: formState.isSaving ? AppTheme.textSecondary : AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _Label('Title'),
              const Gap(8),
              TextField(
                controller: _titleController,
                onChanged: (v) =>
                    ref.read(taskFormProvider.notifier).updateTitle(v),
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary),
                decoration: const InputDecoration(hintText: 'Task title...'),
                textCapitalization: TextCapitalization.sentences,
              ).animate().fadeIn(duration: 250.ms, delay: 50.ms),

              const Gap(20),

              // Description
              _Label('Description'),
              const Gap(8),
              TextField(
                controller: _descController,
                onChanged: (v) =>
                    ref.read(taskFormProvider.notifier).updateDescription(v),
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                    hintText: 'Optional description...'),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ).animate().fadeIn(duration: 250.ms, delay: 100.ms),

              const Gap(20),

              // Due Date
              _Label('Due Date'),
              const Gap(8),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppTheme.textSecondary),
                      const Gap(10),
                      Text(
                        draft.dueDate != null
                            ? DateFormat('MMMM d, yyyy').format(draft.dueDate!)
                            : 'Pick a date',
                        style: GoogleFonts.dmSans(
                          color: draft.dueDate != null
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 250.ms, delay: 150.ms),

              const Gap(20),

              // Status
              _Label('Status'),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskStatus>(
                    value: draft.status,
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceElevated,
                    style: GoogleFonts.dmSans(
                        color: AppTheme.textPrimary, fontSize: 14),
                    items: TaskStatus.values
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: StatusBadge(status: s),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(taskFormProvider.notifier)
                            .updateStatus(v);
                      }
                    },
                  ),
                ),
              ).animate().fadeIn(duration: 250.ms, delay: 200.ms),

              const Gap(20),

              // Blocked By
              _Label('Blocked By (optional)'),
              const Gap(8),
              _BlockedByDropdown(
                currentTaskId: widget.existingTask?.id,
                selectedId: draft.blockedById,
                onChanged: (id) =>
                    ref.read(taskFormProvider.notifier).updateBlockedById(id),
              ).animate().fadeIn(duration: 250.ms, delay: 250.ms),

              const Gap(28),

              // Error message
              if (formState.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.danger.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 16, color: AppTheme.danger),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          formState.errorMessage!,
                          style: GoogleFonts.dmSans(
                              color: AppTheme.danger, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: formState.isSaving
                        ? AppTheme.border
                        : AppTheme.accent,
                  ),
                  child: formState.isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              _isEditing ? 'Saving...' : 'Creating...',
                              style: GoogleFonts.dmSans(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Create Task'),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      );
}

class _BlockedByDropdown extends ConsumerWidget {
  final int? currentTaskId;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _BlockedByDropdown({
    this.currentTaskId,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      loading: () => const CircularProgressIndicator(color: AppTheme.accent),
      error: (_, __) => const SizedBox.shrink(),
      data: (tasks) {
        // Filter out the task being edited (can't block itself)
        final eligible = tasks.where((t) => t.id != currentTaskId).toList();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: selectedId,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceElevated,
              style: GoogleFonts.dmSans(
                  color: AppTheme.textPrimary, fontSize: 14),
              hint: Text('None', style: GoogleFonts.dmSans(
                  color: AppTheme.textSecondary, fontSize: 14)),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('None'),
                ),
                ...eligible.map((t) => DropdownMenuItem<int?>(
                      value: t.id,
                      child: Text(
                        t.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ],
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}
