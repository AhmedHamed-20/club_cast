import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/notification/local_notification.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/models/getAllRoomsModel.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_screen.dart';
import 'package:club_cast/presentation_layer/widgets/event_card_item.dart';
import 'package:club_cast/presentation_layer/widgets/public_room_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/getMyFollowingEvents.dart';

class PublicRoomScreen extends StatelessWidget {
  PublicRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GeneralAppCubit?.get(context);
        var roomCubit = RoomCubit.get(context);
        refresh() {
          cubit.getMyEvents();
          return cubit.getAllRoomsData();
        }

        return GetMyFollowingEvents.data != null
            ? RefreshIndicator(
                backgroundColor: Theme.of(context).backgroundColor,
                color: Theme.of(context).primaryColor,
                onRefresh: refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 40.0),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            eventCardItem(
                                          context: context,
                                          index: index,
                                          userWhoCreateEventId:
                                              GetMyFollowingEvents
                                                  .userWhoCreateEvent(
                                                      index)["_id"],
                                          userName: GetMyFollowingEvents
                                              .userWhoCreateEvent(
                                                  index)["name"],
                                          userUrl: GetMyFollowingEvents
                                              .userWhoCreateEvent(
                                                  index)['photo'],
                                          eventDescription: GetMyFollowingEvents
                                              .eventDescription(index),
                                          eventName:
                                              GetMyFollowingEvents.eventName(
                                                  index),
                                          eventDate:
                                              GetMyFollowingEvents.eventDate(
                                                  index),
                                        ),
                                        itemCount:
                                            GetMyFollowingEvents.allEvent()
                                                .length,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: Text(
                              'JOINING ROOM ~~~~~~',
                              style: Theme.of(context).textTheme.bodyText1,
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
                                click: () {
                                  //   RoomCubit.get(context).changeState();

                                  pressedJoinRoom = true;
                                  cubit.micPerm();
                                  if ((SocketFunc.isConnected &&
                                          currentUserRoleinRoom) &&
                                      GetAllRoomsModel?.getRoomName(index) ==
                                          activeRoomName) {
                                    navigatePushTo(
                                        context: context,
                                        navigateTo: RoomAdminViewScreen());
                                  } else if (SocketFunc.isConnected &&
                                      GetAllRoomsModel?.getRoomName(index) ==
                                          activeRoomName) {
                                    navigatePushTo(
                                        context: context,
                                        navigateTo: RoomUserViewScreen());
                                  } else if (SocketFunc.isConnected) {
                                    if (currentUserRoleinRoom) {
                                      showToast(
                                          message:
                                              "You can't join room if you are admin of a room,leave first ):",
                                          toastState: ToastState.ERROR);
                                    } else {
                                      NotificationService.notification
                                          .cancelAll();
                                      SocketFunc.leaveRoom(context);
                                      SocketFunc.connectWithSocket(context);
                                      SocketFunc.joinRoom(
                                          GetAllRoomsModel.getRoomName(index),
                                          context,
                                          roomCubit,
                                          cubit);
                                    }
                                  } else {
                                    SocketFunc.connectWithSocket(context);
                                    SocketFunc.joinRoom(
                                        GetAllRoomsModel.getRoomName(index),
                                        context,
                                        roomCubit,
                                        cubit);
                                  }
                                },
                              ),
                              itemCount:
                                  GetAllRoomsModel.getAllRooms?['data'].length,
                            ),
                          ),
                        ],
                      )),
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
