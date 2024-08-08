import 'package:flutter/material.dart';
import 'package:to_do_list/constant/fonts.dart';
import 'package:to_do_list/data/task_item.dart';
import 'package:to_do_list/constant/color.dart';

class HomePageCard extends StatelessWidget {
  final TaskItem task;
  final Function(bool?) onChanged;
  final Function() onDelete;

  const HomePageCard({
    required this.task,
    required this.onChanged,
    required this.onDelete,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: white,
        ),
        child:  ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              onChanged(value);
            },
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return main400;
              }
              return null;
            }),
            side: BorderSide(
                color: grey
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          title: Text(
            task.taskTitle,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              fontFamily: "NanumBarunpen",
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          subtitle: Text(
            '${task.deadLine.toLocal()}'.split(' ')[0],
            style: textStyleNormal(),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.8),
          visualDensity: VisualDensity.compact,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: checkColor(task.colorCategory),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                color: grey,
              ),
            ],
          ),
        ),
      )
    );
  }

  static Color checkColor(int colorCategory) {
    switch (colorCategory) {
      case 0:
        return firstCategoryColor;
      case 1:
        return secondCategoryColor;
      case 2:
        return thirdCategoryColor;
      case 3:
        return fourthCategoryColor;
      case 4:
        return fivethCategoryColor;
      default:
        return firstCategoryColor;
    }
  }
}
