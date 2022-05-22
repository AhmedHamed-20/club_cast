import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/notification/local_notification.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/getAllRoomsModel.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_screen.dart';
import 'package:club_cast/presentation_layer/widgets/event_card_item.dart';
import 'package:club_cast/presentation_layer/widgets/public_room_card_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/cash/cash.dart';
import '../../models/getMyFollowingEvents.dart';
import '../../widgets/multi_use_dialog.dart';

class PublicRoomScreen extends StatelessWidget {
  const PublicRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GeneralAppCubit?.get(context);
        var roomCubit = RoomCubit.get(context);
        refresh() {
          cubit.getMyFollowingEvents(context);

          return cubit.getAllRoomsData(context);
        }

        return GetMyFollowingEvents.data != null
            ? RefreshIndicator(
                backgroundColor: Theme.of(context).backgroundColor,
                color: Theme.of(context).primaryColor,
                onRefresh: refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetMyFollowingEvents.allEvent().isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Text(
                                      'UPCOMING EVENTS ~~~~~~',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.27,
                                    child: eventCardItem(
                                      context: context,
                                      index: 0,
                                      userWhoCreateEventId: GetMyFollowingEvents
                                          .userWhoCreateEvent(0)["_id"],
                                      userName: GetMyFollowingEvents
                                          .userWhoCreateEvent(0)["name"],
                                      userUrl: GetMyFollowingEvents
                                          .userWhoCreateEvent(0)['photo'],
                                      eventDescription:
                                          GetMyFollowingEvents.eventDescription(
                                              0),
                                      eventName:
                                          GetMyFollowingEvents.eventName(0),
                                      eventDate: DateTime.parse(
                                              GetMyFollowingEvents.eventDate(0))
                                          .toLocal()
                                          .toString(),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'JOINING ROOM ~~~~~~',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return multiAlerDialog(
                                          title: 'Join private room',
                                          context: context,
                                          content: defaultTextFormField(
                                            context: context,
                                            controller: privateRoomController,
                                            labelText: 'Enter room id',
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            keyboardType: TextInputType.text,
                                          ),
                                          actions: MaterialButton(
                                            onPressed: () {
                                              RoomCubit.get(context)
                                                  .getRoomData(
                                                      token,
                                                      privateRoomController.text
                                                          .trim())
                                                  .then((value) {
                                                SocketFunc.connectWithSocket(
                                                    context,
                                                    roomCubit,
                                                    GeneralAppCubit.get(
                                                        context));
                                                isPrivateRoom = true;
                                                SocketFunc.joinRoom(
                                                  activeRoomName,
                                                  context,
                                                  roomCubit,
                                                  cubit,
                                                );
                                              });
                                            },
                                            child: Text(
                                              'Enter',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  'Join private room',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 10, end: 10, top: 20),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => publicRoomItem(
                              audience:
                                  GetAllRoomsModel.getRoomsAudienc(index)?[0],
                              category:
                                  GetAllRoomsModel?.getRoomsGategory(index),
                              context: context,
                              roomName: GetAllRoomsModel?.getRoomName(index),
                              speaker: GetAllRoomsModel.getRoomsBrodcaster(
                                  index)?[0],
                              adminData:
                                  GetAllRoomsModel.getRoomsUserPublishInform(
                                      index),
                              click: () async {
                                if (cubit.isPlaying) {
                                  showToast(
                                      message:
                                          "you can't enter room if you playing a podcast,leave first(:",
                                      toastState: ToastState.WARNING);
                                } else {
                                  var hasBckGroundPermission =
                                      CachHelper.getData(
                                          key: 'hasBackGroundPermission');
                                  if (await FlutterBackground.hasPermissions ==
                                          true ||
                                      hasBckGroundPermission != null) {
                                    pressedJoinRoom = true;
                                    cubit.micPerm();
                                    if ((SocketFunc.isConnected &&
                                            currentUserRoleinRoom) &&
                                        GetAllRoomsModel?.getRoomName(index) ==
                                            activeRoomName) {
                                      navigatePushTo(
                                          context: context,
                                          navigateTo:
                                              const RoomAdminViewScreen());
                                    } else if (SocketFunc.isConnected &&
                                        GetAllRoomsModel?.getRoomName(index) ==
                                            activeRoomName) {
                                      navigatePushTo(
                                          context: context,
                                          navigateTo:
                                              const RoomUserViewScreen());
                                    } else if (SocketFunc.isConnected) {
                                      if (currentUserRoleinRoom) {
                                        showToast(
                                            message:
                                                "You can't join room if you are admin of a room,leave first ):",
                                            toastState: ToastState.ERROR);
                                      } else {
                                        NotificationService.notification
                                            .cancelAll();
                                        SocketFunc.leaveRoom(
                                            context,
                                            RoomCubit.get(context),
                                            GeneralAppCubit.get(context));
                                        SocketFunc.connectWithSocket(
                                            context,
                                            RoomCubit.get(context),
                                            GeneralAppCubit.get(context));
                                        SocketFunc.joinRoom(
                                            GetAllRoomsModel.getRoomName(index),
                                            context,
                                            roomCubit,
                                            cubit);
                                      }
                                    } else {
                                      SocketFunc.connectWithSocket(
                                          context,
                                          RoomCubit.get(context),
                                          GeneralAppCubit.get(context));
                                      SocketFunc.joinRoom(
                                          GetAllRoomsModel.getRoomName(index),
                                          context,
                                          roomCubit,
                                          cubit);
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => multiAlerDialog(
                                        context: context,
                                        title: 'Alert',
                                        content: Text(
                                          'Please allow to disable battery optimization and set it to no restriction.\t(disable battery optimization let you listen to your favourite rooms even if you sent app to background (:\n don\'t worry we will disable it after you leave the room) ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        actions: Center(
                                          child: MaterialButton(
                                            onPressed: () async {
                                              bool success =
                                                  await FlutterBackground
                                                      .initialize(
                                                          androidConfig:
                                                              androidConfig);
                                              Navigator.of(context).pop();
                                              if (success) {
                                                CachHelper.setData(
                                                    key:
                                                        'hasBackGroundPermission',
                                                    value: true);
                                              }
                                            },
                                            child: Text(
                                              'Allow',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            itemCount:
                                GetAllRoomsModel.getAllRooms?['data'].length,
                          ),
                        ),
                        cubit.noDateRooms
                            ? const SizedBox()
                            : InkWell(
                                borderRadius: BorderRadius.circular(40),
                                onTap: () {
                                  cubit.paginationRooms(
                                    token,
                                  );
                                },
                                child: Padding(
                                  padding: SocketFunc.isConnected
                                      ? const EdgeInsets.only(bottom: 100)
                                      : const EdgeInsets.only(bottom: 5),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8,
                                        top: 8,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        radius: 30,
                                        child: cubit.loadRooms
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
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
      },
    );
  }
}
