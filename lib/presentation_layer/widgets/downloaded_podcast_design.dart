import 'package:club_cast/presentation_layer/models/downloaded_podcasts_moder.dart';
import 'package:club_cast/presentation_layer/widgets/pod_cast_card_item.dart';
import 'package:flutter/material.dart';

Widget downloadedPodCasDesign({
  required BuildContext context,
  required String podcastName,
  required podcasDuration,
  required podcastPhotoUrl,
  required VoidCallback ontapOnCircleAvater,
  required Widget playingWidget,
  required String userName,
  required String? currentPodcastDuration,
}) {
  double time = podcasDuration;
  var hours = (time / (60 * 60)).floor();
  var minutes = ((time - hours * 60 * 60) / 60).floor();
  var second = ((time - hours * 60 * 60 - minutes * 60)).floor();
  String convertedTime =
      '${hours.toString()}:${minutes.toString()}:${second.toString()}';
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Theme.of(context).backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(
            podcastName,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          leading: GestureDetector(
            onTap: ontapOnCircleAvater,
            child: CircleAvatar(
              backgroundImage: NetworkImage(podcastPhotoUrl),
              radius: 30,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
              ),
              Text(
                currentPodcastDuration == null
                    ? convertedTime
                    : currentPodcastDuration,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          trailing: playingWidget,
        ),
      ),
    ),
  );
}
