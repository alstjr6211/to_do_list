import 'package:flutter/material.dart';

import 'package:to_do_list/screens/calendar_screen.dart';
import 'package:to_do_list/screens/home_screen.dart';

import 'data/hive_helper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/task_item.dart';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(TaskItemAdapter());
  await Hive.openBox<TaskItem>(HiveHelper.boxName);


  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'TODOList',
      home: CalendarScreen(),
    );
  }
}