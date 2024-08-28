import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/task.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
FlutterLocalNotificationsPlugin();


// initialization of Notifications
void initializationNotifications() {
  final InitializationSettings initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    // iOS: IOSFlutterLocalNotificationsPlugin()
  );
  flutterLocalNotificationPlugin.initialize(initializationSettings);
}
//
// Future<void> scheduleNotification(Task task) async {
//   await flutterLocalNotificationPlugin.zonedSchedule(0, 'Task Reminder',
//       'Your Task ${task.title} is due!',
//       tz.TzDateTime.now(tz.local).add(const Duration(minutes: 1)), NotificationDetails(
//         android: AndroidNotificationDetails(
//           ''
//         ),
//       )
//       , uiLocalNotificationDateInterpretation:
//       uiLocalNotificationDateInterpretation)
// }