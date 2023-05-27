import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/format.dart';
import 'package:notes/styles/app_style.dart';
import 'package:notes/utilities/dialog_box.dart';
import 'package:quickalert/quickalert.dart';

import '../services/firebase_firestore_provider.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen(this.note, {super.key});
  final QueryDocumentSnapshot note;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    bool isPinned = widget.note["is_pinned"];

    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _titleController =
        TextEditingController(text: widget.note["note_title"]);
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _mainContentController =
        TextEditingController(text: widget.note["note_content"]);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 249, 210, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(243, 249, 210, 1),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 00,
        actions: [
          IconButton(
            onPressed: () async {
              final shouldDelete = await showConfirmationDialog(
                  context,
                  "Delete",
                  "Are you sure you want to delete this note",
                  "Delete");
              if (shouldDelete) {
                await FirebaseProvider.notesCollection
                    .doc(widget.note.id)
                    .delete()
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Note deleted successfully"),
                    showCloseIcon: true,
                    backgroundColor: Color.fromARGB(255, 164, 0, 0),
                    closeIconColor: Colors.black,
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.pop(context);
                });
              }
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
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 10),
            Text(
              widget.note["creation_date"],
              style: dateTitle,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _mainContentController,
                style: mainContent,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseProvider.notesCollection.doc(widget.note.id).update({
            "note_title": _titleController.text,
            "creation_date":
                DateFormat(dateFormat).format(DateTime.now().toLocal()),
            "note_content": _mainContentController.text,
            "is_pinned": isPinned
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
