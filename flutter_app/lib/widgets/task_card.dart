import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  bool get _isBlocked {
    if (task.blockedBy == null) return false;
    return task.blockedBy!.status != TaskStatus.done;
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 250)),
        SlideEffect(
          begin: Offset(0, 0.05),
          end: Offset.zero,
          duration: Duration(milliseconds: 250),
        ),
      ],
      child: Opacity(
        opacity: _isBlocked ? 0.45 : 1.0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isBlocked
                    ? AppTheme.blocked
                    : task.status == TaskStatus.done
                        ? AppTheme.success.withOpacity(0.3)
                        : AppTheme.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blocked banner
                if (_isBlocked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.blocked,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded,
                            size: 12, color: AppTheme.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Blocked by: ${task.blockedBy!.title}',
                          style: GoogleFonts.dmMono(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: task.status == TaskStatus.done
                                    ? AppTheme.textSecondary
                                    : AppTheme.textPrimary,
                                decoration: task.status == TaskStatus.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 18),
                            color: AppTheme.textSecondary,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          StatusBadge(status: task.status),
                          const Spacer(),
                          Icon(Icons.calendar_today_outlined,
                              size: 12, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, yyyy').format(task.dueDate),
                            style: GoogleFonts.dmMono(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
