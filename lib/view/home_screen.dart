import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/common/constants/app_colors.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/view/search_task.dart';
import 'package:todo_list_app/view/widgets/task_form.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'TodoList App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: TaskSearch(controller));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sort))
        ],
      ),
      body: Obx(
        () => SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: double.infinity,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.02),
              itemCount: controller.taskList.length,
              itemBuilder: (context, index) {
                final task = controller.taskList[index];
                return ListTile(
                  splashColor: Colors.yellow,
                  shape: const CircleBorder(),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    task.description,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () => controller.taskCompleted(index),
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: AppColors.dark,
                      )),
                  onLongPress: () {
                    controller.removeTask(index);
                  },
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: AppColors.secondary,
        shape: const CircleBorder(),
        onPressed: () => Get.to(TaskForm(), transition: Transition.rightToLeft),
        child: const Icon(Icons.add),
      ),
    );
  }
}
