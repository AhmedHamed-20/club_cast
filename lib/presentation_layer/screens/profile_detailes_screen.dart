import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/getMyPodCastModel.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsScreen extends StatelessWidget {
  String userId;
  ProfileDetailsScreen(this.userId);
  @override
  Widget build(BuildContext context) {
    String? currentId;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, index) {},
      builder: (context, index) {
        String token = CachHelper.getData(key: 'token');
        var cubit = GeneralAppCubit.get(context);
        currentId = cubit.activePodCastId;
        cubit.isProfilePage = true;
        return WillPopScope(
          onWillPop: () async {
            cubit.isProfilePage = false;
            Navigator.of(context).pop();
            print(cubit.isProfilePage);
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
                : SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage('${cubit.userId!.data!.photo}'),
                          radius: 75.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${cubit.userId!.data!.name}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 22.0,
                            ),
                      ),
                      const SizedBox(
                        height: 25.0,
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
                                  userProfileId: '${cubit.userId!.data!.id}');
                              navigatePushTo(
                                  context: context,
                                  navigateTo: FollowersScreen());
                            },
                            child: statusNumberProfile(
                              number: '${cubit.userId!.data!.followers}',
                              statusType: 'Followers',
                            ),
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          InkWell(
                            onTap: () {
                              cubit.userFollowing(
                                  userProfileId: '${cubit.userId!.data!.id}');
                              navigatePushTo(
                                  context: context,
                                  navigateTo: FollowingScreen());
                            },
                            child: statusNumberProfile(
                              number: '${cubit.userId!.data!.following}',
                              statusType: 'Following',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 17.0,
                      ),
                      cubit.userId!.data!.isFollowed ==true
                          ? Container(
                              width: 280.0,
                              height: 45.0,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  cubit.unFollowUser(userProfileId: '${cubit.userId!.data!.id}').then((value)
                                  {
                                    cubit.getUserById(profileId: '${cubit.userId!.data!.id}').then((value)
                                    {
                                      cubit.isLoadingprofile=false;
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
                          : Container(
                              width: 280.0,
                              height: 45.0,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  cubit.followUser(
                                      userProfileId:
                                          '${cubit.userId!.data!.id}').then((value)
                                  {
                                    cubit.getUserById(profileId: '${cubit.userId!.data!.id}').then((value)
                                    {
                                      cubit.isLoadingprofile=false;
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
                              'Your Podcasts',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0,
                                  ),
                            ),
                          ),
                          Container(
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
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return podACastItem(
                                        context,
                                        index: index,
                                        gettime:
                                            GetAllPodCastModel.getPodCastAudio(
                                                index)[0]?['duration'],
                                        text: cubit.isPlaying &&
                                                GetAllPodCastModel.getPodcastID(
                                                        index) ==
                                                    currentId
                                            ? cubit.currentOlayingDurathion
                                            : cubit.pressedPause &&
                                                    GetAllPodCastModel
                                                            .getPodcastID(
                                                                index) ==
                                                        currentId
                                                ? cubit.currentOlayingDurathion
                                                : null,
                                        likeWidget: PlayingCardWidget.likeState(
                                            context,
                                            GetAllPodCastModel
                                                ?.getPodcastlikeState(index),
                                            GetAllPodCastModel.getPodcastID(
                                                index),
                                            token,
                                            userId),
                                        podCastLikes:
                                            PlayingCardWidget.podCastLikes(
                                                context,
                                                cubit,
                                                token,
                                                index,
                                                GetAllPodCastModel.getPodcastID(
                                                    index),
                                                GetAllPodCastModel
                                                        .getPodcastLikes(index)
                                                    .toString()),
                                        downloadButton:
                                            PlayingCardWidget.downloadingWidget(
                                          currentId.toString(),
                                          index,
                                          GetAllPodCastModel.getPodcastID(
                                              index),
                                          cubit,
                                          context,
                                          GetAllPodCastModel.getPodCastAudio(
                                              index)[0]['url'],
                                          GetAllPodCastModel.getPodcastName(
                                              index),
                                        ),
                                        removePodCast: SizedBox(),
                                        photourl: GetAllPodCastModel
                                            .getPodcastUserPublishInform(
                                                index)[0]['photo'],
                                        podcastName:
                                            GetAllPodCastModel.getPodcastName(
                                                index),
                                        userName: GetAllPodCastModel
                                            .getPodcastUserPublishInform(
                                                index)[0]['name'],
                                        playingWidget:
                                            PlayingCardWidget.playingButton(
                                          index,
                                          cubit,
                                          GetAllPodCastModel.getPodCastAudio(
                                              index)[0]['url'],
                                          currentId.toString(),
                                          GetAllPodCastModel.getPodcastID(
                                              index),
                                          GetAllPodCastModel.getPodcastName(
                                              index),
                                          GetAllPodCastModel
                                              .getPodcastUserPublishInform(
                                                  index)[0]['photo'],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
          ),
        );
      },
    );
  }
}
