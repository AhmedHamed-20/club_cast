import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
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
                        children:
                        [
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                              NetworkImage('${GetUserModel.getUserPhoto()}'),
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
                            number: '0',
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
                        onPressed: () {},
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
                                itemCount: GetAllPodCastModel
                                    .getAllPodCast?['data'].length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return podACastItem(
                                    context,
                                    index: index,
                                    text: cubit.isPlaying &&
                                            GetAllPodCastModel.getPodcastID(
                                                    index) ==
                                                currentId
                                        ? cubit.currentOlayingDurathion
                                        : cubit.pressedPause &&
                                                GetAllPodCastModel.getPodcastID(
                                                        index) ==
                                                    currentId
                                            ? cubit.currentOlayingDurathion
                                            : null,
                                    downloadButton: IconButton(
                                      onPressed: () {
                                        currentId =
                                            GetAllPodCastModel.getPodcastID(
                                                index);
                                        cubit.downloadPodCast(
                                            GetAllPodCastModel.getPodCastAudio(
                                                index)[0]['url'],
                                            '${GetAllPodCastModel.getPodcastName(index)}.wav');
                                      },
                                      icon: cubit.isDownloading &&
                                              GetAllPodCastModel.getPodcastID(
                                                      index) ==
                                                  currentId
                                          ? CircularProgressIndicator(
                                              value: cubit.progress,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                              // color: Theme.of(context).primaryColor,
                                              backgroundColor: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.cloud_download_outlined,
                                              size: 35,
                                            ),
                                    ),
                                    removePodCast: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.clear,
                                        )),
                                    playingWidget: IconButton(
                                      onPressed: () {
                                        String podCastUrl =
                                            GetAllPodCastModel.getPodCastAudio(
                                                index)[0]['url'];

                                        cubit.isPlaying &&
                                                GetAllPodCastModel
                                                        .getPodcastID(index) ==
                                                    currentId
                                            ? cubit.assetsAudioPlayer
                                                .pause()
                                                .then((value) {
                                                cubit.isPlaying = false;
                                                cubit.pressedPause = true;
                                                cubit.changeState();
                                              })
                                            : cubit.playingPodcast(
                                                podCastUrl,
                                                GetAllPodCastModel
                                                    .getPodcastName(index),
                                                GetAllPodCastModel
                                                    .getPodcastUserPublishInform(
                                                        index)[0]['photo'],
                                                GetAllPodCastModel.getPodcastID(
                                                    index));
                                        print(
                                            GetAllPodCastModel.getPodCastAudio(
                                                index));
                                        print(currentId);
                                      },
                                      icon: Icon(
                                        cubit.isPlaying &&
                                                GetAllPodCastModel.getPodcastID(
                                                        index) ==
                                                    currentId
                                            ? Icons
                                                .pause_circle_outline_outlined
                                            : Icons
                                                .play_circle_outline_outlined,
                                        size: 35,
                                      ),
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
                ),
        );
      },
    );
  }
}
