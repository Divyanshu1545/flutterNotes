import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes/constants/routes.dart';

import '../styles/app_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterScreen> {
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
              "Register, you won't regret",
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
                  Navigator.of(context).popAndPushNamed(loginRoute);
                },
                child: const Text(
                  "Already a user? Sign in",
                  style: TextStyle(color: Colors.blue),
                )),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () {
                  final user = FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email.text, password: _password.text);

                  print(user);
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email.text, password: _password.text);
                },
                fillColor: accentColor,
                elevation: 00,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  "Register",
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
