// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, must_be_immutable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_tr/colors.dart';
import 'package:project_tr/pages/completed.dart';
import 'package:project_tr/widgets/all_to_dos.dart';
import 'package:project_tr/widgets/dialog_box.dart';
import 'package:project_tr/widgets/search_box.dart';
import 'package:project_tr/widgets/todo_tile.dart';
import '../models/todo_item.dart';
import 'package:http/http.dart' as http;

class ToDoPage extends StatefulWidget {
  int selectedDrawerIndex;
  ToDoPage({super.key, required this.selectedDrawerIndex});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  // text controller
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  List _foundtodo = [];
  String? _error;
  bool _isLoading = true;

  //list of todo tasks
  List<ToDoItem> toDoList = [];

  //list of completed todo tasks
  List<ToDoItem> completedToDoList = [];

  @override
  void initState() {
    //_foundtodo = toDoList;
    super.initState();
    loadItems();
    loadCompletedItems();
  }

  void loadItems() async {
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp.json');
    try {
      var hasilGetData = await http.get(url);
      final Map<String, dynamic> dataResponse = json.decode(hasilGetData.body);
      dataResponse.forEach((key, value) {
        toDoList.add(
          ToDoItem(
            id: key,
            name: value["name"],
            taskCompleted: value["taskCompleted"],
          ),
        );
      });
      //print("DATA BERHASIL DIMASUKKAN");
      setState(() {
        _foundtodo = toDoList;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

  //search box functionality
  void filterSearchBox(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(toDoList);
    } else {
      results = toDoList
          .where((item) =>
              item.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundtodo = results;
    });
  }

  void loadCompletedItems() async {
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/completedtodoapp.json');
    try {
      var hasilGetData = await http.get(url);
      final Map<String, dynamic> dataResponse = json.decode(hasilGetData.body);
      completedToDoList.clear();
      dataResponse.forEach((key, value) {
        completedToDoList.add(
          ToDoItem(
            id: key,
            name: value["name"],
            taskCompleted: value["taskCompleted"],
          ),
        );
        print(key);
      });
      print("DATA BERHASIL DIMASUKKAN");
      setState(() {
        _foundtodo = completedToDoList;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

  //function for deleting the task from todolist if checbox tapped
  void deleteTaskWithCheckBox(int index) async {
    final id = toDoList[index].id;
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp/$id.json');
    await http.delete(url);
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void saveNewCompletedTask(String id, String name) async {
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/completedtodoapp.json');
    await http.post(
      url,
      body: json.encode(
        {
          "name": name,
          "taskCompleted": true,
        },
      ),
    );

    setState(() {
      print(toDoList);
      completedToDoList.add(
        ToDoItem(
          id: id,
          name: name,
          taskCompleted: true,
        ),
      );
    });
  }

  void deleteCompletedTask(DismissDirection? direction, int index) async {
    final id = completedToDoList[index].id;
    print('Deleting item with ID: $id at index: $index');
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/completedtodoapp/$id.json');
    await http.delete(url);

    print(completedToDoList[index].name);
    completedToDoList.removeAt(index);
    //_foundtodo.removeAt(index);
  }

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) async {
    final id = toDoList[index].id;
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp/$id.json');
    await http.patch(
      url,
      body: json.encode(
        {
          "taskCompleted": true //!toDoList[index].taskCompleted,
        },
      ),
    );

    setState(() {
      saveNewCompletedTask(id, toDoList[index].name);
      deleteTaskWithCheckBox(index);

      //toDoList[index].taskCompleted = !toDoList[index].taskCompleted;
    });
  }

  // void createNewCategory() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return DialogBox(
  //           controller: _controller,
  //           hintText: "Add a new category",
  //           onSave: saveNewCategory,
  //           onCancel: () => Navigator.pop(context));
  //     },
  //   );
  // }

  // void saveNewCategory() {
  //   setState(() {
  //     categoryList.add([_controller.text]);
  //     _controller.clear();
  //   });
  //   Navigator.pop(context);
  // }

  void drawerTapped(int index) {
    setState(() {
      _selectedDrawerListIndex = index;
      if (index == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ToDoPage(selectedDrawerIndex: index),
        ));
      } else if (index == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CompletedPage(
            selectedDrawerIndex: index,
            completedToDo: completedToDoList,
            deleteTask: (direction) => deleteCompletedTask(direction, index),
          ),
        ));
      }
    });
  }

  //save new task
  void saveNewTask() async {
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp.json');
    var response = await http.post(
      url,
      body: json.encode(
        {
          "name": _controller.text,
          "taskCompleted": false,
        },
      ),
    );

    setState(() {
      toDoList.add(
        ToDoItem(
          id: json.decode(response.body)["name"].toString(),
          name: _controller.text,
          taskCompleted: false,
        ),
      );
      _controller.clear();
    });
    Navigator.pop(context);
  }

  //create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          hintText: "Add a new task",
          onSave: saveNewTask,
          onCancel: () {
            Navigator.pop(context);
            _controller.clear();
          },
        );
      },
    );
  }

  void saveEditTask(int index, String editTask) async {
    final id = toDoList[index].id;
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp/$id.json');
    await http.patch(
      url,
      body: json.encode(
        {
          "name": editTask,
        },
      ),
    );

    setState(() {
      toDoList[index].name = editTask;
      _controller.clear();
    });
    Navigator.pop(context);
  }

  void editTask(index) {
    final _controllerEdit = TextEditingController(text: toDoList[index].name);
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controllerEdit,
          hintText: toDoList[index].name,
          onSave: () => saveEditTask(index, _controllerEdit.text),
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  //delete a task
  void deleteTask(DismissDirection? direction, int index) async {
    final id = toDoList[index].id;
    Uri url = Uri.parse(
        'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp/$id.json');
    await http.delete(url);
    setState(() {
      toDoList.removeAt(index);
    });
  }

  int _selectedDrawerListIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            'Hello, Jason',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        backgroundColor: tdBGColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(
          Icons.add,
          color: tdBGColor,
        ),
        backgroundColor: tdBlue,
      ),

      drawer: Drawer(
        child: Container(
          //color: Colors.white,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: tdBlue,
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  ListTile(
                    title: Text("All to do"),
                    onTap: () => drawerTapped(0),
                    tileColor:
                        _selectedDrawerListIndex == 0 ? tdBlue : Colors.white,
                    // selectedTileColor:
                    //     _selectedDrawerListIndex == 0 ? tdBlue : Colors.white,
                  ),
                  ListTile(
                    title: Text("Completed"),
                    onTap: () => drawerTapped(1),
                    tileColor:
                        _selectedDrawerListIndex == 1 ? tdBlue : Colors.white,
                    // selectedTileColor:
                    //     _selectedDrawerListIndex == 1 ? tdBlue : Colors.white,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),

      //bagian body
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: tdBGColor,
        ),
        child: Column(
          children: [
            SearchBox(
              controller: _searchController,
              filterFunction: filterSearchBox,
            ),
            allToDos(
              toDosType: 'All ToDos',
            ),
            Expanded(
              child: toDoList.isEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Tasks Yet',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchController.text.isNotEmpty
                          ? _foundtodo.length
                          : toDoList.length,
                      itemBuilder: (context, index) {
                        final toDoItem = _searchController.text.isNotEmpty
                            ? _foundtodo[index]
                            : toDoList[index];
                        return ToDoTile(
                          taskName: toDoItem.name,
                          taskCompleted: toDoItem.taskCompleted,
                          onChanged: (value) => checkBoxChanged(value, index),
                          deleteTask: (direction) =>
                              deleteTask(direction, index),
                          editTask: () => editTask(index),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
