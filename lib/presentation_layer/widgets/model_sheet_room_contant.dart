import 'package:flutter/material.dart';

class WidgetFunc {
  static Widget bottomSheetContant(
    BuildContext context,
    String userName,
    String avaterUrl,
    Widget Button,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(avaterUrl),
                  ),
                  const SizedBox(
                    height: 15,
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
      ),
    );
  }
}
