import 'package:flutter/material.dart';


import 'package:intl/date_symbol_data_local.dart';
import 'package:to_do_list/screens/calendar_screen.dart';
import 'package:to_do_list/screens/home_screen.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'data/hive_helper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/task_item.dart';
import 'api/notification.dart';

void main() async {

  await initializeDateFormatting();


  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskItemAdapter());
  await Hive.openBox<TaskItem>(HiveHelper.boxName);

  await FlutterLocalNotification.init();
  await FlutterLocalNotification.requestNotificationPermissions();

  tz.initializeTimeZones();
  final hiveHelper = HiveHelper();
  await hiveHelper.init();

  if (hiveHelper.getNotificationStatus()) {
    final tasks = hiveHelper.getAllTasks();
    for (final task in tasks) {
      if (!task.isCompleted && task.deadLine.isAfter(DateTime.now())) {
        FlutterLocalNotification.scheduleNotification(
          task.key as int,
          'Task Reminder',
          'Today is the deadline for your task: ${task.taskTitle}',
          DateTime(task.deadLine.year, task.deadLine.month, task.deadLine.day, 19, 0),
        );
      }
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'TODOList',
      home: HomeScreen(),
    );
  }
}
