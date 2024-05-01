// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_tr/colors.dart';
import 'package:project_tr/widgets/save_cancel_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: tdBGColor,
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hintText,
              ),
            ),

            //buttons: save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                SCButton(
                  buttonName: 'Save',
                  onPressed: onSave,
                ),

                SizedBox(
                  width: 4,
                ),

                //cancel button
                SCButton(
                  buttonName: 'Cancel',
                  onPressed: onCancel,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
