import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';
import 'package:to_do_list/constant/widget/appBarContainer.dart';
import 'package:to_do_list/constant/widget/widget.dart';

import '../constant/bottomNavigationBar.dart';
import 'package:to_do_list/data/hive_helper.dart';
import 'package:to_do_list/data/task_item.dart';

import '../constant/widget/homePageCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HiveHelper _hiveHelper = HiveHelper();

  List<TaskItem> _tasks = [];
  List<TaskItem> _compTasks = [];
  List<TaskItem> _incompTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _hiveHelper.getAllTasks();
    final today = DateTime.now();

    setState(() {
      _tasks = tasks;
      _compTasks = _tasks.where((task) {
        return task.startDate.isBefore(today.add(Duration(days: 1))) &&
            task.deadLine.isAfter(today.subtract(Duration(days: 1))) &&
            task.isCompleted;
      }).toList();

      _incompTasks = _tasks.where((task) {
        return task.startDate.isBefore(today.add(Duration(days: 1))) &&
            task.deadLine.isAfter(today.subtract(Duration(days: 1))) &&
            !task.isCompleted;
      }).toList();
    });
  }

  void _updateTaskCompletion(TaskItem task, bool? isCompleted) async {
    task.isCompleted = isCompleted ?? false;
    await _hiveHelper.updateTask(task.key as int, task);
    _loadTasks();
  }

  void _deleteTask(TaskItem task) async {
    await _hiveHelper.deleteTask(task.key as int);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final _screenwidth = MediaQuery.of(context).size.width;
    final _screenheight = MediaQuery.of(context).size.height;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Appbarcontainer(title: 'TODAY', screenheight: _screenheight,),
                  textDividor('TO-DO-Today', _screenwidth),
                  _buildTaskList(_incompTasks),
                  const SizedBox(height: 16,),
                  textDividor('Done', _screenwidth),
                  _buildTaskList(_compTasks),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ToDoListBottomBar(selectedPageIndex: 0,),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskItem> tasks) {
    return tasks.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return HomePageCard(
          task: task,
          onChanged: (isCompleted) {
            _updateTaskCompletion(task, isCompleted);
          },
          onDelete: () {
            _deleteTask(task);
          },
        );
      },
    )
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '할 일이 없습니다.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
