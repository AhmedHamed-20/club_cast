import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/search_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_profile_screen.dart';
import 'package:club_cast/presentation_layer/widgets/alertDialog.dart';
import 'package:club_cast/presentation_layer/widgets/modelsheetcreate_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import '../../data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import '../components/component/component.dart';
import '../screens/user_screen/login_screen/login_screen.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = GeneralAppCubit.get(context);
          return Scaffold(
            bottomSheet: cubit.isPlaying || cubit.isPausedInHome
                ? Container(
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
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                    cubit.activepodcastPhotUrl.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: 25,
                            child: Marquee(
                              style: Theme.of(context).textTheme.bodyText1,
                              text: cubit.activePodcastname.toString(),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 5,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  cubit.isPlaying
                                      ? cubit.assetsAudioPlayer
                                          .seekBy(Duration(seconds: -10))
                                      : SizedBox();
                                },
                                icon: Icon(
                                  Icons.replay_10,
                                  color: Theme.of(context).iconTheme.color,
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
                                      ? Icons.pause_circle_outline_outlined
                                      : Icons.play_circle_outline_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.assetsAudioPlayer.stop().then((value) {
                                    cubit.isPlaying = false;
                                    cubit.isPausedInHome = false;
                                    cubit.changeState();
                                  });
                                },
                                icon: Icon(
                                  Icons.stop_circle_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.isPlaying
                                      ? cubit.assetsAudioPlayer
                                          .seekBy(Duration(seconds: 10))
                                      : SizedBox();
                                },
                                icon: Icon(
                                  Icons.forward_10,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            floatingActionButtonLocation:
                cubit.isPlaying || cubit.isPausedInHome
                    ? FloatingActionButtonLocation.centerTop
                    : FloatingActionButtonLocation.centerDocked,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                cubit.bottomNavIndex == 0 ? 'Rooms' : 'Podcasts',
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
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    cubit.getMyPodCast(token);
                    cubit.getUserData(token: token);
                    navigatePushTo(
                        context: context, navigateTo: UserProfileScreen());
                  },

                  child: Center(
                    child: GetUserModel.getUserPhoto() == null
                        ? CircularProgressIndicator(
                            strokeWidth: 1,
                          )
                        : Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image:
                                    NetworkImage(GetUserModel.getUserPhoto()!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  // userProfileImage(
                  //   size: 23,
                  //   // UserLoginModel.getUserPhoto()
                  //   image: 'assets/images/Adel.png',
                  // ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    cubit.toggleDark();
                  },
                  icon: Icon(
                    cubit.isDark! ? Icons.light_mode : Icons.dark_mode,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
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
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle:
                  TextStyle(color: Theme.of(context).primaryColor),
              items: cubit.bottomNavBarItem,
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).iconTheme.color,
              currentIndex: cubit.bottomNavIndex,
              onTap: (index) {
                cubit.changeBottomNAvIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modalBottomSheetItem(context, () {
                  if (formKey.currentState!.validate()) {
                    print(cubit.roomNameController.text);
                    print(cubit.selectedCategoryItem);
                    print("isPublicRoom :${cubit.isPublicRoom}");
                    print("isRecordRoom: ${cubit.isRecordRoom}");

                    SocketFunc.isConnected
                        ? const SizedBox()
                        : SocketFunc.connectWithSocket(context);
                    SocketFunc.createRoom({
                      'name': cubit.roomNameController.text,
                      'category': cubit.selectedCategoryItem,
                      'status': cubit.isPublicRoom ? 'public' : 'private',
                    }, context);
                    SocketFunc.isAdminLeftSocket();
                  }
                });
              },
              elevation: 15,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            body: cubit.screen[cubit.bottomNavIndex],
          );
        });
  }
}
