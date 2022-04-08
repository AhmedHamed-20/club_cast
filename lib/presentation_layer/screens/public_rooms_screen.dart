import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
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
import 'package:permission_handler/permission_handler.dart';

import '../models/getMyFollowingEvents.dart';

class PublicRoomScreen extends StatelessWidget {
  PublicRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = GeneralAppCubit?.get(context);
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
                                    GetAllRoomsModel?.getRoomsAudienc(index)[0],
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
                                  cubit.micPerm();
                                  if (SocketFunc.isConnected &&
                                      GetAllRoomsModel?.getRoomName(index) ==
                                          ActiveRoomAdminModel?.getRoomName()) {
                                    navigatePushTo(
                                        context: context,
                                        navigateTo: RoomAdminViewScreen());
                                  } else if (SocketFunc.isConnected &&
                                      GetAllRoomsModel?.getRoomName(index) ==
                                          ActiveRoomUserModel?.getRoomName()
                                              .toString()) {
                                    navigatePushTo(
                                        context: context,
                                        navigateTo: RoomUserViewScreen());
                                  } else if (SocketFunc.isConnected) {
                                    SocketFunc.leaveRoom(context);
                                    SocketFunc.connectWithSocket(context);
                                    SocketFunc.joinRoom(
                                        GetAllRoomsModel.getRoomName(index),
                                        context);
                                  } else {
                                    SocketFunc.connectWithSocket(context);
                                    SocketFunc.joinRoom(
                                        GetAllRoomsModel.getRoomName(index),
                                        context);
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
