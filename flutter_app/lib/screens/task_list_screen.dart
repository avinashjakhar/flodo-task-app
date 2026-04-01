import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../providers/task_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/highlighted_text.dart';
import 'task_form_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _searchController = TextEditingController();
  bool _showAutocomplete = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(filterProvider.notifier).setSearch(value);
    ref.read(autocompleteProvider.notifier).search(value);
    setState(() => _showAutocomplete = value.isNotEmpty);
  }

  void _selectAutocomplete(String title) {
    _searchController.text = title;
    ref.read(filterProvider.notifier).setSearch(title);
    setState(() => _showAutocomplete = false);
    FocusScope.of(context).unfocus();
  }

  Future<void> _confirmDelete(BuildContext context, int taskId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Task', style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary)),
        content: Text(
          'Delete "$title"? This cannot be undone.',
          style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(tasksProvider.notifier).deleteTask(taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final filter = ref.watch(filterProvider);
    final autocompleteAsync = ref.watch(autocompleteProvider);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tasks', style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(height: 2),
                      tasksAsync.when(
                        data: (tasks) => Text(
                          '${tasks.length} items',
                          style: GoogleFonts.dmMono(
                              fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaskFormScreen()),
                    ),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.dmSans(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppTheme.textSecondary, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  size: 18, color: AppTheme.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                    ),
                  ),

                  // Autocomplete dropdown
                  if (_showAutocomplete)
                    autocompleteAsync.when(
                      data: (results) => results.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Column(
                                children: results
                                    .map((r) => ListTile(
                                          dense: true,
                                          leading: const Icon(
                                              Icons.search_rounded,
                                              size: 16,
                                              color: AppTheme.textSecondary),
                                          title: HighlightedText(
                                            text: r['title'] as String,
                                            highlight: filter.searchQuery,
                                            baseStyle: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          onTap: () => _selectAutocomplete(
                                              r['title'] as String),
                                        ))
                                    .toList(),
                              ),
                            ).animate().fadeIn(duration: 150.ms),
                      loading: () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.accent,
                            ),
                          ),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms, delay: 50.ms),

            const SizedBox(height: 12),

            // Status filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: filter.statusFilter == null,
                    onSelected: () => ref.read(filterProvider.notifier).setStatus(null),
                  ),
                  const SizedBox(width: 8),
                  ...TaskStatus.values.map((s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: s.label,
                          selected: filter.statusFilter == s,
                          onSelected: () =>
                              ref.read(filterProvider.notifier).setStatus(s),
                        ),
                      )),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 16),

            // Task list
            Expanded(
              child: tasksAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.accent),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            size: 48, color: AppTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              ref.read(tasksProvider.notifier).refresh(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (tasks) => tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_box_outline_blank_rounded,
                                size: 56, color: AppTheme.border),
                            const SizedBox(height: 16),
                            Text(
                              filter.searchQuery.isNotEmpty ||
                                      filter.statusFilter != null
                                  ? 'No matching tasks'
                                  : 'No tasks yet.\nTap + to create one.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                  color: AppTheme.textSecondary, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppTheme.accent,
                        backgroundColor: AppTheme.surface,
                        onRefresh: () =>
                            ref.read(tasksProvider.notifier).refresh(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: tasks.length,
                          itemBuilder: (ctx, i) => TaskCard(
                            task: tasks[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TaskFormScreen(existingTask: tasks[i]),
                              ),
                            ),
                            onDelete: () => _confirmDelete(
                                context, tasks[i].id, tasks[i].title),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentSoft : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.accent : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
