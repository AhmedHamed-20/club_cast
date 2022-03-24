import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingPodcast.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/explore_screen.dart';
import 'package:club_cast/presentation_layer/screens/profile_detailes_screen.dart';
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
        print(currentId);
        return Padding(
          padding: cubit.isPlaying || cubit.isPausedInHome
              ? const EdgeInsets.only(
                  left: 10.0, right: 10, top: 10, bottom: 70)
              : const EdgeInsets.only(
                  left: 10.0, right: 10, top: 10, bottom: 20),
          child: GetMyFollowingPodCastsModel
                  .getMyFollowingPodcasts!['data'].isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Follow someone to see following podcasts',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                        onPressed: () {
                          cubit.getExplorePodcast(token: token);
                          navigatePushTo(
                            context: context,
                            navigateTo: ExploreScreen(),
                          );
                        },
                        context: context,
                        text: 'Explore',
                        width: 150,
                        radius: 25,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  backgroundColor: Theme.of(context).backgroundColor,
                  color: Theme.of(context).primaryColor,
                  onRefresh: () => cubit.getMyFollowingPodcast(token),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      //  crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                              downloadButton:
                                  PlayingCardWidget.downloadingWidget(
                                      currentId.toString(),
                                      index,
                                      GetMyFollowingPodCastsModel.getPodcastID(
                                          index),
                                      cubit,
                                      context,
                                      GetMyFollowingPodCastsModel
                                          .getPodCastAudio(index)[0]['url'],
                                      GetMyFollowingPodCastsModel
                                          .getPodcastName(index)),
                              likeWidget: PlayingCardWidget.likeState(
                                context,
                                GetMyFollowingPodCastsModel.getPodcastlikeState(
                                    index),
                                GetMyFollowingPodCastsModel.getPodcastID(index),
                                token,
                                '',
                              ),
                              podCastLikes: PlayingCardWidget.podCastLikes(
                                  context,
                                  cubit,
                                  token,
                                  index,
                                  GetMyFollowingPodCastsModel.getPodcastID(
                                      index),
                                  GetMyFollowingPodCastsModel.getPodcastLikes(
                                          index)
                                      .toString()),
                              removePodCast: SizedBox(),
                              playingWidget: PlayingCardWidget.playingButton(
                                  index,
                                  cubit,
                                  GetMyFollowingPodCastsModel.getPodCastAudio(
                                      index)[0]['url'],
                                  currentId.toString(),
                                  GetMyFollowingPodCastsModel.getPodcastID(
                                      index),
                                  GetMyFollowingPodCastsModel.getPodcastName(
                                      index),
                                  GetMyFollowingPodCastsModel
                                          .getPodcastUserPublishInform(index)[0]
                                      ['photo'],
                                  context),
                              gettime:
                                  GetMyFollowingPodCastsModel.getPodCastAudio(
                                      index)[0]['duration'],
                              photourl: GetMyFollowingPodCastsModel
                                      .getPodcastUserPublishInform(index)[0]
                                  ['photo'],
                              ontapOnCircleAvater: () {
                                cubit.getUserById(
                                    profileId: GetMyFollowingPodCastsModel
                                        .getPodcastUserPublishInform(
                                            index)[0]['_id']);
                                cubit.getUserPodcast(
                                    token,
                                    GetMyFollowingPodCastsModel
                                        .getPodcastUserPublishInform(
                                            index)[0]['_id']);
                                navigatePushTo(
                                    context: context,
                                    navigateTo: ProfileDetailsScreen(
                                        GetMyFollowingPodCastsModel
                                            .getPodcastUserPublishInform(
                                                index)[0]['_id']));
                              },
                              podcastName:
                                  GetMyFollowingPodCastsModel.getPodcastName(
                                      index),
                              userName: GetMyFollowingPodCastsModel
                                      .getPodcastUserPublishInform(index)[0]
                                  ['name'],
                              text: cubit.isPlaying &&
                                      GetMyFollowingPodCastsModel.getPodcastID(
                                              index) ==
                                          currentId
                                  ? cubit.currentOlayingDurathion
                                  : cubit.pressedPause &&
                                          GetMyFollowingPodCastsModel
                                                  .getPodcastID(index) ==
                                              currentId
                                      ? cubit.currentOlayingDurathion
                                      : null,
                            ),
                          ),
                          itemCount: GetMyFollowingPodCastsModel
                              .getMyFollowingPodcasts?['data'].length,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        cubit.noDataMyfollowingPodcast
                            ? const SizedBox()
                            : InkWell(
                                borderRadius: BorderRadius.circular(40),
                                onTap: () {
                                  cubit.pageinathionMyFollowingPodcast(
                                    token,
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  radius: 30,
                                  child: cubit.loadMyFollowinPodcast
                                      ? CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Icons.arrow_downward,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
