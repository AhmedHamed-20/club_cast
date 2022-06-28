import 'dart:typed_data';

import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/following_screen.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pod_cast_card_item.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/extract_color_from_image.dart';

class ProfileDetailsScreen extends StatelessWidget {
  String userId;
  ProfileDetailsScreen(this.userId);
  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);

    cubit.isProfilePage = true;

    String? currentId;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, index) {},
      builder: (context, index) {
        String token = CachHelper.getData(key: 'token');
        refresh() {
          cubit.getUserById(profileId: userId, token: token);
          return cubit.getUserPodcast(token, userId);
        }

        currentId = cubit.activePodCastId;

        return WillPopScope(
          onWillPop: () async {
            cubit.isProfilePage = false;
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  cubit.isProfilePage = false;

                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              title: Text(
                'Profile Details',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: cubit.isLoadingprofile
                ? Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ))
                : RefreshIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                    color: Theme.of(context).primaryColor,
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${cubit.userId?.data?.photo}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${cubit.userId?.data?.name}',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0,
                                  ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          width: 260.0,
                          child: Column(
                            children: [
                              cubit.userId?.data?.bio == null
                                  ? const SizedBox()
                                  : Text(
                                      '${cubit.userId?.data?.bio}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.grey,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            statusNumberProfile(
                              number: GetAllPodCastModel?.getPodCastcount()
                                  .toString(),
                              statusType: 'Podcasts',
                            ),
                            const SizedBox(
                              width: 22.0,
                            ),
                            InkWell(
                              onTap: () {
                                cubit.userFollowers(
                                    userProfileId: '${cubit.userId?.data?.id}',
                                    token: token);
                                navigatePushTo(
                                    context: context,
                                    navigateTo: const FollowersScreen());
                              },
                              child: statusNumberProfile(
                                number: '${cubit.userId?.data?.followers}',
                                statusType: 'Followers',
                              ),
                            ),
                            const SizedBox(
                              width: 22.0,
                            ),
                            InkWell(
                              onTap: () {
                                cubit.userFollowing(
                                    userProfileId: '${cubit.userId?.data?.id}',
                                    token: token);
                                navigatePushTo(
                                    context: context,
                                    navigateTo: const FollowingScreen());
                              },
                              child: statusNumberProfile(
                                number: '${cubit.userId?.data?.following}',
                                statusType: 'Following',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 17.0,
                        ),
                        cubit.userId?.data?.isFollowed == true
                            ? SizedBox(
                                width: 280.0,
                                height: 45.0,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () {
                                    cubit
                                        .unFollowUser(
                                            userProfileId:
                                                '${cubit.userId?.data?.id}',
                                            token: token,
                                            context: context)
                                        .then((value) {
                                      cubit.getMyFollowingPodcast(
                                          token, context);
                                      cubit
                                          .getUserById(
                                              profileId:
                                                  '${cubit.userId?.data?.id}',
                                              token: token)
                                          .then((value) {
                                        cubit.isLoadingprofile = false;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'UnFollow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : SizedBox(
                                width: 280.0,
                                height: 45.0,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () {
                                    cubit
                                        .followUser(
                                            userProfileId:
                                                '${cubit.userId?.data?.id}',
                                            token: token,
                                            context: context)
                                        .then((value) {
                                      cubit.getMyFollowingPodcast(
                                          token, context);
                                      cubit
                                          .getUserById(
                                              profileId:
                                                  '${cubit.userId?.data?.id}',
                                              token: token)
                                          .then((value) {
                                        cubit.isLoadingprofile = false;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              width: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Podcasts',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.0,
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  bottom: 10,
                                  right: 15,
                                  top: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    ListView.builder(
                                      itemCount: GetAllPodCastModel
                                          .getAllPodCast?['data'].length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            GenerateColor.colors = [];
                                            navigatePushTo(
                                                context: context,
                                                navigateTo: ActivePodCastScreen(
                                                  duration: GetAllPodCastModel
                                                      .getPodCastAudio(
                                                          index)[0]['duration'],
                                                  podCastId: GetAllPodCastModel
                                                      .getPodcastID(index),
                                                  podcastName:
                                                      GetAllPodCastModel
                                                          .getPodcastName(
                                                              index),
                                                  podcastUrl: GetAllPodCastModel
                                                      .getPodCastAudio(
                                                          index)[0]['url'],
                                                  userName: GetAllPodCastModel
                                                      .getPodcastUserPublishInform(
                                                          index)[0]['name'],
                                                  userPhoto: GetAllPodCastModel
                                                      .getPodcastUserPublishInform(
                                                          index)[0]['photo'],
                                                  index: index,
                                                  userId: GetAllPodCastModel
                                                      .getPodcastUserPublishInform(
                                                          index)[0]['_id'],
                                                ));
                                          },
                                          child: podACastItem(
                                            context,
                                            index: index,
                                            gettime: GetAllPodCastModel
                                                    .getPodCastAudio(index)[0]
                                                ?['duration'],
                                            text: cubit.isPlaying &&
                                                    GetAllPodCastModel
                                                            .getPodcastID(
                                                                index) ==
                                                        currentId
                                                ? cubit.currentOlayingDurathion
                                                : cubit.pressedPause &&
                                                        GetAllPodCastModel
                                                                .getPodcastID(
                                                                    index) ==
                                                            currentId
                                                    ? cubit
                                                        .currentOlayingDurathion
                                                    : null,
                                            likeWidget:
                                                PlayingCardWidget.likeState(
                                                    context,
                                                    GetAllPodCastModel
                                                        ?.getPodcastlikeState(
                                                            index),
                                                    GetAllPodCastModel
                                                        .getPodcastID(index),
                                                    token,
                                                    userId),
                                            podCastLikes:
                                                PlayingCardWidget.podCastLikes(
                                                    context,
                                                    cubit,
                                                    token,
                                                    index,
                                                    GetAllPodCastModel
                                                        .getPodcastID(index),
                                                    GetAllPodCastModel
                                                            .getPodcastLikes(
                                                                index)
                                                        .toString()),
                                            downloadButton: PlayingCardWidget
                                                .downloadingWidget(
                                              currentId.toString(),
                                              index,
                                              GetAllPodCastModel.getPodcastID(
                                                  index),
                                              cubit,
                                              context,
                                              GetAllPodCastModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              GetAllPodCastModel.getPodcastName(
                                                  index),
                                            ),
                                            removePodCast: const SizedBox(),
                                            photourl: GetAllPodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['photo'],
                                            podcastName: GetAllPodCastModel
                                                .getPodcastName(index),
                                            userName: GetAllPodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['name'],
                                            playingWidget:
                                                PlayingCardWidget.playingButton(
                                                    index,
                                                    cubit,
                                                    GetAllPodCastModel
                                                        .getPodCastAudio(
                                                            index)[0]['url'],
                                                    currentId.toString(),
                                                    GetAllPodCastModel
                                                        .getPodcastID(index),
                                                    GetAllPodCastModel
                                                        .getPodcastName(index),
                                                    GetAllPodCastModel
                                                        .getPodcastUserPublishInform(
                                                            index)[0]['photo'],
                                                    context),
                                          ),
                                        );
                                      },
                                    ),
                                    cubit.noDataUserPodcasts
                                        ? const SizedBox()
                                        : InkWell(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            onTap: () {
                                              cubit.paginationUserPodcasts(
                                                  token,
                                                  '${cubit.userId!.data!.id}');
                                            },
                                            child: Center(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .backgroundColor,
                                                radius: 30,
                                                child: cubit.loadUserPodcasts
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
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
