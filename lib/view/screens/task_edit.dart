import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todo_list_app/common/constants/app_colors.dart';
import 'package:todo_list_app/common/widgets/custom_text_field.dart';
import 'package:todo_list_app/models/task.dart';

import '../../controller/task_controller.dart';

class TaskEdit extends StatefulWidget {
  const TaskEdit(
      {super.key,
      required this.title,
      required this.description,
      required this.dueDate,
      required this.priority,
      required this.index,
      required this.creationDate});

  final String title;
  final String description;
  final DateTime dueDate;
  final int priority;
  final DateTime creationDate;
  final int index;

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final TaskController taskController = Get.find();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final priorityController = TextEditingController();

  final dueDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      titleController.text = widget.title;
      descriptionController.text = widget.description;
      priorityController.text = widget.priority.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat('d MMMM HH:mm').format(widget.creationDate);
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(widget.dueDate);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Task',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close_outlined,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                final newTask = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    priority: int.parse(priorityController.text),
                    creationDate: widget.creationDate,
                    dueDate: DateTime.parse(dueDateController.text));
                taskController.updateTask(widget.index, newTask);
                Get.back();
              },
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              )),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
            Text(
              formattedTime,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.grey.shade600),
            ),
            Divider(
              height: Get.height * 0.03,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            TextField(
              controller: descriptionController,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 10,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            CustomTextField(
                keyBoardType: TextInputType.number,
                borderColor: Colors.black12,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[1-3]')),
                  LengthLimitingTextInputFormatter(1)
                ],
                controller: priorityController,
                hintText: 'Priority(1-3)'),
            SizedBox(
              height: Get.height * 0.02,
            ),
            CustomTextField(
              controller: dueDateController,
              hintText: widget.dueDate.toString(),
              readOnly: true,
              keyBoardType: TextInputType.datetime,
              borderColor: Colors.black12,
              onTap: () async {
                DateTime? pickedDateAndTime = await showOmniDateTimePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  is24HourMode: true,
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
          ],
        ),
      ),
    );
  }
}
