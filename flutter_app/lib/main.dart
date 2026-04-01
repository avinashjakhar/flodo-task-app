import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: FlodoApp()));
}

class FlodoApp extends StatelessWidget {
  const FlodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flodo Tasks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const TaskListScreen(),
    );
  }
}
