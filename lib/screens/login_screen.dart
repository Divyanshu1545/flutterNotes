import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/crud/collections_reference.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/styles/app_style.dart';
import 'dart:developer' as devtools show log;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notes",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Login to your app",
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: const InputDecoration(
                hintText: "User email",
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            TextField(
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                hintText: "User password",
                prefixIcon: Icon(
                  Icons.security,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(registerRoute);
                },
                child: const Text(
                  "Not a user? Register here",
                  style: TextStyle(color: Colors.blue),
                )),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  try {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _email.text, password: _password.text)
                        .then((value) => Navigator.popAndPushNamed(
                            context, homescreenRoute));
                    user =await FirebaseAuth.instance.currentUser;

                    userId = user?.uid as String;
                    devtools.log(userId);
                  } on FirebaseAuthException {
                    Fluttertoast.showToast(
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: mainColor,
                      textColor: Colors.white,
                      msg: "Please enter valid credentials",
                    );
                  }
                },
                fillColor: accentColor,
                elevation: 00,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
