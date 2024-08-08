import 'package:flutter/material.dart';
import 'package:to_do_list/constant/widget/taskDialog.dart';
import 'package:to_do_list/data/task_item.dart';
import 'package:to_do_list/constant/color.dart';

class CalendarPageCard extends StatelessWidget {
  final TaskItem task;
  final Function(bool?) onChanged;
  final Function() onDelete;

  const CalendarPageCard({
    required this.task,
    required this.onChanged,
    required this.onDelete,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),

        child: ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return TaskDialog(task: task);
              },
            );
          },
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              onChanged(value);
              print('checkbox clicked');
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
            '마감일 : ' + '${task.deadLine.toLocal()}'.split(' ')[0],
            style: TextStyle(
              fontFamily: "NanumBarunpen",
              fontWeight: FontWeight.normal,
              color: darkGrey,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                icon: Icon(Icons.delete, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),

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
