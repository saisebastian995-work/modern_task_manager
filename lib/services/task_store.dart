import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskStore {
  static const boxName = "tasks_box";

  static Future<void> init() async {
    await Hive.openBox<Task>(boxName);
  }

  static Box<Task> get box => Hive.box<Task>(boxName);

  static List<Task> getTasks() {
    return box.values.toList();
  }

  static Future addTask(String title, String category) async {
    final task = Task(
      title: title,
      category: category,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await box.add(task);
  }

  static Future toggle(Task task) async {
    task.completed = !task.completed;
    await task.save();
  }

  static Future delete(Task task) async {
    await task.delete();
  }

  static List<Task> getTasksSorted() {
    final list = box.values.toList();
    list.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  static Future<void> updateTask(
    Task task,
    String title,
    String category,
  ) async {
    task.title = title;
    task.category = category;
    await task.save();
  }
}
