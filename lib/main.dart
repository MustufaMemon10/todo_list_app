import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_list_app/view/screens/home_screen.dart';

import 'models/task.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  tz.initializeTimeZones();
  await _initializeNotifications();
  await Hive.openBox('taskBox');

  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  tz.initializeTimeZones();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    // iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: HomeScreen());
  }
}

Future<void> showTaskCreatedNotification(String taskTitle) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'task_channel_id',
    'Task Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
       android: androidDetails);
  await flutterLocalNotificationsPlugin.show(0, 'Task Created',
      'Your Task $taskTitle has been created.', platformDetails);
}

Future<void> scheduleNotificationForTask(Task task) async {
  final dueDate = task.dueDate;

  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      'Your Task ${task.title} is due!',
      tz.TZDateTime.from(dueDate, tz.local).subtract(const Duration(minutes: 10)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'task_channel_id', 'Task Notification',
              importance: Importance.max, priority: Priority.high)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
