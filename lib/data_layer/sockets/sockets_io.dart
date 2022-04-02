import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';
import '../bloc/room_cubit/room_cubit.dart';

class SocketFunc {
  static Socket? socket;
  static bool isAdminLeft = false;
  static bool isConnected = false;
  static void connectWithSocket(BuildContext context) {
    print(token);

    socket = io(
      'https://audiocomms-podcast-platform.herokuapp.com/',
      <String, dynamic>{
        'auth': {'token': '$token'},
        'autoConnect': true,
        'transports': ['websocket'],
        'forceNew': true,
        'timestampRequests': true,
      },
    );

    //socket.connect();
    socket?.on(
        'error',
        (data) => {
              print(data),
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING),
            });
    socket?.on('connect', (_) {
      print('connect');
      isConnected = true;
      socket?.emit('msg', 'test');
    });
    socket?.on('event', (data) => print(data));
    socket?.on('disconnect', (_) {
      print('disconnect');
      isConnected = false;

      navigatePushTo(context: context, navigateTo: LayoutScreen());

      GeneralAppCubit.get(context).getAllRoomsData();
    });
    socket?.on('fromServer', (_) => print(_));
  }

  static createRoom(Map<String, dynamic> roomData, context) {
    print('createRoom');
    socket?.emit('createRoom', roomData);
    socket?.on(
        'createRoomSuccess',
        (data) => {
              print(data),
              GeneralAppCubit.get(context).getAllRoomsData(),
              ActiveRoomAdminModel.activeRoomAdminData = data[0],
              ActiveRoomAdminModel.activeRoomData = data[1],
              ActiveRoomAdminModel.adminToken = data[2],
              print('audienceList:${ActiveRoomAdminModel.getRoomsAudienc()}'),
              print(
                  'BrodacsterList:${ActiveRoomAdminModel.getRoomsBrodCasters()}'),
              navigatePushTo(
                context: context,
                navigateTo: RoomAdminViewScreen(),
              ),
              GeneralAppCubit.get(context).roomNameController.clear(),
              GeneralAppCubit.get(context).selectedCategoryItem = 'ai',
              GeneralAppCubit.get(context).isPublicRoom = true,
              GeneralAppCubit.get(context).isRecordRoom = false,
              userJoined(context, ActiveRoomAdminModel.getRoomId()),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static leaveRoom(BuildContext context) {
    socket?.disconnect();
    socket?.onDisconnect((data) => {
          print(data),
        });
  }

  static joinRoom(String roomName, BuildContext context) {
    socket?.emit('joinRoom', roomName);
    socket?.on(
        'joinRoomSuccess',
        (data) => {
              print(data),
              ActiveRoomUserModel.activeRoomUserData = data[0],
              ActiveRoomUserModel.activeRoomData = data[1],
              ActiveRoomUserModel.userToken = data[2],
              print('userPhoto:' + ActiveRoomUserModel.getUserPhoto()),
              navigatePushTo(
                context: context,
                navigateTo: RoomUserViewScreen(),
              ),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userJoined(BuildContext context, String roomId) {
    print('userJoined');
    socket?.on(
        'userJoined',
        (data) =>
            {print(data), RoomCubit.get(context).getRoomData(token, roomId)});
  }

  static isAdminLeftSocket() {
    socket?.on(
        'adminLeft',
        (data) => {
              print('adminLeft'),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userLeft() {
    socket?.on(
        'userLeft',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static askToTalk() {
    socket?.emit(
        'askForPerms',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static listenOnUsersAskedForTalk() {
    socket?.on(
        'userAskedForPerms',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static adminGivePermissionForUserToTalk(Map<String, dynamic> userMap) {
    socket?.emit('givePermsTo', userMap);
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static brodcasterToken() {
    socket?.on(
        'brodcasterToken',
        (data) => {
              print(data),
            });

    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userchangedToBrodCaster() {
    socket?.on(
        'userChangedToBrodcaster',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userWantToReturnAudience() {
    socket?.emit('weHaveToGoBack');
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static audienceToken() {
    socket?.on(
        'audienceToken',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userchangedToAudienc() {
    socket?.on(
        'userChangedToAudience',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static adminReturnUserBackToAudienc(Map<String, dynamic> user) {
    socket?.emit('takeAwayPermsFrom', user);
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }
}