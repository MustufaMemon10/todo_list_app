import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../models/task.dart';

Future<void> showTaskCreatedNotification(String taskTitle) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'task_channel_id',
    'Task Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(0, 'Task Created',
      'Your Task $taskTitle has been created.', platformDetails);
}

Future<void> checkAndRequestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isGranted) {
    log('Permission is already granted, you can schedule the notification');
  } else if (await Permission.scheduleExactAlarm.isDenied) {
    // Request the permission
    final status = await Permission.scheduleExactAlarm.request();
    if (status.isGranted) {
      // Permission granted, you can schedule the notification
    } else {
      // Handle the case when permission is denied (show a message to the user)
    }
  }
}

Future<void> scheduleNotificationForTask(Task task) async {
  final dueDate = task.dueDate;

  await checkAndRequestExactAlarmPermission();
  print('Due Date: $dueDate');

  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      'Your Task ${task.title} is due!',
      tz.TZDateTime.from(dueDate, tz.local)
          .add(const Duration(hours: 5, minutes: 30)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'task_channel_id', 'Task Notification',
              channelDescription: 'Task Scheduled Notifications',
              importance: Importance.max,
              priority: Priority.high)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
  print(
    tz.TZDateTime.from(dueDate, tz.local)
        .add(const Duration(hours: 5, minutes: 30)),
  );
}
