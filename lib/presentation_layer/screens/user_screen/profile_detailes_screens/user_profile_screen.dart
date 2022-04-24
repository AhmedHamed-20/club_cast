import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/getMyPodCastModel.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/get_my_events.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/profile_detailes_screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/following_screen.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/uploadPodcastScreen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/event_screen/event_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:club_cast/presentation_layer/widgets/alertDialog.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pod_cast_card_item.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/podcastLikesScreen.dart';
import '../../../components/constant/constant.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);
    String? currentId;
    cubit.isMyfollowingScreen = false;
    cubit.isMyprofileScreen = true;
    print(cubit.isMyfollowingScreen);
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, index) {},
      builder: (context, index) {
        String token = CachHelper.getData(key: 'token');
        refresh() {
          cubit.getUserData(token: token);
          return cubit.getMyPodCast(token, context);
        }

        currentId = cubit.activePodCastId;
        return WillPopScope(
          onWillPop: () async {
            cubit.isMyprofileScreen = false;
            Navigator.of(context).pop();
            print(cubit.isMyprofileScreen);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return alertDialog(
                              context: context,
                              title: 'Are You Sure',
                              content: Text(
                                'Logout?',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              yesFunction: () {
                                CachHelper.deleteData(
                                  'token',
                                ).then((value) {
                                  if (value) {
                                    cubit.assetsAudioPlayer.stop();
                                    navigatePushANDRemoveRout(
                                        context: context,
                                        navigateTo: LoginScreen());
                                  }
                                }).then((value) {
                                  token = '';
                                  cubit.isPlaying = false;
                                  cubit.isPausedInHome = false;
                                  GeneralAppCubit.get(context).search = null;
                                  cubit.currentOlayingDurathion = null;
                                  cubit.activePodCastId = null;
                                  cubit.currentPostionDurationInsec = 0;
                                });
                              },
                              noFunction: () {
                                Navigator.of(context).pop();
                              });
                        });
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  cubit.isMyprofileScreen = false;
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
                : RefreshIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                    color: Theme.of(context).primaryColor,
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '${GetUserModel.getUserPhoto()}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            GetUserModel.getUserName(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.0,
                                    ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Container(
                            width: 260.0,
                            child: Column(
                              children: [
                                GetUserModel.getUserBio() == null
                                    ? const SizedBox()
                                    : Text(
                                        '${GetUserModel.getUserBio()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              statusNumberProfile(
                                number:
                                    '${GetMyPodCastModel.getPodCastcount()}',
                                statusType: 'Podcasts',
                              ),
                              const SizedBox(
                                width: 22.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  cubit.getMyFollowers(token: token);
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
                                  cubit.getMyFollowing(token: token);
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
                          const SizedBox(
                            height: 20,
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
                          defaultButton(
                            onPressed: () {
                              navigatePushTo(
                                context: context,
                                navigateTo: EventScreen(),
                              );
                            },
                            context: context,
                            height: 45,
                            width: 280,
                            text: 'My Events',
                            radius: 8,
                          ),
                          const SizedBox(
                            height: 20.0,
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
                                    itemCount: GetMyPodCastModel
                                        .getMyPodCast?['data'].length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          navigatePushTo(
                                            context: context,
                                            navigateTo: ActivePodCastScreen(
                                              duration: GetMyPodCastModel
                                                      .getPodCastAudio(index)[0]
                                                  ['duration'],
                                              podCastId: GetMyPodCastModel
                                                  .getPodcastID(index),
                                              podcastName: GetMyPodCastModel
                                                  .getPodcastName(index),
                                              podcastUrl: GetMyPodCastModel
                                                      .getPodCastAudio(index)[0]
                                                  ['url'],
                                              userName: GetMyPodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['name'],
                                              userPhoto: GetMyPodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['photo'],
                                              index: index,
                                              userId: GetMyPodCastModel
                                                  .getPodcastUserPublishInform(
                                                      index)[0]['_id'],
                                            ),
                                          );
                                        },
                                        child: podACastItem(
                                          context,
                                          index: index,
                                          gettime:
                                              GetMyPodCastModel.getPodCastAudio(
                                                  index)[0]?['duration'],
                                          text: cubit.isPlaying &&
                                                  GetMyPodCastModel
                                                          .getPodcastID(
                                                              index) ==
                                                      currentId
                                              ? cubit.currentOlayingDurathion
                                              : cubit.pressedPause &&
                                                      GetMyPodCastModel
                                                              ?.getPodcastID(
                                                                  index) ==
                                                          currentId
                                                  ? cubit
                                                      .currentOlayingDurathion
                                                  : null,
                                          downloadButton: PlayingCardWidget
                                              .downloadingWidget(
                                            currentId.toString(),
                                            index,
                                            GetMyPodCastModel?.getPodcastID(
                                                index),
                                            cubit,
                                            context,
                                            GetMyPodCastModel?.getPodCastAudio(
                                                index)[0]['url'],
                                            GetMyPodCastModel?.getPodcastName(
                                                index),
                                          ),
                                          removePodCast: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return alertDialog(
                                                          context: context,
                                                          content: Text(
                                                            'delete ${GetMyPodCastModel.getPodcastName(index)} podcast?',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                          title: 'Are You Sure',
                                                          yesFunction: () {
                                                            cubit
                                                                .assetsAudioPlayer
                                                                .stop();
                                                            cubit.currentOlayingDurathion =
                                                                null;
                                                            cubit.activePodCastId =
                                                                null;
                                                            cubit
                                                                .removePodCast(
                                                                    GetMyPodCastModel
                                                                        .getPodcastID(
                                                                            index),
                                                                    token,
                                                                    context)
                                                                .then((value) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          noFunction: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              )),
                                          photourl: GetMyPodCastModel
                                              .getPodcastUserPublishInform(
                                                  index)[0]['photo'],
                                          podcastName:
                                              GetMyPodCastModel.getPodcastName(
                                                  index),
                                          userName: GetMyPodCastModel
                                              .getPodcastUserPublishInform(
                                                  index)[0]['name'],
                                          podCastLikes:
                                              PlayingCardWidget.podCastLikes(
                                                  context,
                                                  cubit,
                                                  token,
                                                  index,
                                                  GetMyPodCastModel
                                                      .getPodcastID(index),
                                                  GetMyPodCastModel
                                                          .getPodcastLikes(
                                                              index)
                                                      .toString()),
                                          likeWidget:
                                              PlayingCardWidget.likeState(
                                                  context,
                                                  GetMyPodCastModel
                                                      .getPodcastlikeState(
                                                          index),
                                                  GetMyPodCastModel
                                                      .getPodcastID(index),
                                                  token,
                                                  ''),
                                          playingWidget:
                                              PlayingCardWidget.playingButton(
                                                  index,
                                                  cubit,
                                                  GetMyPodCastModel
                                                      .getPodCastAudio(
                                                          index)[0]['url'],
                                                  currentId.toString(),
                                                  GetMyPodCastModel
                                                      .getPodcastID(index),
                                                  GetMyPodCastModel
                                                      .getPodcastName(index),
                                                  GetMyPodCastModel
                                                      .getPodcastUserPublishInform(
                                                          index)[0]['photo'],
                                                  context),
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
                  ),
          ),
        );
      },
    );
  }
}
