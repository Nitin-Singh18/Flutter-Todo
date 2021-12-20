// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo_app/Models/dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbhelper = Databasehelper.instance;

  final TextEditingController intask = TextEditingController();

  String errtext = "";
  bool validated = true;

  String todoedited = "";
  var myitems = [];
  List<Widget> children = <Widget>[];

  void addToDo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(
      () {
        validated = true;
        errtext = "";
      },
    );
  }

  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach(
      (row) {
        myitems.add(row.toString());
        children.add(
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              child: ListTile(
                title: Text(row['todo']),
                onLongPress: () {
                  dbhelper.deletedata(row['id']);
                  setState(() {});
                },
              ),
            ),
          ),
        );
      },
    );
    return Future.value(true);
  }

  void showAlertDialog() {
    intask.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: intask,
                    onChanged: (_val) {
                      todoedited = _val;
                    },
                    decoration: InputDecoration(
                        hintText: "Task",
                        errorText: validated ? null : errtext),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (intask.text.isEmpty) {
                              setState(
                                () {
                                  errtext = "Task field can't be empty";
                                  validated = false;
                                },
                              );
                            } else if (intask.text.length > 512) {
                              setState(
                                () {
                                  errtext = "More than 512 characters";
                                  validated = false;
                                },
                              );
                            } else {
                              addToDo();
                            }
                          },
                          child: Text("Add"))
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

// TODO: implement widget
  Widget mycard(String task) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        child: ListTile(
          title: Text("$task"),
          onLongPress: () {
            print("Item deleted");
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text("No Data"),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "TASK",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                centerTitle: true,
                backgroundColor: Colors.orange.shade100,
                elevation: 0,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showAlertDialog();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.orange.shade100,
              ),
              body: Center(
                child: Text("No Task Added"),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "TASK",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                centerTitle: true,
                backgroundColor: Colors.orange.shade100,
                elevation: 0,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showAlertDialog();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.orange.shade100,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "TASK",
    //       style: TextStyle(color: Colors.black, fontSize: 22),
    //     ),
    //     centerTitle: true,
    //     backgroundColor: Colors.orange.shade100,
    //     elevation: 0,
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       showAlertDialog();
    //     },
    //     child: Icon(
    //       Icons.add,
    //       color: Colors.black,
    //     ),
    //     backgroundColor: Colors.orange.shade100,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         mycard("I have to fill my reappear form before the last date."),
    //         mycard("Build my concept strong in flutter"),
    //         mycard("Work on our website"),
    //         mycard("Cover my syllabus before the sessional")
    //       ],
    //     ),
    //   ),
    // );
  }
}
