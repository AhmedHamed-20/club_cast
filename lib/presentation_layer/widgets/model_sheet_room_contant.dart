import 'package:flutter/material.dart';

class WidgetFunc {
  static Widget bottomSheetContant(
    BuildContext context,
    String userName,
    String avaterUrl,
    Widget Button,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(avaterUrl),
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Button,
        ],
      ),
    );
  }
}
