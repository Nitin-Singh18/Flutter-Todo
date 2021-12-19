// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo_app/Models/dphelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dphelper = Databasehelper.instance;

  final TextEditingController intask = TextEditingController();

  String errtext = "";
  bool validated = true;

  void showAlertDialog() {
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
                                  if (intask.text.isEmpty) {
                                    errtext = "Task field can't be empty";
                                    validated = false;
                                  }
                                },
                              );
                            } else if (intask.text.length > 512) {
                              setState(
                                () {
                                  errtext = "More than 512 characters";
                                  validated = false;
                                },
                              );
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
          children: [
            mycard("I have to fill my reappear form before the last date."),
            mycard("Build my concept strong in flutter"),
            mycard("Work on our website"),
            mycard("Cover my syllabus before the sessional")
          ],
        ),
      ),
    );
  }
}
