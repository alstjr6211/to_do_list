import 'package:hive/hive.dart';
import 'task_item.dart';

class HiveHelper {
  static const String boxName = 'Task_Box';
  static const String notificationKey = 'Notification_Status';

  static final HiveHelper _singleton = HiveHelper._internal();
  factory HiveHelper() {
    return _singleton;
  }
  HiveHelper._internal();

  Box<TaskItem>? taskBox;
  Box? statusBox;

  Future<void> init() async {
    taskBox = await Hive.openBox(boxName);
    statusBox = await Hive.openBox('Status_Box');
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

  // 알림 상태 저장
  Future<void> saveNotificationStatus(bool status) async {
    final box = Hive.box('Status_Box');
    await box.put(notificationKey, status);
  }

  // 알림 상태 복구
  bool getNotificationStatus() {
    final box = Hive.box('Status_Box');
    return box.get(notificationKey, defaultValue: true);
  }
}
