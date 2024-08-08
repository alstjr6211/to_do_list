import 'package:flutter/material.dart';
import 'package:to_do_list/constant/color.dart';
import 'package:to_do_list/constant/fonts.dart';
import 'package:to_do_list/constant/widget/appBarContainer.dart';

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

  String _selectedDropdown = 'TO DO';

  @override
  Widget build(BuildContext context) {
    final _screenwidth = MediaQuery.of(context).size.width;
    final _screenheight = MediaQuery.of(context).size.height;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundContainerColor,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Appbarcontainer(title: 'TODAY', screenheight: _screenheight,),
                  Container(
                    width: _screenwidth,
                    height: 50,
                    color: white,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 12,),
                        Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: main100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDropdown,
                              onChanged: (String? newDropdown) {
                                setState(() {
                                  _selectedDropdown = newDropdown!;
                                });
                              },
                              items: <String>['TO DO', '완료한 일'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        value == 'To Do'
                                            ? Icons.list_alt
                                            : Icons.check_circle_outline,
                                        color: main800,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              icon : Icon(
                                Icons.menu,
                                color: main800,
                              ),
                              style: textStyleBold().copyWith(color: main800),
                              dropdownColor: main100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],),
                  ),
                  _selectedDropdown== 'TO DO'
                      ? _buildTaskList(_incompTasks)
                      : _buildTaskDone(_compTasks),
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

  Widget _buildTaskDone(List<TaskItem> tasks) {
    final _screenwidth = MediaQuery.of(context).size.width;
    return tasks.isNotEmpty
        ? Column(
      children: [
        ListView.builder(
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
        ),
      ],
    )
        : const SizedBox(height: 0,);
  }
}

//TODO modify UI
//TODO modify Done : no tasks,

