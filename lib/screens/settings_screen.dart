import 'package:flutter/material.dart';
import 'package:to_do_list/application_version.dart';
import 'package:to_do_list/constant/bottomNavigationBar.dart';
import 'package:to_do_list/constant/color.dart';
import 'package:to_do_list/constant/fonts.dart';
import 'package:to_do_list/constant/widget/settingsLine.dart';

import '../api/notification.dart';
import '../data/hive_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _notificationsEnabled = false;
  final HiveHelper _hiveHelper = HiveHelper();

  @override
  void initState() {
    _checkNotificationPermissions();
    super.initState();
    _checkNotificationPermissions();
  }

  Future<void> _checkNotificationPermissions() async {
    final status = await FlutterLocalNotification.checkNotificationPermissions();
    setState(() {
      _notificationsEnabled = status;
    });
  }

  Future<void> _requestNotificationPermissions() async {
    await FlutterLocalNotification.requestNotificationPermissions();
    _checkNotificationPermissions();
  }

  void _toggleNotificationPermissions(bool value) async {
    if (value) {
      await _requestNotificationPermissions();
      _restoreScheduledNotifications();
      await _hiveHelper.saveNotificationStatus(true);
    } else {
      setState(() {
        _notificationsEnabled = false;
      });
      await _hiveHelper.saveNotificationStatus(false);
      _pauseScheduledNotifications();
    }
  }

// 알림 중지
  void _pauseScheduledNotifications() async {
    await FlutterLocalNotification.cancelAllNotifications();
  }

// 알림 복구
  void _restoreScheduledNotifications() async {
    final tasks = await _hiveHelper.getAllTasks();
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
    setState(() {
      _notificationsEnabled = true;
    });
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
          body: Container(
            width: _screenwidth,
            height: _screenheight,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  Settingsline(menuText: '알림', screenwidth: _screenwidth,),
                  SwitchListTile(
                    title: settingsText('TO-DO-List 알림설정', true),
                    subtitle: Text(_notificationsEnabled ? '알림 on' : '알림 off'),
                    secondary: const Icon(Icons.notifications),
                    value: _notificationsEnabled,
                    onChanged: _toggleNotificationPermissions,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  Settingsline(menuText: '잠금화면', screenwidth: _screenwidth,),
                  //SwitchListTile(value: value, onChanged: onChanged)
                  Settingsline(menuText: '앱 정보', screenwidth: _screenwidth,),
                  ListTile(
                    title: settingsText('어플리케이션 버전 : $application_version', true),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  const Divider(color: grey, thickness: 0.6,),
                  ListTile(
                    title: settingsText('이용약관', true),
                    onTap: (){
                      //TODO 이용약관 노션 링크로 이동
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  const Divider(color: grey, thickness: 0.6,),
                  ListTile(
                    title: settingsText('개인정보 처리방침', true),
                    onTap: (){
                      //TODO 개인정보처리방침 페이지 이동
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  const Divider(color: grey, thickness: 0.6,),
                  ListTile(
                    title: settingsText('사용한 라이센스', true),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'TO-DO-IT',
                        applicationVersion: '$application_version',
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ToDoListBottomBar(selectedPageIndex: 2,),
        ),
      ),
    );
  }
}


//TODO modify notification error

//TODO make darkMode change