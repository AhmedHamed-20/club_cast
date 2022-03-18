import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';

class PodCastScreen extends StatelessWidget {
  const PodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit?.get(context);
    String? currentId;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        currentId = cubit.activePodCastId;
        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, end: 10, top: 20),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                print(GetAllPodCastModel.getPodcastUserPublishInform(index));
                navigatePushTo(
                    context: context, navigateTo: ActivePodCastScreen(index));
              },
              child: podACastItem(
                context,
                index: index,
                downloadButton: IconButton(
                  onPressed: () {
                    currentId = GetAllPodCastModel.getPodcastID(index);
                    cubit.downloadPodCast(
                        GetAllPodCastModel.getPodCastAudio(index)[0]['url'],
                        '${GetAllPodCastModel.getPodcastName(index)}.wav');
                  },
                  icon: cubit.isDownloading &&
                          GetAllPodCastModel.getPodcastID(index) == currentId
                      ? CircularProgressIndicator(
                          value: cubit.progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          // color: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                        )
                      : Icon(
                          Icons.cloud_download_outlined,
                          size: 35,
                        ),
                ),
                removePodCast: SizedBox(),
                playingWidget: IconButton(
                  onPressed: () {
                    String podCastUrl =
                        GetAllPodCastModel.getPodCastAudio(index)[0]['url'];

                    cubit.isPlaying &&
                            GetAllPodCastModel.getPodcastID(index) == currentId
                        ? cubit.assetsAudioPlayer.pause().then((value) {
                            cubit.isPlaying = false;
                            cubit.pressedPause = true;
                            cubit.changeState();
                          })
                        : cubit.playingPodcast(
                            podCastUrl,
                            GetAllPodCastModel.getPodcastName(index),
                            GetAllPodCastModel.getPodcastUserPublishInform(
                                index)[0]['photo'],
                            GetAllPodCastModel.getPodcastID(index));
                    print(GetAllPodCastModel.getPodCastAudio(index));
                    print(currentId);
                  },
                  icon: Icon(
                    cubit.isPlaying &&
                            GetAllPodCastModel.getPodcastID(index) == currentId
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline_outlined,
                    size: 35,
                  ),
                ),
                text: cubit.isPlaying &&
                        GetAllPodCastModel.getPodcastID(index) == currentId
                    ? cubit.currentOlayingDurathion
                    : cubit.pressedPause &&
                            GetAllPodCastModel.getPodcastID(index) == currentId
                        ? cubit.currentOlayingDurathion
                        : null,
              ),
            ),
            itemCount: GetAllPodCastModel.getAllPodCast?['data'].length,
          ),
        );
      },
    );
  }
}
