import 'package:flutter/material.dart';
import 'package:to_do_list/data/task_item.dart';

class TaskDialog extends StatelessWidget {
  final TaskItem task;

  const TaskDialog({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(task.taskTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('시작일: ${task.startDate.toLocal()}'),
          SizedBox(height: 8.0),
          Text('마감일: ${task.deadLine.toLocal()}'),
          SizedBox(height: 8.0),
          Text('완료 상태: ${task.isCompleted ? "완료됨" : "미완료"}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}
