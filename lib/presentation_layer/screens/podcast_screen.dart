import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';

class PodCastScreen extends StatelessWidget {
  const PodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String currentId;
    var cubit = GeneralAppCubit?.get(context);
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, end: 10, top: 20),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => podACastItem(
              context,
              index: index,
              playingWidget: IconButton(
                onPressed: () {
                  String podCastUrl =
                      GetAllPodCastModel.getPodCastAudio(index)[0]['url'];
                  currentId = GetAllPodCastModel.getPodcastID(index);

                  cubit.isPlaying
                      ? cubit.assetsAudioPlayer.pause().then((value) {
                          cubit.isPlaying = false;
                          cubit.pressedPause = true;
                          cubit.changeState();
                        })
                      : cubit.playingPodcast(
                          podCastUrl,
                          GetAllPodCastModel.getPodcastName(index),
                          GetAllPodCastModel.getPodcastUserPublishInform(
                              index)[0]['photo']);
                  print(GetAllPodCastModel.getPodCastAudio(index));
                },
                icon: Icon(
                  cubit.isPlaying &&
                          currentId == GetAllPodCastModel.getPodcastID(index)
                      ? Icons.pause_circle_outline_outlined
                      : Icons.play_circle_outline_outlined,
                  size: 35,
                ),
              ),
              text: cubit.isPlaying &&
                      currentId == GetAllPodCastModel.getPodcastID(index)
                  ? cubit.currentOlayingDurathion
                  : cubit.pressedPause &&
                          currentId == GetAllPodCastModel.getPodcastID(index)
                      ? cubit.currentOlayingDurathion
                      : null,
            ),
            itemCount: GetAllPodCastModel.getAllPodCast?['data'].length,
          ),
        );
      },
    );
  }
}
