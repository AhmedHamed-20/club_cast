import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/material.dart';

class PlayingCardWidgetLocal {
  static Widget playingButton(
      int index,
      cubit,
      String podcastUrl,
      String currentId,
      String podCastId,
      String podCastName,
      String userPhoto,
      BuildContext context,
      bool isLocalPodcast) {
    return IconButton(
      onPressed: () {
        String podCastUrl = podcastUrl;
        bool LocalPodcast = isLocalPodcast;
        if (SocketFunc.isConnected) {
          showToast(
              message: "you can't play podcast if you in a room,leave first(:",
              toastState: ToastState.WARNING);
        } else {
          cubit.isPlaying && podCastId == currentId && LocalPodcast
              ? cubit.assetsAudioPlayer.pause().then((value) {
                  cubit.isPlaying = false;
                  cubit.pressedPause = true;
                  cubit.changeState();
                })
              : cubit.playingPodcast(podCastUrl, podCastName, userPhoto,
                  podCastId, context, isLocalPodcast);
          // print(GetAllPodCastModel.getPodCastAudio(index));

        }
      },
      icon: Icon(
        cubit.isPlaying && podCastId == currentId && isLocalPodcast
            ? Icons.pause_circle_outline_outlined
            : Icons.play_circle_outline_outlined,
        size: 35,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
