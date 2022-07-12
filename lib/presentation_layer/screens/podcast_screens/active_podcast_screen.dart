import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/profile_detailes_screen.dart';
import 'package:club_cast/presentation_layer/widgets/extract_color_from_image.dart';
import 'package:club_cast/presentation_layer/widgets/driving_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../components/component/component.dart';

class ActivePodCastScreen extends StatelessWidget {
  int? index;
  double duration;
  String userPhoto;
  String userName;
  String podCastId;
  String podcastUrl;
  String podcastName;
  String userId;

  ActivePodCastScreen({
    this.index,
    required this.duration,
    required this.podCastId,
    required this.podcastName,
    required this.podcastUrl,
    required this.userName,
    required this.userPhoto,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit?.get(context);
    double time = duration;
    var hours = (time / (60 * 60)).floor();
    var minutes = ((time - hours * 60 * 60) / 60).floor();
    var second = ((time - hours * 60 * 60 - minutes * 60)).floor();
    String convertedTime =
        '${hours.toString()}:${minutes.toString()}:${second.toString()}';
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      builder: (context, state) {
        //   List<Color> sortedColors = GenerateColor.sortColors(extractedColors[0].color);
        return Scaffold(
          backgroundColor: GenerateColor.colors.isEmpty
              ? Theme.of(context).backgroundColor
              : GenerateColor.colors[0].color,
          appBar: AppBar(
            title: Text(
              userName,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: GenerateColor.colors.isEmpty
                      ? Theme.of(context).backgroundColor
                      : GenerateColor.colors[0].bodyTextColor),
            ),
            backgroundColor: GenerateColor.colors.isEmpty
                ? Theme.of(context).backgroundColor
                : GenerateColor.colors[0].color.withOpacity(0.5),
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: GenerateColor.colors.isEmpty
                    ? Theme.of(context).iconTheme.color
                    : GenerateColor.colors[0].bodyTextColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return drivingMode(
                        context: context,
                        podcastName: podcastName,
                        replayCallBack: () {
                          cubit.isPlaying && podCastId == cubit.activePodCastId
                              ? cubit.assetsAudioPlayer
                                  .seekBy(const Duration(seconds: -10))
                              : const SizedBox();
                        },
                        forwardCallBack: () {
                          cubit.isPlaying && podCastId == cubit.activePodCastId
                              ? cubit.assetsAudioPlayer
                                  .seekBy(const Duration(seconds: 10))
                              : const SizedBox();
                        },
                        playCallBack: () {
                          if (SocketFunc.isConnected) {
                            showToast(
                                message:
                                    "you can't play podcast if you in a room,leave first(:",
                                toastState: ToastState.WARNING);
                          } else {
                            String podCastUrl = podcastUrl;
                            cubit.isPlaying &&
                                    podCastId == cubit.activePodCastId
                                ? cubit.assetsAudioPlayer.pause().then(
                                    (value) {
                                      cubit.isPlaying = false;
                                      cubit.pressedPause = true;
                                      cubit.activePodCastId = podCastId;
                                      cubit.changeState();
                                    },
                                  )
                                : cubit.playingPodcast(podCastUrl, podcastName,
                                    userPhoto, podCastId, context);
                          }
                        },
                        cubit: cubit,
                        podCastId: podCastId,
                      );
                    },
                  );
                },
                icon: Icon(MdiIcons.car,
                    color: GenerateColor.colors.isEmpty
                        ? Theme.of(context).iconTheme.color
                        : GenerateColor.colors[0].bodyTextColor),
              )
            ],
          ),
          body: FutureBuilder(
            future: GenerateColor.extractColor(userPhoto, context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.01, 0.8],
                      colors: [
                        Theme.of(context).backgroundColor.withOpacity(0.8),
                        GenerateColor.colors[0].color.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (GetUserModel.getUserID() == userId) {
                                  cubit.getUserData(token: token);
                                  cubit.getMyPodCast(token, context);
                                  navigatePushTo(
                                      context: context,
                                      navigateTo: ProfileDetailsScreen(userId));
                                }

                                cubit.getUserById(
                                  profileId: userId,
                                  token: token,
                                );
                                cubit.getUserPodcast(token, userId);
                                navigatePushTo(
                                    context: context,
                                    navigateTo: ProfileDetailsScreen(userId));
                              },
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(userPhoto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Slider(
                            activeColor: GenerateColor.colors[0].bodyTextColor,
                            inactiveColor: GenerateColor.colors[0].bodyTextColor
                                .withOpacity(0.2),
                            value: podCastId == cubit.activePodCastId
                                ? cubit.currentPostionDurationInsec
                                : 0,
                            onChanged: (newval) {
                              cubit.pressedPause &&
                                      podCastId == cubit.activePodCastId
                                  ? const SizedBox()
                                  : podCastId == cubit.activePodCastId
                                      ? cubit.assetsAudioPlayer.seek(
                                          Duration(
                                            seconds: newval.toInt(),
                                          ),
                                        )
                                      : const SizedBox();
                            },
                            min: 0,
                            max: duration.toDouble(),
                          ),
                          Text(
                            cubit.isPlaying &&
                                    podCastId == cubit.activePodCastId
                                ? cubit.currentOlayingDurathion!
                                : cubit.pressedPause &&
                                        podCastId == cubit.activePodCastId
                                    ? cubit.currentOlayingDurathion!
                                    : convertedTime,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                right: 12,
                                top: 40,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    podcastName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
                                            color: GenerateColor
                                                .colors[0].bodyTextColor),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        onPressed: () {
                                          cubit.isPlaying &&
                                                  podCastId ==
                                                      cubit.activePodCastId
                                              ? cubit.assetsAudioPlayer.seekBy(
                                                  const Duration(seconds: -10))
                                              : const SizedBox();
                                        },
                                        child: Icon(
                                          Icons.replay_10,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          size:
                                              Theme.of(context).iconTheme.size,
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          onPressed: () {
                                            if (SocketFunc.isConnected) {
                                              showToast(
                                                  message:
                                                      "you can't play podcast if you in a room,leave first(:",
                                                  toastState:
                                                      ToastState.WARNING);
                                            } else {
                                              String podCastUrl = podcastUrl;
                                              cubit.isPlaying &&
                                                      podCastId ==
                                                          cubit.activePodCastId
                                                  ? cubit.assetsAudioPlayer
                                                      .pause()
                                                      .then((value) {
                                                      cubit.isPlaying = false;
                                                      cubit.pressedPause = true;
                                                      cubit.activePodCastId =
                                                          podCastId;
                                                      cubit.changeState();
                                                    })
                                                  : cubit.playingPodcast(
                                                      podCastUrl,
                                                      podcastName,
                                                      userPhoto,
                                                      podCastId,
                                                      context);
                                            }
                                          },
                                          child: Icon(
                                            cubit.isPlaying &&
                                                    podCastId ==
                                                        cubit.activePodCastId
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color:
                                                GenerateColor.colors[0].color,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        onPressed: () {
                                          cubit.isPlaying &&
                                                  podCastId ==
                                                      cubit.activePodCastId
                                              ? cubit.assetsAudioPlayer.seekBy(
                                                  const Duration(seconds: 10))
                                              : const SizedBox();
                                        },
                                        child: Icon(
                                          Icons.forward_10,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          size:
                                              Theme.of(context).iconTheme.size,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
            },
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
