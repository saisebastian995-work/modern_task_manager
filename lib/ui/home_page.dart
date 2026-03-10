import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';
import '../services/task_store.dart';
import 'task_editor_sheet.dart';
import 'widgets/task_tile.dart';

class HomePage extends StatelessWidget {
  final bool isDark;
  final Future<void> Function() onToggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(TaskStore.boxName);

    return Scaffold(
      body: Stack(
        children: [
          // Background changes with theme
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF0B1220),
                          Color(0xFF101B2D),
                          Color(0xFF0A0F1C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [
                          Color(0xFFF4F7FF),
                          Color(0xFFE9F1FF),
                          Color(0xFFF7FBFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
            ),
          ),

          // subtle blobs (optional but looks premium)
          Positioned(
            top: -70,
            left: -50,
            child: _Blob(
              color: const Color(0xFF6C63FF).withOpacity(isDark ? 0.25 : 0.18),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _Blob(
              color: const Color(0xFF00D4FF).withOpacity(isDark ? 0.18 : 0.14),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Text(
                        "My Tasks",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      _GlassIconButton(
                        icon: isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        onTap: () => onToggleTheme(),
                        isDark: isDark,
                        tooltip: "Toggle theme",
                      ),
                      const SizedBox(width: 10),
                      _GlassIconButton(
                        icon: Icons.add_rounded,
                        onTap: () => TaskEditorSheet.open(context),
                        isDark: isDark,
                        tooltip: "New task",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Summary card (Completed status at top)
                  ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (_, __, ___) {
                      final tasks = TaskStore.getTasksSorted();
                      final total = tasks.length;
                      final done = tasks.where((t) => t.completed).length;
                      final progress = total == 0 ? 0.0 : (done / total);

                      return _GlassCard(
                        isDark: isDark,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Completed $done of $total",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: box.listenable(),
                      builder: (_, __, ___) {
                        final tasks = TaskStore.getTasksSorted();

                        if (tasks.isEmpty) {
                          return Center(
                            child: _GlassCard(
                              isDark: isDark,
                              padding: const EdgeInsets.all(18),
                              child: Text(
                                "No tasks yet.\nTap + to add your first task.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 110),
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) =>
                              TaskTile(task: tasks[i], isDark: isDark),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TaskEditorSheet.open(context),
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
      ),
    );
  }
}

/// --- UI Helpers (Glass + blobs) ---

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool isDark;

  const _GlassCard({
    required this.child,
    required this.isDark,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.65);
    final border = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.90);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final String tooltip;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.65);
    final border = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.90);

    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  const _Blob({required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(width: 240, height: 240, color: color),
      ),
    );
  }
}
