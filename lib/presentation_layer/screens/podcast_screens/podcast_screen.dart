import 'dart:typed_data';

import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/downloaded_podcasts_moder.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingPodcast.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/explore_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/profile_detailes_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/profile_detailes_screens/user_profile_screen.dart';
import 'package:club_cast/presentation_layer/widgets/downloaded_podcast_design.dart';
import 'package:club_cast/presentation_layer/widgets/extract_color_from_image.dart';
import 'package:club_cast/presentation_layer/widgets/pod_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import '../../../data_layer/cash/cash.dart';
import '../../widgets/playingCardWidget.dart';
import '../../widgets/playing_card_widget_local.dart';

class PodCastScreen extends StatelessWidget {
  PodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);
    String token = CachHelper.getData(key: 'token');
    String? currentId;

    //print(currentId);
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // print('podcast');
        // print(RoomCubit.get(context).speakers);
        currentId = cubit.activePodCastId;
        //     print(currentId);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Container()),
                      TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).primaryColor,
                        ),
                        tabs: const [
                          Text("Your Podcasts "),
                          Text("Downloaded Podcasts")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: cubit.isPlaying || cubit.isPausedInHome
                      ? const EdgeInsets.only(
                          left: 10.0, right: 10, top: 10, bottom: 70)
                      : const EdgeInsets.only(
                          left: 10.0,
                          right: 10,
                          top: 10,
                        ),
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
                                    navigateTo: const ExploreScreen(),
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
                          onRefresh: () =>
                              cubit.getMyFollowingPodcast(token, context),
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => InkWell(
                                    onTap: () async {
                                      GenerateColor.colors = [];
                                      navigatePushTo(
                                          context: context,
                                          navigateTo: ActivePodCastScreen(
                                            duration:
                                                GetMyFollowingPodCastsModel
                                                    .getPodCastAudio(
                                                        index)[0]['duration'],
                                            podCastId:
                                                GetMyFollowingPodCastsModel
                                                    .getPodcastID(index),
                                            podcastName:
                                                GetMyFollowingPodCastsModel
                                                    .getPodcastName(index),
                                            podcastUrl:
                                                GetMyFollowingPodCastsModel
                                                    .getPodCastAudio(
                                                        index)[0]['url'],
                                            userName: GetMyFollowingPodCastsModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['name'],
                                            userPhoto:
                                                GetMyFollowingPodCastsModel
                                                    .getPodcastUserPublishInform(
                                                        index)[0]['photo'],
                                            index: index,
                                            userId: GetMyFollowingPodCastsModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['_id'],
                                          ));
                                    },
                                    child: podACastItem(
                                      context,
                                      index: index,
                                      downloadButton:
                                          PlayingCardWidget.downloadingWidget(
                                              currentId.toString(),
                                              index,
                                              GetMyFollowingPodCastsModel
                                                  .getPodcastID(index),
                                              cubit,
                                              context,
                                              GetMyFollowingPodCastsModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              GetMyFollowingPodCastsModel
                                                  .getPodcastName(index)),
                                      likeWidget: PlayingCardWidget.likeState(
                                        context,
                                        GetMyFollowingPodCastsModel
                                            .getPodcastlikeState(index),
                                        GetMyFollowingPodCastsModel
                                            .getPodcastID(index),
                                        token,
                                        '',
                                      ),
                                      podCastLikes:
                                          PlayingCardWidget.podCastLikes(
                                              context,
                                              cubit,
                                              token,
                                              index,
                                              GetMyFollowingPodCastsModel
                                                  .getPodcastID(index),
                                              GetMyFollowingPodCastsModel
                                                      .getPodcastLikes(index)
                                                  .toString()),
                                      removePodCast: const SizedBox(),
                                      playingWidget:
                                          PlayingCardWidget.playingButton(
                                              index,
                                              cubit,
                                              GetMyFollowingPodCastsModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              currentId.toString(),
                                              GetMyFollowingPodCastsModel
                                                  .getPodcastID(index),
                                              GetMyFollowingPodCastsModel
                                                  .getPodcastName(index),
                                              GetMyFollowingPodCastsModel
                                                  ?.getPodcastUserPublishInform(
                                                      index)[0]?['photo'],
                                              context,
                                              false),
                                      gettime: GetMyFollowingPodCastsModel
                                              .getPodCastAudio(index)[0]
                                          ['duration'],
                                      photourl: GetMyFollowingPodCastsModel
                                          .getPodcastUserPublishInform(
                                              index)[0]['photo'],
                                      ontapOnCircleAvater: () {
                                        cubit.getUserById(
                                            profileId:
                                                GetMyFollowingPodCastsModel
                                                    .getPodcastUserPublishInform(
                                                        index)[0]['_id'],
                                            token: token);
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
                                      podcastName: GetMyFollowingPodCastsModel
                                          .getPodcastName(index),
                                      userName: GetMyFollowingPodCastsModel
                                          .getPodcastUserPublishInform(
                                              index)[0]['name'],
                                      text: cubit.isPlaying &&
                                              GetMyFollowingPodCastsModel
                                                      .getPodcastID(index) ==
                                                  currentId
                                          ? cubit.currentplayingDurathion
                                          : cubit.pressedPause &&
                                                  GetMyFollowingPodCastsModel
                                                          .getPodcastID(
                                                              index) ==
                                                      currentId
                                              ? cubit.currentplayingDurathion
                                              : null,
                                    ),
                                  ),
                                  childCount: GetMyFollowingPodCastsModel
                                      .getMyFollowingPodcasts?['data'].length,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    cubit.noDataMyfollowingPodcast
                                        ? const SizedBox()
                                        : InkWell(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            onTap: () {
                                              cubit
                                                  .pageinathionMyFollowingPodcast(
                                                token,
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .backgroundColor,
                                              radius: 30,
                                              child: cubit.loadMyFollowinPodcast
                                                  ? CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_downward,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                ListView.builder(
                    itemCount:
                        DownloadedPodCastModel.getPodcastInformation.length,
                    itemBuilder: (context, index) {
                      return downloadedPodCasDesign(
                        context: context,
                        userName:
                            DownloadedPodCastModel.getPodcastUserPublishInform(
                                index)['name'],
                        podcastName:
                            DownloadedPodCastModel.getPodcastName(index),
                        podcastPhotoUrl:
                            DownloadedPodCastModel.getPodcastUserPublishInform(
                                index)['photo'],
                        ontapOnCircleAvater: () {
                          cubit.getUserById(
                              profileId: DownloadedPodCastModel
                                  .getPodcastUserPublishInform(index)['_id'],
                              token: token);
                          cubit.getUserPodcast(
                              token,
                              DownloadedPodCastModel
                                  .getPodcastUserPublishInform(index)['_id']);

                          navigatePushTo(
                              context: context,
                              navigateTo: ProfileDetailsScreen(
                                  DownloadedPodCastModel
                                      .getPodcastUserPublishInform(
                                          index)['_id']));
                        },
                        playingWidget: PlayingCardWidgetLocal.playingButton(
                            index,
                            cubit,
                            DownloadedPodCastModel
                                .downloadedPodcastFiles[index].path,
                            currentId.toString(),
                            DownloadedPodCastModel.getPodcastID(index),
                            DownloadedPodCastModel.getPodcastName(index),
                            DownloadedPodCastModel?.getPodcastUserPublishInform(
                                index)['photo'],
                            context,
                            true),
                        currentPodcastDuration: cubit.isPlaying &&
                                DownloadedPodCastModel.getPodcastID(index) ==
                                    currentId &&
                                cubit.isLocalPodcastval
                            ? cubit.currentplayingDurathion
                            : cubit.pressedPause &&
                                    DownloadedPodCastModel.getPodcastID(
                                            index) ==
                                        currentId
                                ? cubit.currentplayingDurathion
                                : null,
                        podcasDuration: DownloadedPodCastModel.getPodCastAudio(
                            index)['duration'],
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
