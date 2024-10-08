import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todo_list_app/main.dart';
import 'package:todo_list_app/services/notification_service.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  final taskBox = Hive.box('taskBox');

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  void loadTasks() {
    var allTask = taskBox.values.toList().cast<Task>();
    taskList.assignAll(allTask);
  }

  // To Add task
  void addTasks(Task task) {
    taskBox.add(task);
    taskList.add(task);
    showTaskCreatedNotification(task.title);
    scheduleNotificationForTask(task);
  }

  // To Update task
  void updateTask(int index, Task task) {
    taskBox.putAt(index, task);
    taskList[index] = task;
    scheduleNotificationForTask(task);
  }
  void updateCompleteTask(int index, Task task) {
    taskBox.putAt(index, task);
    taskList[index] = task;
  }

  // To Delete task
  void removeTask(int index) {
    taskBox.deleteAt(index);
    taskList.removeAt(index);
  }

  //Toggle task Completed
  void taskCompleted(int index) {
    var task = taskList[index];
    task.isCompleted = !task.isCompleted;
    updateCompleteTask(index, task);
  }

  void sortTask(String criteria) {
    if (criteria == 'priority') {
      taskList.sort((a, b) => b.priority.compareTo(a.priority));
    } else if (criteria == 'dueDate') {
      taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (criteria == 'creationDate') {
      taskList.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    }
  }
}
