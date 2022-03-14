
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

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );


Widget podACastItem(
    BuildContext context, {
      required String roomName,
      required String speaker,
      required String roomTime,
    }) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.23,
    width: double.infinity,
    child: Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/signPhoto.png'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(
                  speaker,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      roomTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.16,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cloud_download_outlined,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline_outlined,
                        size: 35,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}