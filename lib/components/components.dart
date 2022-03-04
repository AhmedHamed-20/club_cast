
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget statusNumberProfile(
    {
      required String number,
      required String statusType,
    }) => Column(
  children:
  [
    Text(
      number,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15.0,
      ),
    ),
    SizedBox(
      height: 3.0,
    ),
    Text(
      statusType,
      style: TextStyle(
        fontSize: 15.0,
      ),
    ),
  ],
);

Widget userProfileImage(
    {
      required double size,
      required String image,
    }) => CircleAvatar(
  backgroundImage: AssetImage('assets/images/Adel.png'),
  radius: size,
);



void navigateTo(context, widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
);