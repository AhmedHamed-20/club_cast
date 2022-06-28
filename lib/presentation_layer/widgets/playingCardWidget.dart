import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/material.dart';

class PlayingCardWidget {
  static Widget likeState(
    BuildContext context,
    bool likeState,
    String podCastId,
    String token,
    String userId, {
    String? searchName,
  }) {
    var cubit = GeneralAppCubit.get(context);
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
                  ? cubit
                      .removeLike(
                      podCastId: podCastId,
                      token: token,
                    )
                      .then(
                      (val) {
                        //bool isMyfollowingScreen = false;
                        // bool isMyprofileScreen = false;

                        if (cubit.isMyprofileScreen) {
                          cubit.getMyPodCast(token, context);
                        } else if (cubit.isProfilePage) {
                          cubit.getUserPodcast(token, userId);
                        } else if (cubit.isExplore) {
                          cubit.getExplorePodcast(token: token);
                        } else if (cubit.isSearchScreen) {
                          cubit.podCastSearch(token: token, value: searchName!);
                        } else {
                          cubit.getMyFollowingPodcast(token, context);
                        }

                        //isProfilePage
                        //getUserPodcast
                      },
                    )
                  : cubit
                      .addLike(
                      podCastId: podCastId,
                      token: token,
                    )
                      .then(
                      (val) {
                        if (cubit.isMyprofileScreen) {
                          cubit.getMyPodCast(token, context);
                        } else if (cubit.isProfilePage) {
                          cubit.getUserPodcast(token, userId);
                        } else if (cubit.isExplore) {
                          cubit.getExplorePodcast(token: token);
                        } else if (cubit.isSearchScreen) {
                          cubit.podCastSearch(token: token, value: searchName!);
                        } else {
                          cubit.getMyFollowingPodcast(token, context);
                        }
                      },
                    );
            },
            icon: Icon(
              likeState ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  static Widget podCastLikes(BuildContext context, cubit, String token,
      int index, String podcastID, String podCatLikesNumber) {
    return InkWell(
      onTap: () {
        cubit.getPodCastLikes(
            context: context, token: token, podCastId: podcastID);
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          podCatLikesNumber,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 15, color: Theme.of(context).backgroundColor),
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
      String userPhoto,
      BuildContext context) {
    return IconButton(
      onPressed: () {
        String podCastUrl = podcastUrl;

        if (SocketFunc.isConnected) {
          showToast(
              message: "you can't play podcast if you in a room,leave first(:",
              toastState: ToastState.WARNING);
        } else {
          cubit.isPlaying && podCastId == currentId
              ? cubit.assetsAudioPlayer.pause().then((value) {
                  cubit.isPlaying = false;
                  cubit.pressedPause = true;
                  cubit.changeState();
                })
              : cubit.playingPodcast(
                  podCastUrl, podCastName, userPhoto, podCastId, context);
          // print(GetAllPodCastModel.getPodCastAudio(index));

        }
      },
      icon: Icon(
        cubit.isPlaying && podCastId == currentId
            ? Icons.pause_circle_outline_outlined
            : Icons.play_circle_outline_outlined,
        size: 35,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  static Widget downloadingWidget(String currentId, int index, String podcastId,
      cubit, BuildContext context, String podcastUrl, String podcastName) {
    return IconButton(
      onPressed: () {
        var cubit = GeneralAppCubit.get(context);
        //  currentId = podcastId;
        cubit.downloadPodCast(podcastUrl, '${podcastName}.wav', podcastId);
      },
      icon: cubit.isDownloading && podcastId == cubit.downloadedPodCastId
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
              color: Theme.of(context).iconTheme.color,
            ),
    );
  }
}
