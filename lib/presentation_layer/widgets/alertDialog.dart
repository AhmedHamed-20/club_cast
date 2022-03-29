import 'package:flutter/material.dart';

Widget alertDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required VoidCallback yesFunction,
  required VoidCallback noFunction,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    backgroundColor: Theme.of(context).backgroundColor,
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    content: content,
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
            onPressed: yesFunction,
            child: Text(
              'Yes',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          MaterialButton(
            onPressed: noFunction,
            child: Text(
              'No',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    ],
  );
}
