import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:to_do_list/constant/bottomNavigationBar.dart';
import 'package:to_do_list/constant/color.dart';

import '../constant/widget/appBarContainer.dart';
import '../constant/widget/calendarPageCard.dart';
import '../constant/widget/calendarStyle.dart';

import '../data/hive_helper.dart';
import '../data/task_item.dart';

import 'package:to_do_list/api/notification.dart';



class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  CalendarFormat format = CalendarFormat.month;


  final HiveHelper _hiveHelper = HiveHelper();
  DateTime _selectedDate = DateTime.now();
  List<TaskItem> _taskList = [];
  Map<DateTime, List<TaskItem>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _hiveHelper.getAllTasks();
    setState(() {
      _taskList = tasks;
      _taskList.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return 1;
        if (!a.isCompleted && b.isCompleted) return -1;
        return 0;
      });

      _events.clear();
      for (final task in tasks) {
        final eventDate = DateTime(task.deadLine.year, task.deadLine.month, task.deadLine.day);
        print("Mapping task '${task.taskTitle}' to $eventDate");
        if (_events[eventDate] == null) {
          _events[eventDate] = [];
        }
        _events[eventDate]?.add(task);
      }
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

  void _scheduleTaskNotifications(TaskItem task) {
    if (!task.isCompleted && task.deadLine.isAfter(DateTime.now())) {
      FlutterLocalNotification.scheduleNotification(
        task.key as int,
        'Task Reminder',
        'Today is the deadline for your task: ${task.taskTitle}',
        DateTime(task.deadLine.year, task.deadLine.month, task.deadLine.day, 19, 0),
      );
    }
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
          body: Column(
            children: [
              Appbarcontainer(title: '일정', screenheight: _screenheight),
              Container(
                width: _screenwidth,
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: TableCalendar(
                    //day, locale etc
                    locale: 'ko_KR',
                    focusedDay: _selectedDate,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    },
                    //calendar style
                    calendarStyle: calendarStyle(),
                    headerStyle: headerStyle(),
                    daysOfWeekStyle: daysOfWeekStyle(),
                    eventLoader: (day) {
                      final date = DateTime(day.year, day.month, day.day);
                      final events = _events[date] ?? [];
                      print("Load $date: ${events.length} events");
                      return events;
                    },

                    //calendar format
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat format) {
                      setState(() {
                        this.format = format;
                      });
                    },

                    //marker
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) return SizedBox();
                        print("Event marker build for $date with ${events.length} events");
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: purple400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: backgroundContainerColor,
                  child: ListView.builder(
                    itemCount: _taskList.length,
                    itemBuilder: (context, index) {
                      final task = _taskList[index];
                      if (task.startDate.isBefore(_selectedDate.add(Duration(days: 1))) &&
                          task.deadLine.isAfter(_selectedDate.subtract(Duration(days: 1)))) {
                        _scheduleTaskNotifications(task);
                        return CalendarPageCard(
                          task: task,
                          onChanged: (isCompleted) {
                            setState(() {
                              _updateTaskCompletion(task, isCompleted);
                            });
                          },
                          onDelete: () {
                            _deleteTask(task);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ToDoListBottomBar(selectedPageIndex: 1),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTaskDialog(context);
            },
            foregroundColor: white,
            backgroundColor: purple600,
            shape: CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String _title = '';
    DateTime _deadlineDate = DateTime.now();
    int _selectedColor = 0;

    Widget selectedIcon(int i) {
      if (_selectedColor == i) {
        return Icon(Icons.check);
      } else {
        return SizedBox(height: 0, width: 0);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('일정 추가하기'),
              content: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          _title = value;
                        },
                        decoration: InputDecoration(hintText: '제목'),
                      ),
                      Row(
                        children: [
                          Text('마감일:'),
                          TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _deadlineDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _deadlineDate = pickedDate;
                                });
                              }
                            },
                            child: Text('${_deadlineDate.toLocal()}'.split(' ')[0]),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = 0;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: firstCategoryColor,
                              child: selectedIcon(0),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = 1;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: secondCategoryColor,
                              child: selectedIcon(1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = 2;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: thirdCategoryColor,
                              child: selectedIcon(2),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = 3;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: fourthCategoryColor,
                              child: selectedIcon(3),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = 4;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: fivethCategoryColor,
                              child: selectedIcon(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    final newTask = TaskItem(
                      null,
                      _title,
                      DateTime.now(),
                      _deadlineDate,
                      _selectedColor,
                    );

                    await _hiveHelper.addTask(newTask);
                    _scheduleTaskNotifications(newTask);

                    print('일정 추가 버튼 클릭됨');
                    _loadTasks();

                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: '일정이 추가되었습니다.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Text('추가'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
//TODO modify _showdialog : error, UI, selected days

//TODO modify marker : only deadline,

