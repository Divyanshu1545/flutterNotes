import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddATaskDialog extends StatelessWidget {
  const AddATaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: const Color.fromARGB(255, 220, 205, 63),
      ),
    );
  }
}
