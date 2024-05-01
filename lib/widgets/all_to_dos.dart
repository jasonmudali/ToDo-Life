import 'package:flutter/material.dart';

class allToDos extends StatelessWidget {
  final String toDosType;
  allToDos({super.key, required this.toDosType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
        top: 30,
        bottom: 20,
      ),
      child: Text(
        toDosType,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
