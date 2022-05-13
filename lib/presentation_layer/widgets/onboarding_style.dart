import 'package:club_cast/presentation_layer/widgets/model_sheet_room_contant.dart';
import 'package:flutter/material.dart';

Widget onBoardingStyle(String imagePath, String text, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset(
        imagePath,
        width: 300,
        height: 300,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.grey[900],
                fontSize: 24,
              ),
          textAlign: TextAlign.center,
        ),
      )
    ],
  );
}
