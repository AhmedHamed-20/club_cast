import 'package:flutter/material.dart';

Widget searchWidgetCard(BuildContext context, cubit, Widget widget) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        cubit.isSearch
            ? LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
              )
            : const SizedBox(),
        const SizedBox(
          height: 12.0,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              widget,
            ],
          ),
        ),
      ],
    ),
  );
}
