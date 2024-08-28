import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todo_list_app/common/constants/app_colors.dart';

import '../../common/widgets/custom_text_field.dart';
import '../../controller/task_controller.dart';
import '../../models/task.dart';

class TaskForm extends StatelessWidget {
  TaskForm({super.key});

  final TaskController taskController = Get.find();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();
  final dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.height * 0.04),
          child: Column(
            children: [
              CustomTextField(
                  keyBoardType: TextInputType.text,
                  controller: titleController, hintText: 'Title'),
              SizedBox(
                height: Get.height * 0.02,
              ),
              CustomTextField(
                keyBoardType: TextInputType.text,
                controller: descriptionController,
                hintText: 'Description',
                maxLines: 5,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              CustomTextField(
                keyBoardType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[1-3]')),
                      LengthLimitingTextInputFormatter(1)
                    ],
                  controller: priorityController, hintText: 'Priority(1-3)'),
              SizedBox(
                height: Get.height * 0.02,
              ),
              CustomTextField(
                keyBoardType: TextInputType.datetime,
                readOnly: true,
                controller: dueDateController,
                hintText: 'Complete Around?',
                onTap: () async {
                  DateTime? pickedDateAndTime = await showOmniDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    borderRadius: BorderRadius.circular(15),
                    transitionBuilder: (context, anim1, anim2, child) {
                      return FadeTransition(
                        opacity: anim1.drive(
                          Tween(
                            begin: 0,
                            end: 1,
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  );
                  if (pickedDateAndTime != null) {
                    dueDateController.text =
                        pickedDateAndTime.toString();
                  }
                },
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              SizedBox(
                width: double.infinity,
                height: Get.height * 0.05,
                child: ElevatedButton(
                    onPressed: () {
                      final newTask = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        priority: int.parse(priorityController.text),
                        creationDate: DateTime.now(),
                        dueDate: DateTime.parse(dueDateController.text)
                      );
                      taskController.addTasks(newTask);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary),
                    child: Text(
                      'Add Task',
                      style: Theme.of(context).textTheme.labelLarge,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
