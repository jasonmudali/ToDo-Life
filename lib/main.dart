import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_tr/pages/todo_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoPage(
        selectedDrawerIndex: 0,
      ),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}
