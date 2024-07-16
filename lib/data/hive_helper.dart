import 'package:hive/hive.dart';
import 'task_item.dart';

class HiveHelper {
  static const String boxName = 'Task_Box';


  static final HiveHelper _singleton = HiveHelper._internal();
  factory HiveHelper() {
    return _singleton;
  }
  HiveHelper._internal();


  Box<TaskItem>? taskBox;
  Future<void> init() async {
    taskBox = await Hive.openBox(boxName);
  }

  Future<void> addTask(TaskItem task) async {
    final box = Hive.box<TaskItem>(boxName);
    await box.add(task);
  }

  List<TaskItem> getAllTasks() {
    final box = Hive.box<TaskItem>(boxName);
    return box.values.toList();
  }

  TaskItem? getTask(int key) {
    final box = Hive.box<TaskItem>(boxName);
    return box.get(key);
  }

  Future<void> updateTask(int key, TaskItem updatedTask) async {
    final box = Hive.box<TaskItem>(boxName);
    await box.put(key, updatedTask);
  }

  Future<void> deleteTask(int key) async {
    final box = Hive.box<TaskItem>(boxName);
    await box.delete(key);
  }
}


