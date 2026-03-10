import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/task_store.dart';
import '../task_editor_sheet.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final bool isDark;

  const TaskTile({super.key, required this.task, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.65);

    final borderColor = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.9);

    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: borderColor),
            ),

            child: Row(
              children: [
                /// Checkbox
                InkWell(
                  onTap: () => TaskStore.toggle(task),

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    width: 26,
                    height: 26,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.completed
                            ? Colors.green
                            : textColor.withOpacity(0.4),
                      ),

                      color: task.completed ? Colors.green : Colors.transparent,
                    ),

                    child: task.completed
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(width: 14),

                /// Task text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 17,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                /// menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: textColor),

                  onSelected: (value) {
                    if (value == "edit") {
                      TaskEditorSheet.open(context, existing: task);
                    }

                    if (value == "delete") {
                      TaskStore.delete(task);
                    }
                  },

                  itemBuilder: (_) => const [
                    PopupMenuItem(value: "edit", child: Text("Edit")),

                    PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
