import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_screen.dart';
import 'package:club_cast/presentation_layer/screens/search/search_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/profile_detailes_screens/user_profile_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/event_screen/get_all_my_following_events.dart';
import 'package:club_cast/presentation_layer/widgets/modelsheetcreate_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:move_to_background/move_to_background.dart';
import '../../data_layer/agora/rtc_engine.dart';
import '../../data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import '../components/component/component.dart';
import '../models/activeRoomModelUser.dart';
import '../screens/user_screen/login_screen/login_screen.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var roomCubit = RoomCubit.get(context);
          var cubit = GeneralAppCubit.get(context);

          String token = CachHelper.getData(key: 'token');
          return WillPopScope(
            onWillPop: () async {
              if (cubit.bottomNavIndex == 0) {
                await MoveToBackground.moveTaskToBack();

                return false;
              } else {
                cubit.changeBottomNAvIndex(0);
                return false;
              }
            },
            child: Scaffold(
              bottomSheet: cubit.isPlaying ||
                      cubit.isPausedInHome ||
                      SocketFunc.isConnected
                  ? SocketFunc.isConnected
                      ? GestureDetector(
                          onTap: () {
                            if (currentUserRoleinRoom) {
                              navigatePushTo(
                                  context: context,
                                  navigateTo: const RoomAdminViewScreen());
                            } else {
                              navigatePushTo(
                                  context: context,
                                  navigateTo: const RoomUserViewScreen());
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Active room: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          activeRoomName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SocketFunc.iamSpeaker
                                      ? IconButton(
                                          icon: Icon(
                                            AgoraRtc.muted
                                                ? Icons.mic_off
                                                : Icons.mic_none,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            currentUserRoleinRoom == false
                                                ? {
                                                    for (int i = 0;
                                                        i <
                                                            RoomCubit.get(
                                                                    context)
                                                                .speakers
                                                                .length;
                                                        i++)
                                                      {
                                                        if (ActiveRoomUserModel
                                                                .getUserId() ==
                                                            RoomCubit.get(
                                                                        context)
                                                                    .speakers[i]
                                                                ['_id'])
                                                          {
                                                            AgoraRtc
                                                                .onToggleMute(
                                                                    i, context),
                                                          },
                                                      },
                                                  }
                                                : AgoraRtc.onToggleMute(
                                                    0, context);
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      cubit.activepodcastPhotUrl.toString()),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    child: Marquee(
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      text: cubit.activePodcastname.toString(),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 5,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cubit.isPlaying
                                            ? cubit.assetsAudioPlayer.seekBy(
                                                const Duration(seconds: -10))
                                            : const SizedBox();
                                      },
                                      icon: Icon(
                                        Icons.replay_10,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.isPlaying
                                            ? cubit.assetsAudioPlayer
                                                .pause()
                                                .then((value) {
                                                cubit.isPlaying = false;
                                                cubit.isPausedInHome = true;
                                                cubit.changeState();
                                              })
                                            : cubit.assetsAudioPlayer
                                                .play()
                                                .then((value) {
                                                cubit.isPlaying = true;
                                                cubit.isPausedInHome = false;
                                                cubit.changeState();
                                              });
                                      },
                                      icon: Icon(
                                        cubit.isPlaying
                                            ? Icons
                                                .pause_circle_outline_outlined
                                            : Icons
                                                .play_circle_outline_outlined,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.assetsAudioPlayer
                                            .stop()
                                            .then((value) {
                                          cubit.isPlaying = false;
                                          cubit.isPausedInHome = false;
                                          cubit.changeState();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.stop_circle_outlined,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.isPlaying
                                            ? cubit.assetsAudioPlayer.seekBy(
                                                const Duration(seconds: 10))
                                            : const SizedBox();
                                      },
                                      icon: Icon(
                                        Icons.forward_10,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                  : const SizedBox(),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  cubit.bottomNavIndex == 0
                      ? 'Rooms'
                      : cubit.bottomNavIndex == 1
                          ? 'Create room'
                          : 'Podcasts',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 25),
                ),
                actions: [
                  IconButton(
                    splashRadius: 30,
                    onPressed: () {
                      navigatePushTo(
                          context: context, navigateTo: SearchScreen());
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  IconButton(
                    splashRadius: 30,
                    onPressed: () {
                      navigatePushTo(
                        context: context,
                        navigateTo: GetAllMyFollowingScreen(),
                      );
                    },
                    icon: Icon(
                      Icons.add_alert_outlined,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      cubit.toggleDark();
                    },
                    icon: Icon(
                      cubit.isDark! ? Icons.light_mode : Icons.dark_mode,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      cubit.getMyPodCast(token, context);
                      cubit.getUserData(token: token);
                      navigatePushTo(
                          context: context,
                          navigateTo: const UserProfileScreen());
                    },
                    child: Center(
                      child: GetUserModel.getUserPhoto() == null
                          ? CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Theme.of(context).primaryColor,
                            )
                          : Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      GetUserModel.getUserPhoto()!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: cubit.bottomNavBarItem,
                backgroundColor: Theme.of(context).backgroundColor,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Theme.of(context).iconTheme.color,
                currentIndex: cubit.bottomNavIndex,
                onTap: (index) {
                  if (index == 1) {
                    if (cubit.isPlaying) {
                      showToast(
                          message:
                              "you can't create room if you playing a podcast,leave first(:",
                          toastState: ToastState.WARNING);
                      return;
                    } else {
                      modalBottomSheetItem(context, () {
                        cubit.loadRoom = true;
                        cubit.changeState();
                        cubit.micPerm();

                        SocketFunc.isConnected
                            ? const SizedBox()
                            : SocketFunc.connectWithSocket(
                                context,
                                RoomCubit.get(context),
                                GeneralAppCubit.get(context));
                        SocketFunc.createRoom(
                          {
                            'name': cubit.roomNameController.text,
                            'category': cubit.selectedCategoryItem,
                            'status': cubit.isPublicRoom ? 'public' : 'private',
                            'isRecording': cubit.isRecordRoom,
                          },
                          context,
                          roomCubit,
                          cubit,
                        );
                        SocketFunc.isAdminLeftSocket(cubit);
                      });
                      return;
                    }
                  }
                  cubit.changeBottomNAvIndex(index);
                },
              ),
              body: cubit.screen[cubit.bottomNavIndex],
            ),
          );
        });
  }
}
