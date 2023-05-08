import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/format.dart';
import 'package:notes/crud/collections_reference.dart';
import 'package:notes/styles/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen(this.doc, {super.key});
  final QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc["color_id"];

    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _titleController =
        TextEditingController(text: widget.doc["note_title"]);
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _mainContentController =
        TextEditingController(text: widget.doc["note_content"]);
    return Scaffold(
      backgroundColor: cardColors[colorId],
      appBar: AppBar(
        backgroundColor: cardColors[colorId],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 00,
        actions: [
          IconButton(
            onPressed: () async {
              await notesCollection.doc(widget.doc.id).delete().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Note deleted successfully"),
                  showCloseIcon: true,
                  backgroundColor: Color.fromARGB(255, 164, 0, 0),
                  closeIconColor: Colors.black,
                  duration: Duration(seconds: 1),
                ));
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.delete_forever_outlined),
          ),
          IconButton(
              onPressed: () async {
                await FlutterShare.share(
                    text:
                        "${_titleController.text}: ${_mainContentController.text}",
                    title: _titleController.text);
              },
              icon: const Icon(Icons.share_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            Text(
              widget.doc["creation_date"],
              style: dateTitle,
            ),
            const SizedBox(height: 20),
            TextField(
                controller: _mainContentController,
                style: mainContent,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await notesCollection.doc(widget.doc.id).update({
            "note_title": _titleController.text,
            "creation_date":
                DateFormat(dateFormat).format(DateTime.now().toLocal()),
            "note_content": _mainContentController.text,
            "color_id": colorId,
          })
              // add({
              //   "note_title": _titleController.text,
              //   "creation_date": DateTime.now().toLocal().toString(),
              //   "note_content": _mainContentController.text,
              //   "color_id": colorId,
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Note saved successfully"),
              showCloseIcon: true,
              backgroundColor: Color.fromARGB(255, 54, 145, 57),
              closeIconColor: Colors.black,
              duration: Duration(seconds: 1),
            ));
            Navigator.pop(context);
          });
        },
        child: const Icon(Icons.save_as_rounded),
      ),
    );
  }
}
