import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  int createdAt;

  Task({
    required this.title,
    required this.category,
    this.completed = false,
    required this.createdAt,
  });
}
