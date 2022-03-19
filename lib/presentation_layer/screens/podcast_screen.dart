import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingPodcast.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import '../../data_layer/cash/cash.dart';
import '../widgets/playingCardWidget.dart';

class PodCastScreen extends StatelessWidget {
  const PodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit?.get(context);
    String token = CachHelper.getData(key: 'token');
    String? currentId;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        currentId = cubit.activePodCastId;

        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, end: 10, top: 20),
          child: GetMyFollowingPodCastsModel
                  .getMyFollowingPodcasts!['data'].isEmpty
              ? Center(
                  child: Text(
                    'Follow someone to see following podcasts',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      //  print(GetAllPodCastModel.getPodcastUserPublishInform(index));
                      navigatePushTo(
                          context: context,
                          navigateTo: ActivePodCastScreen(index));
                    },
                    child: podACastItem(
                      context,
                      index: index,
                      downloadButton: PlayingCardWidget.downloadingWidget(
                          currentId.toString(),
                          index,
                          GetMyFollowingPodCastsModel.getPodcastID(index),
                          cubit,
                          context,
                          GetMyFollowingPodCastsModel.getPodCastAudio(index)[0]
                              ['url'],
                          GetMyFollowingPodCastsModel.getPodcastName(index)),
                      likeWidget: PlayingCardWidget.likeState(
                        context,
                        GetMyFollowingPodCastsModel.getPodcastlikeState(index),
                        GetMyFollowingPodCastsModel.getPodcastID(index),
                        token,
                        '',
                      ),
                      podCastLikes: PlayingCardWidget.podCastLikes(
                          context,
                          cubit,
                          token,
                          index,
                          GetMyFollowingPodCastsModel.getPodcastID(index),
                          GetMyFollowingPodCastsModel.getPodcastLikes(index)
                              .toString()),
                      removePodCast: SizedBox(),
                      playingWidget: PlayingCardWidget.playingButton(
                          index,
                          cubit,
                          GetMyFollowingPodCastsModel.getPodCastAudio(index)[0]
                              ['url'],
                          currentId.toString(),
                          GetMyFollowingPodCastsModel.getPodcastID(index),
                          GetMyFollowingPodCastsModel.getPodcastName(index),
                          GetMyFollowingPodCastsModel
                              .getPodcastUserPublishInform(index)[0]['photo']),
                      gettime:
                          GetMyFollowingPodCastsModel.getPodCastAudio(index)[0]
                              ['duration'],
                      photourl: GetMyFollowingPodCastsModel
                          .getPodcastUserPublishInform(index)[0]['photo'],
                      podcastName:
                          GetMyFollowingPodCastsModel.getPodcastName(index),
                      userName: GetMyFollowingPodCastsModel
                          .getPodcastUserPublishInform(index)[0]['name'],
                      text: cubit.isPlaying &&
                              GetMyFollowingPodCastsModel.getPodcastID(index) ==
                                  currentId
                          ? cubit.currentOlayingDurathion
                          : cubit.pressedPause &&
                                  GetMyFollowingPodCastsModel.getPodcastID(
                                          index) ==
                                      currentId
                              ? cubit.currentOlayingDurathion
                              : null,
                    ),
                  ),
                  itemCount: GetMyFollowingPodCastsModel
                      .getMyFollowingPodcasts?['data'].length,
                ),
        );
      },
    );
  }
}
