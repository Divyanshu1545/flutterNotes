import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context, String title,
    String content, String actionButtonName) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
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
            child: Text(actionButtonName),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
