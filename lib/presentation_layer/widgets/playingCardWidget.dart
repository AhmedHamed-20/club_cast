import 'package:flutter/material.dart';

class PlayingCardWidget {
  static Widget likeState(BuildContext context, bool likeState, cubit,
      String podCastId, String token) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0, bottom: 15),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).backgroundColor,
        child: IconButton(
            splashRadius: 25,
            padding: EdgeInsets.zero,
            onPressed: () {
              likeState
                  ? cubit.removeLike(podCastId: podCastId, token: token)
                  : cubit.addLike(podCastId: podCastId, token: token);
            },
            icon: Icon(
              likeState ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            )),
      ),
    );
  }

  static Widget podCastLikes(BuildContext context, cubit, String token,
      int index, String podcastID, String podCatLikesNumber) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Theme.of(context).backgroundColor,
        child: InkWell(
          onTap: () {
            cubit.getPodCastLikes(
                context: context, token: token, podCastId: podcastID);
          },
          child: Text(
            podCatLikesNumber,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15),
          ),
        ),
      ),
    );
  }

  static Widget playingButton(
      int index,
      cubit,
      String podcastUrl,
      String currentId,
      String podCastId,
      String podCastName,
      String userPhoto) {
    return IconButton(
      onPressed: () {
        String podCastUrl = podcastUrl;

        cubit.isPlaying && podCastId == currentId
            ? cubit.assetsAudioPlayer.pause().then((value) {
                cubit.isPlaying = false;
                cubit.pressedPause = true;
                cubit.changeState();
              })
            : cubit.playingPodcast(
                podCastUrl, podCastName, userPhoto, podCastId);
        // print(GetAllPodCastModel.getPodCastAudio(index));
        print(currentId);
      },
      icon: Icon(
        cubit.isPlaying && podCastId == currentId
            ? Icons.pause_circle_outline_outlined
            : Icons.play_circle_outline_outlined,
        size: 35,
      ),
    );
  }

  static Widget downloadingWidget(String currentId, int index, String podcastId,
      cubit, BuildContext context, String podcastUrl, String podcastName) {
    return IconButton(
      onPressed: () {
        currentId = podcastId;
        cubit.downloadPodCast(podcastUrl, '${podcastName}.wav');
      },
      icon: cubit.isDownloading && podcastId == currentId
          ? CircularProgressIndicator(
              value: cubit.progress,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              // color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
            )
          : Icon(
              Icons.cloud_download_outlined,
              size: 35,
            ),
    );
  }
}
