import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/getMyPodCastModel.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
import 'package:club_cast/presentation_layer/screens/uploadPodcastScreen.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentId;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, index) {},
      builder: (context, index) {
        var cubit = GeneralAppCubit.get(context);
        currentId = cubit.activePodCastId;
        String token = CachHelper.getData(key: 'token');
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title: Text(
              'Your Profile Details',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: cubit.isLoadProfile
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  '${GetUserModel.getUserPhoto()}'),
                              radius: 75.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${GetUserModel.getUserName()}',
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
                            number: '${GetMyPodCastModel.getPodCastcount()}',
                            statusType: 'Podcasts',
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatePushTo(
                                context: context,
                                navigateTo: FollowersScreen(),
                              );
                            },
                            child: statusNumberProfile(
                              number: '${GetUserModel.getUserFollowers()}',
                              statusType: 'Followers',
                            ),
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatePushTo(
                                context: context,
                                navigateTo: FollowingScreen(),
                              );
                            },
                            child: statusNumberProfile(
                              number: '${GetUserModel.getUserFollowing()}',
                              statusType: 'Following',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 17.0,
                      ),
                      defaultButton(
                        onPressed: () {
                          navigatePushTo(
                              context: context,
                              navigateTo: EditUserProfileScreen());
                        },
                        context: context,
                        height: 45,
                        width: 280,
                        text: 'Edit',
                        radius: 8,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                        onPressed: () {
                          navigatePushTo(
                              context: context,
                              navigateTo: UploadPodCastScreen());
                        },
                        context: context,
                        height: 45,
                        width: 280,
                        text: 'Upload Podcast',
                        radius: 8,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Your Podcasts',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
                                itemCount: GetMyPodCastModel
                                    .getMyPodCast?['data'].length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return podACastItem(
                                    context,
                                    index: index,
                                    gettime: GetMyPodCastModel.getPodCastAudio(
                                        index)[0]?['duration'],
                                    text: cubit.isPlaying &&
                                            GetMyPodCastModel.getPodcastID(
                                                    index) ==
                                                currentId
                                        ? cubit.currentOlayingDurathion
                                        : cubit.pressedPause &&
                                                GetMyPodCastModel?.getPodcastID(
                                                        index) ==
                                                    currentId
                                            ? cubit.currentOlayingDurathion
                                            : null,
                                    downloadButton:
                                        PlayingCardWidget.downloadingWidget(
                                      currentId.toString(),
                                      index,
                                      GetMyPodCastModel?.getPodcastID(index),
                                      cubit,
                                      context,
                                      GetMyPodCastModel?.getPodCastAudio(
                                          index)[0]['url'],
                                      GetMyPodCastModel?.getPodcastName(index),
                                    ),
                                    removePodCast: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .backgroundColor,
                                                  title: Text(
                                                    'Are You Sure',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                  content: Text(
                                                    'delete ${GetMyPodCastModel.getPodcastName(index)} podcast?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        MaterialButton(
                                                          onPressed: () {
                                                            // print(GetMyPodCastModel
                                                            //     .getPodcastID(
                                                            //         index));
                                                            cubit
                                                                .removePodCast(
                                                                    GetMyPodCastModel
                                                                        .getPodcastID(
                                                                            index),
                                                                    token)
                                                                .then((value) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Text(
                                                            'Yes',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'No',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                        )),
                                    photourl: GetMyPodCastModel
                                        .getPodcastUserPublishInform(
                                            index)[0]['photo'],
                                    podcastName:
                                        GetMyPodCastModel.getPodcastName(index),
                                    userName: GetMyPodCastModel
                                        .getPodcastUserPublishInform(
                                            index)[0]['name'],
                                    podCastLikes:
                                        PlayingCardWidget.podCastLikes(
                                            context,
                                            cubit,
                                            token,
                                            index,
                                            GetMyPodCastModel.getPodcastID(
                                                index),
                                            GetMyPodCastModel.getPodcastLikes(
                                                    index)
                                                .toString()),
                                    likeWidget: PlayingCardWidget.likeState(
                                        context,
                                        GetMyPodCastModel.getPodcastlikeState(
                                            index),
                                        cubit,
                                        GetMyPodCastModel.getPodcastID(index),
                                        token,
                                        cubit.getMyPodCast(token)),
                                    playingWidget:
                                        PlayingCardWidget.playingButton(
                                            index,
                                            cubit,
                                            GetMyPodCastModel.getPodCastAudio(
                                                index)[0]['url'],
                                            currentId.toString(),
                                            GetMyPodCastModel.getPodcastID(
                                                index),
                                            GetMyPodCastModel.getPodcastName(
                                                index),
                                            GetMyPodCastModel
                                                .getPodcastUserPublishInform(
                                                    index)[0]['photo']),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
