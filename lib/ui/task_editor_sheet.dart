import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_store.dart';

class TaskEditorSheet extends StatefulWidget {
  final Task? existing;

  const TaskEditorSheet({super.key, this.existing});

  static Future<void> open(BuildContext context, {Task? existing}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskEditorSheet(existing: existing),
      ),
    );
  }

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _titleCtrl;
  String _category = 'Work';

  final List<String> _categories = const [
    'Work',
    'Personal',
    'Health',
    'Study',
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _category = widget.existing?.category ?? 'Work';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final ex = widget.existing;
    if (ex == null) {
      await TaskStore.addTask(title, _category);
    } else {
      // You must have update() in TaskStore (or add it now)
      await TaskStore.updateTask(ex, title, _category);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetBg = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.78);
    final sheetBorder = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.95);
    final textColor = isDark ? Colors.white : Colors.black87;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: sheetBorder),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 52,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Task' : 'New Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: textColor.withOpacity(0.85),
                      ),
                      tooltip: 'Close',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _GlassField(
                  child: TextField(
                    controller: _titleCtrl,
                    style: TextStyle(color: textColor),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _save(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Task title',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.45)),
                      prefixIcon: Icon(
                        Icons.title_rounded,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _GlassField(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _category,
                      isExpanded: true,
                      dropdownColor: isDark
                          ? const Color(0xFF111827)
                          : Colors.white,
                      iconEnabledColor: textColor.withOpacity(0.8),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      items: _categories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _category = v ?? 'Work'),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(isEdit ? 'Save Changes' : 'Create Task'),
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

class _GlassField extends StatelessWidget {
  final Widget child;
  const _GlassField({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.65);
    final border = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.92);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}
