// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:project_tr/colors.dart';

// ignore: must_be_immutable
class CompletedToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(DismissDirection)? deleteTask;

  CompletedToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: deleteTask,

      //container for delete
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),

      //each list tile
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 13, bottom: 13),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: ListTile(
          title: Text(
            taskName,
            style: TextStyle(
                decoration: taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          leading: Checkbox(
            value: taskCompleted,
            onChanged: onChanged,
            activeColor: tdBlue,
          ),
          // trailing: IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: editTask,
          // ),
        ),
      ),
    );
  }
}
