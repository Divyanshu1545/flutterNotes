import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/constants/routes.dart';

import 'dart:developer' as devtools show log;

import 'package:notes/firebase_options.dart';
import 'package:notes/screens/login_screen.dart';
import 'package:notes/screens/note_editor.dart';
import 'package:notes/styles/app_style.dart';
import 'package:notes/utilities/dialog_box.dart';
import 'package:notes/widgets/note_card.dart';
import 'package:notes/enums.dart';
import 'package:notes/widgets/todo_tile.dart';

import '../services/firebase_firestore_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider.initializeAllDb();
    Stream<QuerySnapshot> unpinnedNotesStream = FirebaseProvider.notesCollection
        .where("is_pinned", isEqualTo: false)
        .snapshots();
    Stream<QuerySnapshot> pinnedNotesStream = FirebaseProvider.notesCollection
        .where("is_pinned", isEqualTo: true)
        .snapshots();
    Stream<QuerySnapshot> todoListStream =
        FirebaseProvider.todoCollection.snapshots();

    if (FirebaseProvider.user == null) {
      return const LoginScreen();
    } else {
      devtools.log(FirebaseProvider.user!.uid.toString());
      return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showConfirmationDialog(
                          context,
                          "Sign out",
                          "Are you sure you wanna say goodbye? :(",
                          "Sign Out");
                      if (shouldLogout) {
                        await FirebaseProvider.logoutUser();

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (_) => false,
                        );
                      }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Log out'),
                    ),
                  ];
                },
              )
            ],
            elevation: 0.0,
            title: const Text("Notes"),
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(100, 144, 128, 1),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To Do List",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 15),
                  StreamBuilder<QuerySnapshot>(
                    stream: todoListStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        List<TodoTile> todoList = snapshot.data!.docs
                            .map((todo) => TodoTile(
                                  todo: todo,
                                  isDone: todo['is_done'],
                                ))
                            .toList();
                        if (todoList.isEmpty) {}
                        return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: todoList);
                      } else {
                        return Text(
                          "You don't have any notes",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  Container(height: 15),
                  Text(
                    "Pinned Notes",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: pinnedNotesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        return GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          children: snapshot.data!.docs
                              .map((note) => noteCard(context, note))
                              .toList(),
                        );
                      } else {
                        return Text(
                          "You don't have any notes",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Recent Notes",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: unpinnedNotesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        return GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          children: snapshot.data!.docs
                              .map((note) => noteCard(context, note))
                              .toList(),
                        );
                      } else {
                        return Text(
                          "You don't have any notes",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: const Color.fromRGBO(100, 144, 128, 1),
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                label: "Add Note",
                child: const Icon(Icons.note),
                backgroundColor: const Color.fromRGBO(243, 249, 210, 1),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const NoteEditorScreen())));
                },
              ),
              SpeedDialChild(
                  child: const Icon(Icons.list),
                  label: "Add todo",
                  backgroundColor: const Color.fromRGBO(189, 180, 178, 1),
                  onTap: () async {
                    FluidDialog(
                      rootPage: FluidDialogPage(
                          builder: (context) => Container(
                                color: Colors.black,
                              )),
                    );
                    await FirebaseProvider.todoCollection.add({
                      "task": "",
                      "is_done": false,
                    });
                  }),
            ],
          ));
    }
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}

void initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


// Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton.extended(
//               onPressed: () async {
//                 FluidDialog(
//                   rootPage: FluidDialogPage(
//                       builder: (context) => Container(
//                             color: Colors.black,
//                           )),
//                 );
//                 await FirebaseProvider.todoCollection.add({
//                   "task": "",
//                   "is_done": false,
//                 });
//               },
//               label: const Text("Add todo"),
//               icon: const Icon(Icons.list),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             FloatingActionButton.extended(
//               heroTag: Text("Note Button"),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: ((context) => NoteEditorScreen())));
//               },
//               label: const Text("Add Note"),
//               icon: const Icon(Icons.note),
//             ),
//           ],
//         ),




















// void _showPopupMenu(BuildContext context) async {
//   final selectedOption = await showMenu(
//     context: context,
//     position: const RelativeRect.fromLTRB(100, 200, 0, 0),
//     items: [
//       const PopupMenuItem(
//         value: 1,
//         child: Text('Option 1'),
//       ),
//       const PopupMenuItem(
//         value: 2,
//         child: Text('Option 2'),
//       ),
//       const PopupMenuItem(
//         child: Text('Option 3'),
//         value: 3,
//       ),
//     ],
//     elevation: 8.0,
//   );
// }
