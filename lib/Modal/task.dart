import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool isDone;

  @HiveField(2)
  late DateTime startDate;

  @HiveField(3)
  late DateTime endDate;

  @HiveField(4)
  late bool isDeleted;

  @HiveField(5)
  late DateTime? deletedAt; // New field to mark when a task was deleted

  Task({
    required this.title,
    this.isDone = false,
    required this.startDate,
    required this.endDate,
    this.isDeleted = false,
    this.deletedAt, // Default to null
  });
}
