import 'package:hive/hive.dart';
part 'task_item.g.dart';

@HiveType(typeId: 0)
class TaskItem extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String taskTitle;
  @HiveField(2)
  DateTime startDate;
  @HiveField(3)
  DateTime deadLine;
  @HiveField(4)
  int colorCategory;
  @HiveField(5)
  bool isCompleted;

  TaskItem(
    this.id,
    this.taskTitle,
    this.startDate,
    this.deadLine,
    this.colorCategory, {
      this.isCompleted = false,
      });

}