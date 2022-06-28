import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/widgets/model_sheet_room_contant.dart';
import 'package:flutter/material.dart';
import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import '../../data_layer/bloc/room_cubit/room_cubit.dart';
import '../components/component/component.dart';
import '../components/constant/constant.dart';
import '../models/user_model.dart';
import '../screens/user_screen/other_users_screens/profile_detailes_screen.dart';

Widget speakersWiget({
  required cubit,
  required bool isAdmin,
}) {
  return Row(
    children: [
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cubit.speakers.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                GetUserModel.getUserID() !=
                        RoomCubit.get(context).speakers[index]['_id']
                    ? showModalBottomSheet(
                        backgroundColor: Theme.of(context).backgroundColor,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        context: context,
                        builder: (context) {
                          return WidgetFunc.bottomSheetContant(
                            context,
                            cubit.speakers[index]['name'],
                            cubit.speakers[index]['photo'],
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isAdmin
                                    ? Card(
                                        elevation: 3,
                                        color: Theme.of(context).primaryColor,
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
                                            SocketFunc
                                                .adminReturnUserBackToAudienc(
                                                    RoomCubit.get(context)
                                                        .speakers[index]);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Make Him Listener',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                        ),
                                      )
                                    : const SizedBox(),
                                Card(
                                  elevation: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onPressed: () {
                                      GeneralAppCubit.get(context).getUserById(
                                          profileId: cubit.speakers[index]
                                              ['_id'],
                                          token: token);

                                      GeneralAppCubit.get(context)
                                          .getUserPodcast(token,
                                              cubit.speakers[index]['_id'])
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        navigatePushTo(
                                            context: context,
                                            navigateTo: ProfileDetailsScreen(
                                                cubit.speakers[index]['_id']));
                                      });
                                    },
                                    child: Text(
                                      'View profile',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: MaterialButton(
                                    onPressed: () {
                                      cubit.speakers[index]['iMuteHim']
                                          ? AgoraRtc.muteSomeone(
                                                  cubit.speakers[index]['uid'],
                                                  false)
                                              .then((value) {
                                              cubit.speakers[index]
                                                  ['iMuteHim'] = false;
                                              Navigator.of(context).pop();
                                            })
                                          : AgoraRtc.muteSomeone(
                                                  cubit.speakers[index]['uid'],
                                                  true)
                                              .then((value) {
                                              cubit.speakers[index]
                                                  ['iMuteHim'] = true;
                                              Navigator.of(context).pop();
                                            });

                                      cubit.changeState();
                                    },
                                    child: Text(
                                      cubit.speakers[index]['iMuteHim']
                                          ? 'unMute'
                                          : 'Mute',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                width: RoomCubit.get(context).speakers == []
                                    ? 0
                                    : cubit.speakers[index]?['isTalking']
                                        ? 3.0
                                        : 0,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  cubit.speakers[index]['photo'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cubit.speakers[index]['name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  cubit.speakers == []
                      ? const SizedBox()
                      : cubit.speakers[index]?['isMuted']
                          ? Positioned(
                              top: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 15,
                                child: Icon(
                                  Icons.mic_off,
                                  size: 19,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            )
                          : const SizedBox(),
                ],
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100),
        ),
      ),
    ],
  );
}
