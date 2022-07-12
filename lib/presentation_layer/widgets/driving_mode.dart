import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'extract_color_from_image.dart';

Widget pilotMode({
  required BuildContext context,
  required String podcastName,
  required VoidCallback replayCallBack,
  required VoidCallback forwardCallBack,
  required VoidCallback playCallBack,
  required cubit,
  required podCastId,
}) {
  return Padding(
    padding: const EdgeInsets.all(40),
    child: Card(
      color: Theme.of(context).backgroundColor,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              child: Center(
                child: Text(
                  'Driving Mode',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  splashRadius: 50,
                  iconSize: 60,
                  icon: Icon(
                    Icons.replay_10,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: replayCallBack,
                ),
                IconButton(
                  splashRadius: 50,
                  iconSize: 60,
                  icon: Icon(
                    cubit.isPlaying && podCastId == cubit.activePodCastId
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: playCallBack,
                ),
                IconButton(
                  iconSize: 60,
                  splashRadius: 50,
                  icon: Icon(
                    Icons.forward_10,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: forwardCallBack,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 90,
              height: 50,
              child: Marquee(
                text: podcastName,
                style: Theme.of(context).textTheme.bodyText1,
                scrollAxis: Axis.horizontal,
                blankSpace: 5,
              ),
            ),
            defaultButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              context: context,
              text: 'Close',
              width: 80,
              height: 50,
            ),
          ],
        ),
      ),
    ),
  );
}
