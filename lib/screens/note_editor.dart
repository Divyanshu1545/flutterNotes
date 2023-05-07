import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/format.dart';
import 'package:notes/crud/collections_reference.dart';
import 'package:notes/styles/app_style.dart';
import 'dart:developer' as devtools show log;

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int colorId = Random().nextInt(cardColors.length);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainContentController = TextEditingController();
  String date = DateFormat(dateFormat).format(DateTime.now().toLocal());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColors[colorId],
      appBar: AppBar(
        backgroundColor: cardColors[colorId],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add a new note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
              controller: _titleController,
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              date,
              style: dateTitle,
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _mainContentController,
              style: mainContent,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a note',
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("user_collection")
              .doc(userId)
              .collection("Notes")
              .add({
            "note_title": _titleController.text,
            "creation_date": date,
            "note_content": _mainContentController.text,
            "color_id": colorId,
          }).then((value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Note saved successfully"),
              showCloseIcon: true,
              backgroundColor: Color.fromARGB(255, 54, 145, 57),
              closeIconColor: Colors.black,
              duration: Duration(seconds: 1),
            ));
          });
        },
        child: const Icon(Icons.save_as_rounded),
      ),
    );
  }
}
