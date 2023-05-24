import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class FirebaseProvider {
  static late CollectionReference usersCollection;
  static late CollectionReference notesCollection;
  static late CollectionReference todoCollection;
  static late User? user;

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    initializeUser();
  }

  static Future<void> createUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> loginUser(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    user = FirebaseAuth.instance.currentUser;
  }

  static User? getCurrentUser() => user;
  static void initializeUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  static void initializeAllDb() {
    usersCollection = FirebaseFirestore.instance.collection("user_collection");
    notesCollection = usersCollection.doc(user?.uid).collection("Notes");
    todoCollection =
        usersCollection.doc(user?.uid).collection("todo_collection");
  }

  static Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    user = null;
  }
}
