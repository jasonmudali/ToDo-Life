// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_tr/pages/todo_page.dart';
import 'package:project_tr/widgets/all_to_dos.dart';
import 'package:project_tr/widgets/search_box.dart';
import 'package:project_tr/widgets/todo_tile_for_completed.dart';
import '../colors.dart';

class CompletedPage extends StatefulWidget {
  int selectedDrawerIndex;
  List completedToDo;
  Function(DismissDirection)? deleteTask;

  CompletedPage(
      {super.key,
      required this.selectedDrawerIndex,
      required this.completedToDo,
      required this.deleteTask});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  int _selectedDrawerListIndex = 1;
  final _searchController = TextEditingController();
  List _foundtodo = [];

  //drawer list tapped function
  void drawerTapped(int index) {
    setState(() {
      _selectedDrawerListIndex = index;
      if (index == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ToDoPage(selectedDrawerIndex: index),
        ));
      } else if (index == 1) {
        Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => CompletedPage(
        //     selectedDrawerIndex: index,
        //     completedToDo: [completedToDo],
        //   ),
        // ));
      }
    });
  }

  void filterSearchBox(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(widget.completedToDo);
    } else {
      results = widget.completedToDo
          .where((item) =>
              item.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundtodo = results;
    });
  }

  // void deleteTask(DismissDirection? direction, int index) {
  //   // final id = widget.completedToDo[index].id;
  //   // Uri url = Uri.parse(
  //   //     'https://todoapp-64197-default-rtdb.asia-southeast1.firebasedatabase.app/todoapp/$id.json');
  //   // http.delete(url).then((value) {
  //   setState(() {
  //     widget.completedToDo.removeAt(index);
  //   });
  //   //});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        drawer: Drawer(
          child: Container(
            //color: tdBGColor,
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
                      selectedTileColor:
                          _selectedDrawerListIndex == 0 ? tdBlue : Colors.white,
                    ),
                    ListTile(
                      title: Text("Completed"),
                      onTap: () => drawerTapped(1),
                      tileColor:
                          _selectedDrawerListIndex == 1 ? tdBlue : Colors.white,
                      selectedTileColor:
                          _selectedDrawerListIndex == 1 ? tdBlue : Colors.white,
                    ),
                  ],
                )),
                // Divider(),
                // ListTile(
                //   leading: Icon(Icons.add),
                //   title: Text('Add a new category'),
                //   onTap: createNewCategory,
                // ),
              ],
            ),
          ),
        ),
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
              //ToDoCategory(toDoCategory: 'College'),
              allToDos(
                toDosType: 'Completed ToDos',
              ),
              Expanded(
                child: widget.completedToDo.isEmpty
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
                            : widget.completedToDo.length,
                        itemBuilder: (context, index) {
                          final toDoItem = _searchController.text.isNotEmpty
                              ? _foundtodo[index]
                              : widget.completedToDo[index];
                          return CompletedToDoTile(
                            taskName: toDoItem.name,
                            taskCompleted: toDoItem.taskCompleted,
                            onChanged: (p0) => {},
                            deleteTask: widget.deleteTask,
                          );
                        }),
              )
            ],
          ),
        ));
  }
}
