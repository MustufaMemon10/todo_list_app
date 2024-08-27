
class Task{
  String title;
  String description;
  int priority;
  DateTime dueDate;
  bool isCompleted;


  
  Task({required this.title, required this.description, required this.priority, required this.dueDate,  this.isCompleted = false});
}