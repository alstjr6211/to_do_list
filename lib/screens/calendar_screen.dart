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

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  final HiveHelper _hiveHelper = HiveHelper();

  DateTime _selectedDate = DateTime.now();



  List<TaskItem> _taskList = [];


  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  Future <void> _loadTasks() async {
    final tasks = await _hiveHelper.getAllTasks();
    setState(() {
      _taskList = tasks;
    });
  }

  void _updateTaskCompletion(TaskItem task, bool? isCompleted) async {
    task.isCompleted = isCompleted ?? false;
    await _hiveHelper.updateTask(task.key as int, task);
    setState(() {
      _taskList.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return 1;
        if (!a.isCompleted && b.isCompleted) return -1;
        return 0;
      });
    });
  }

  void _deleteTask(TaskItem task) async {
    await _hiveHelper.deleteTask(task.key as int);
    _loadTasks();
  }


  @override
  Widget build(BuildContext context) {


    final _screenwidth = MediaQuery.of(context).size.width;
    final _screenheight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Appbarcontainer(title: '일정', screenheight: _screenheight,),
            Container(
              width: _screenwidth,
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarStyle: calendarStyle(),
                  headerStyle: headerStyle(),
                  daysOfWeekStyle: daysOfWeekStyle(),
                  //TODO 언어설정 변경 locale: 'Ko_머시기', intl패키지 추가 필요
                ),
              ),
            ),
            const SizedBox(height: 16,),
            Container(color: backgroundColor,
            child: Row (
              children: [
                SizedBox(width: _screenwidth * 0.16,),
                Text(
                  '일정',
                  style: TextStyle(),
                ),
              ],
            ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: _taskList.length,
                  itemBuilder: (context, index) {
                    final task = _taskList[index];
                    if (task.startDate.isBefore(_selectedDate.add(Duration(days: 1))) &&
                        task.deadLine.isAfter(_selectedDate.subtract(Duration(days: 1)))) {
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
        bottomNavigationBar: ToDoListBottomBar(selectedPageIndex: 1,),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showAddTaskDialog(context);
            });
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent,
          shape: CircleBorder(),
          child: const Icon(Icons.add),
          //TODO 일정추가 아이콘 추가 저작권 확인해라...

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
        return Icon(
          Icons.check,
        );
      } else {
        return SizedBox(height: 0, width: 0,);
      }

    }


    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('일정 추가하기'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      _title = value;
                    },
                    decoration: InputDecoration(hintText: '제목'),
                  ),
                  //TODO 시작일 설정 가능, default값 : 오늘
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
                  //choose colorCategory
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
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () async {

                    final task = TaskItem(
                      null,
                      _title,
                      DateTime.now(),
                      _deadlineDate,
                      _selectedColor,
                    );

                    await _hiveHelper.addTask(task);

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