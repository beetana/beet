import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

Future showMessageDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: Text(
              'OK',
              style: kEnterButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
