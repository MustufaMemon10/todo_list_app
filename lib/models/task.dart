
import 'package:hive/hive.dart';


part 'task.g.dart';

@HiveType(typeId: 0)
class Task{

  @HiveField(0)
  String title;


  @HiveField(1)
  String description;

  @HiveField(2)
  int priority;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  DateTime creationDate;

  @HiveField(5)
  bool isCompleted;




  
  Task({required this.title, required this.description, required this.priority, required this.dueDate, required this.creationDate, this.isCompleted = false});
}