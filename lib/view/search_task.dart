import 'package:flutter/material.dart';

import '../controller/task_controller.dart';

class TaskSearch extends SearchDelegate {
  final TaskController taskController;

  TaskSearch(this.taskController);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios,size: 20,),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = taskController.taskList.where((task) =>
    task.title.toLowerCase().contains(query.toLowerCase()) ||
        task.description.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<ListTile>((task) => ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        onTap: () {
          close(context, task);
        },
      ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = taskController.taskList.where((task) =>
    task.title.toLowerCase().contains(query.toLowerCase()) ||
        task.description.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: suggestions
          .map<ListTile>((task) => ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        onTap: () {
          query = task.title;
        },
      ))
          .toList(),
    );
  }
}
