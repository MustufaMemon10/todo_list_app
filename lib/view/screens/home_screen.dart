import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/common/constants/app_colors.dart';
import 'package:todo_list_app/common/widgets/sort_pop_up.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/view/screens/search_task.dart';
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
          PopUpMenu(menuList: [
            PopupMenuItem(
                child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              leading: Icon(
                Icons.priority_high_outlined,
                color: Colors.red.shade500,
              ),
              onTap: () {
                controller.sortTask('priority');
                Get.back();
              },
              title: Text(
                'Priority',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )),
            PopupMenuItem(
                child: ListTile(
              leading: const Icon(
                Icons.tips_and_updates_sharp,
                color: Colors.green,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              onTap: () {
                controller.sortTask('dueDate');
                Get.back();
              },
              title: Text(
                'Due Date',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )),
            PopupMenuItem(
                child: ListTile(
              leading: const Icon(
                Icons.date_range_sharp,
                color: Colors.blueAccent,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              onTap: () {
                controller.sortTask('creationDate');
                Get.back();
              },
              title: Text(
                'Creation Date',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ))
          ])
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: double.infinity,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.02),
                itemCount: controller.taskList.length,
                itemBuilder: (context, index) {
                  final task = controller.taskList[index];
                  return Slidable(
                    endActionPane:  ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => controller.removeTask(index) ,
                          backgroundColor: Colors.red,
                          label: 'Delete',
                          icon: Icons.delete_outline,
                        )
                      ],
                    ),
                    child: ListTile(
                      splashColor: Colors.yellow,
                      shape: const StadiumBorder(),
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
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: height * 0.04,
                            width: width * 0.04,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.priority == 3
                                  ? Colors.green
                                  : task.priority == 2
                                      ? Colors.orange
                                      : Colors.grey,
                            ),
                          ),
                          IconButton(
                              onPressed: () => controller.taskCompleted(index),
                              icon: Icon(
                                task.isCompleted
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: AppColors.dark,
                              )),
                        ],
                      ),
                      // onTap: ,
                    ),
                  );
                }),
          ),
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
