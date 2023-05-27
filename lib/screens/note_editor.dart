import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/format.dart';
import 'package:notes/styles/app_style.dart';
import 'package:notes/utilities/snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as devtools show log;

import '../services/firebase_firestore_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  bool textScanning = false;

  XFile? imageFile;
  String scannedText = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainContentController = TextEditingController();
  String date = DateFormat(dateFormat).format(DateTime.now().toLocal());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 249, 210, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(243, 249, 210, 1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add a new note",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera)),
          IconButton(
              onPressed: () {
                getImage();
              },
              icon: const Icon(Icons.file_open_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textCapitalization: TextCapitalization.words,
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
              if (textScanning)
                const Center(child: CircularProgressIndicator()),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _mainContentController,
                  style: mainContent,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a note',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseProvider.notesCollection.add({
            "note_title": _titleController.text,
            "creation_date": date,
            "note_content": _mainContentController.text,
            "is_pinned": false,
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

  void getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      snackBar(context, "No Image Selected", "red");
    }
  }

  void getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = '$scannedText ${line.text} ';
      }
    }
    devtools.log(scannedText);
    _mainContentController.text = scannedText;
    textScanning = false;
    setState(() {});
  }
}
