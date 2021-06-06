import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  final tasksRef = FirebaseDatabase.instance.reference().child('tasks');

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: FirebaseAnimatedList(
        query: tasksRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return ListTile(
            title: Text(snapshot.value['task']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                tasksRef.child(snapshot.key ?? '').remove();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                String newtask = '';
                return AlertDialog(
                  title: Text('Add New Task'),
                  content: TextField(
                    autocorrect: true,
                    onChanged: (taskString) {
                      setState(() {
                        newtask = taskString;
                      });
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .child('tasks')
                            .push()
                            .child('task')
                            .set(newtask)
                            .asStream();
                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// ListTile(
//                   title: Text(l[index]),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       setState(() {
//                         l.removeAt(index);
//                       });
//                     },
//                   ),
//                 ),