import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg, icon) = switch (status) {
      TaskStatus.todo => (AppTheme.textSecondary, AppTheme.border, Icons.circle_outlined),
      TaskStatus.inProgress => (AppTheme.warning, const Color(0x33F59E0B), Icons.timelapse_rounded),
      TaskStatus.done => (AppTheme.success, const Color(0x332DD4A0), Icons.check_circle_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: GoogleFonts.dmMono(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
