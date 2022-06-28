import 'package:flutter/material.dart';

Widget multiAlerDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required Widget actions,
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
      actions,
    ],
  );
}
