import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;


import '../main.dart';
import '../models/task.dart';


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
  await checkAndRequestExactAlarmPermission();
  tz.initializeTimeZones();

  final dueDate = task.dueDate.toUtc();
  log('Original Due Date: $dueDate');

  final location = tz.getLocation('Asia/Kolkata');

  final scheduledDate = tz.TZDateTime.from(dueDate, tz.local);
  log('Duedate utc : $dueDate');
  log('Scheduled Date (IST): $scheduledDate');

  if (scheduledDate.isBefore(tz.TZDateTime.now(location))) {
    log('Scheduled date is in the past. Notification not scheduled.');
    return;
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Task Reminder',
    'Your Task ${task.title} is due!',
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id2',
        'Task Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
  );

  log('Notification scheduled for: $scheduledDate');
}
