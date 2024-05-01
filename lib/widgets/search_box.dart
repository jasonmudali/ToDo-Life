// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_tr/colors.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final filterFunction;

  SearchBox({
    super.key,
    required this.controller,
    required this.filterFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 45,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          filterFunction(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: tdBlack,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdBlack),
        ),
      ),
    );
  }
}
