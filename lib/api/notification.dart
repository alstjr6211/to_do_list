import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationPlugin.initialize(initializationSettings);

    // 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationPlugin.show(0, title, body, notificationDetails);
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
