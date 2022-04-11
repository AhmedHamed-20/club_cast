import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/explore_podcasts_model.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/profile_detailes_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_profile_screen.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/constant/constant.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit?.get(context);
    String? currentId;
    currentId = cubit.activePodCastId;
    refresh() {
      return cubit.getExplorePodcast(token: token);
    }

    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          String token = CachHelper.getData(key: 'token');
          cubit.isExplore = true;
          return WillPopScope(
            onWillPop: () async {
              cubit.isExplore = false;
              Navigator.of(context).pop();
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Explore',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    cubit.isExplore = false;
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: cubit.loadingExplore
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RefreshIndicator(
                        backgroundColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).primaryColor,
                        onRefresh: refresh,
                        child: SingleChildScrollView(
                          //     physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                addAutomaticKeepAlives: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: GetExplorePodCastModel
                                    .getExplorePodCast?['data'].length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      navigatePushTo(
                                          context: context,
                                          navigateTo: ActivePodCastScreen(
                                            duration: GetExplorePodCastModel
                                                    .getPodCastAudio(index)[0]
                                                ['duration'],
                                            podCastId: GetExplorePodCastModel
                                                .getPodcastID(index),
                                            podcastName: GetExplorePodCastModel
                                                .getPodcastName(index),
                                            podcastUrl: GetExplorePodCastModel
                                                    .getPodCastAudio(index)[0]
                                                ['url'],
                                            userName: GetExplorePodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['name'],
                                            userPhoto: GetExplorePodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['photo'],
                                            index: index,
                                          ));
                                    },
                                    child: podACastItem(
                                      context,
                                      index: index,
                                      downloadButton:
                                          PlayingCardWidget.downloadingWidget(
                                              cubit.downloadedPodCastId
                                                  .toString(),
                                              index,
                                              GetExplorePodCastModel
                                                  .getPodcastID(index),
                                              cubit,
                                              context,
                                              GetExplorePodCastModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              GetExplorePodCastModel
                                                  .getPodcastName(index)),
                                      likeWidget: PlayingCardWidget.likeState(
                                        context,
                                        GetExplorePodCastModel
                                            .getPodcastlikeState(index),
                                        GetExplorePodCastModel.getPodcastID(
                                            index),
                                        token,
                                        '',
                                      ),
                                      podCastLikes:
                                          PlayingCardWidget.podCastLikes(
                                              context,
                                              cubit,
                                              token,
                                              index,
                                              GetExplorePodCastModel
                                                  .getPodcastID(index),
                                              GetExplorePodCastModel
                                                      .getPodcastLikes(index)
                                                  .toString()),
                                      removePodCast: SizedBox(),
                                      playingWidget:
                                          PlayingCardWidget.playingButton(
                                              index,
                                              cubit,
                                              GetExplorePodCastModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              cubit.activePodCastId.toString(),
                                              GetExplorePodCastModel
                                                  .getPodcastID(index),
                                              GetExplorePodCastModel
                                                  .getPodcastName(index),
                                              GetExplorePodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['photo'],
                                              context),
                                      gettime: GetExplorePodCastModel
                                              .getPodCastAudio(index)[0]
                                          ['duration'],
                                      photourl: GetExplorePodCastModel
                                          .getPodcastUserPublishInform(
                                              index)[0]['photo'],
                                      ontapOnCircleAvater: () {
                                        if (GetUserModel.getUserID() ==
                                            GetExplorePodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['_id']) {
                                          cubit.getUserById(
                                              profileId: GetExplorePodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['_id'],
                                          token: token);
                                          cubit.getMyPodCast(
                                            token,
                                          );
                                          navigatePushTo(
                                              context: context,
                                              navigateTo: UserProfileScreen());
                                        } else {
                                          cubit.getUserById(
                                              profileId: GetExplorePodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['_id'],
                                          token: token);
                                          cubit.getUserPodcast(
                                              token,
                                              GetExplorePodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['_id']);
                                          navigatePushTo(
                                              context: context,
                                              navigateTo: ProfileDetailsScreen(
                                                  GetExplorePodCastModel
                                                      .getPodcastUserPublishInform(
                                                          index)[0]['_id']));
                                        }
                                      },
                                      podcastName:
                                          GetExplorePodCastModel.getPodcastName(
                                              index),
                                      userName: GetExplorePodCastModel
                                          .getPodcastUserPublishInform(
                                              index)[0]['name'],
                                      text: cubit.isPlaying &&
                                              GetExplorePodCastModel
                                                      .getPodcastID(index) ==
                                                  cubit.activePodCastId
                                          ? cubit.currentOlayingDurathion
                                          : cubit.pressedPause &&
                                                  GetExplorePodCastModel
                                                          .getPodcastID(
                                                              index) ==
                                                      cubit.activePodCastId
                                              ? cubit.currentOlayingDurathion
                                              : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              cubit.noDataExplore
                                  ? const SizedBox()
                                  : InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      onTap: () {
                                        cubit.pageinathionExplore(
                                          token,
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        radius: 30,
                                        child: cubit.loadExplore
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
                        ),
                      ),
                    ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
