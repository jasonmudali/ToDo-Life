import 'package:flutter/material.dart';
import 'package:project_tr/colors.dart';

// ignore: must_be_immutable
class SCButton extends StatelessWidget {
  final String buttonName;
  VoidCallback onPressed;

  SCButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: tdBlue,
      child: Text(
        buttonName,
        style: TextStyle(color: tdBGColor),
      ),
    );
  }
}
