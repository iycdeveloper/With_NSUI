import 'package:flutter/material.dart';

showCustomMessage(
    {required String message,
    required String title,
    required BuildContext context,
    required Function onTap,
    bool isError = true}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => onTap(),
          ),
        ],
      );
    },
  );
}
