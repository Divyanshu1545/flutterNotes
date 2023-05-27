import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:notes/services/firebase_firestore_provider.dart';

class TodoTile extends StatefulWidget {
  QueryDocumentSnapshot todo;
  bool isDone;
  TodoTile({
    required this.todo,
    required this.isDone,
    super.key,
  });

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  TextEditingController todoController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) async {
                setState(() async {
                  await FirebaseProvider.todoCollection
                      .doc(widget.todo.id)
                      .delete();
                });
              },
              icon: Icons.delete,
              backgroundColor: Colors.red.shade500,
            )
          ],
        ),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) async {
                setState(() async {
                  widget.isDone = !widget.isDone;
                  await FirebaseProvider.todoCollection
                      .doc(widget.todo.id)
                      .update({'is_done': widget.isDone});
                });
              },
              icon: Icons.done,
              backgroundColor: Colors.green.shade500,
            )
          ],
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          child: Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isDone
                  ? const Color.fromARGB(255, 92, 215, 96)
                  : const Color.fromRGBO(189, 180, 178, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter your todo",
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              controller: todoController,
              onSubmitted: (value) async {
                await FirebaseProvider.todoCollection
                    .doc(widget.todo.id)
                    .update({'task': todoController.text});
              },
              style: TextStyle(
                  decoration: widget.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
