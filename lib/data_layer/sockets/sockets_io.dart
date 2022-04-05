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

      RoomCubit.get(context).listener = [];
      RoomCubit.get(context).speakers = [];
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
              isConnected = true,
              print(data),
              GeneralAppCubit.get(context).getAllRoomsData(),
              ActiveRoomAdminModel.activeRoomAdminData = data[0],
              ActiveRoomAdminModel.activeRoomData = data[1],
              ActiveRoomAdminModel.adminToken = data[2],
              print('audienceList:${ActiveRoomAdminModel.getRoomsAudienc()}'),
              print(
                  'BrodacsterList:${ActiveRoomAdminModel.getRoomsBrodCasters()}'),
              Navigator.pop(context),
              navigatePushTo(
                context: context,
                navigateTo: RoomAdminViewScreen(),
              ),
              GeneralAppCubit.get(context).roomNameController.clear(),
              RoomCubit.get(context).speakers = [data[0]],
              GeneralAppCubit.get(context).selectedCategoryItem = 'ai',
              GeneralAppCubit.get(context).isPublicRoom = true,
              GeneralAppCubit.get(context).isRecordRoom = false,
              userJoined(context, ActiveRoomAdminModel.getRoomId()),
              listenOnUsersAskedForTalk(context),
              userLeft(ActiveRoomAdminModel.getRoomId(), context),
              userchangedToBrodCaster(),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING)
            });
  }

  static leaveRoom(BuildContext context) {
    socket?.disconnect();

    socket?.onDisconnect((data) => {
          print(data),
        });
  }

  static joinRoom(String roomName, BuildContext context) {
    print('here');

    socket?.emit('joinRoom', roomName);
    socket?.on(
        'joinRoomSuccess',
        (data) => {
              // print(data),
              ActiveRoomUserModel.activeRoomUserData = data[0],
              ActiveRoomUserModel.activeRoomData = data[1],

              ActiveRoomUserModel.userToken = data[2],
              //  print('userPhoto:' + ActiveRoomUserModel.getUserPhoto()),

              RoomCubit?.get(context).listener.addAll(data[1]['audience']),
              RoomCubit?.get(context).listener.forEach(
                (e) {
                  if (e['askedToTalk'] != true) {
                    e['askedToTalk'] = false;
                  }
                },
              ),
              print(RoomCubit.get(context).listener),
              RoomCubit.get(context).speakers.add(data[1]['admin']),
              RoomCubit.get(context).speakers.addAll(data[1]['brodcasters']),
              //print(RoomCubit.get(context).speakers),
              // print(RoomCubit.get(context).listener),
              isAdminLeftSocket(),
              userJoined(context, ActiveRoomUserModel.getRoomId()),
              userLeft(ActiveRoomUserModel.getRoomId(), context),
              listenOnUsersAskedForTalk(context),
              userchangedToBrodCaster(),
              isConnected = true,
              navigatePushTo(
                context: context,
                navigateTo: RoomUserViewScreen(),
              ),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING)
            });
  }

  static userJoined(BuildContext context, String roomId) {
    print('userJoined');
    socket?.on(
        'userJoined',
        (data) => {
              // print(data),
              //   ActiveRoomAdminModel.audienc?.add(data),
              RoomCubit.get(context).listener.add(data),
              RoomCubit?.get(context).listener.forEach(
                (e) {
                  if (e['askedToTalk'] != true) {
                    e['askedToTalk'] = false;
                  }
                },
              ),
              print(RoomCubit.get(context).listener),
              RoomCubit.get(context).changeState(),
            });
  }

  static isAdminLeftSocket() {
    /////lw le net 2t3
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

  static adminLeft() {
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

  static adminEndTheRoom() {
    socket?.emit(
      'endRoom',
    );
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userLeft(String roomId, BuildContext context) {
    socket?.on('userLeft', (data) {
      bool isFound = false;
      for (int i = 0; i < RoomCubit.get(context).listener.length; i++) {
        //    print(data['id']);
        if (data['id'] == RoomCubit.get(context).listener[i]['_id'] ||
            data['id'] == RoomCubit.get(context).listener[i]['id']) {
          RoomCubit.get(context).listener.removeAt(i);
          print(RoomCubit.get(context).listener);
          RoomCubit.get(context).changeState();
          isFound = true;
          break;
        }
      }
      if (isFound == false) {
        for (int i = 0; i < RoomCubit.get(context).speakers.length; i++) {
          if (data['id'] == RoomCubit.get(context).speakers[i]['_id'] ||
              data['id'] == RoomCubit.get(context).speakers[i]['id']) {
            RoomCubit.get(context).speakers.removeAt(i);

            RoomCubit.get(context).changeState();
            isFound = true;
            break;
          }
        }
      }
    });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static askToTalk() {
    print('object');
    socket?.emit(
      'askForPerms',
    );
    socket?.on('errorMessage', (data) {
      print(data);
    });
  }

  static listenOnUsersAskedForTalk(BuildContext context) {
    socket?.on('userAskedForPerms', (data) {
      print(data);
      //   RoomCubit.get(context).askedToTalk.add(data),
      for (int i = 0; i < RoomCubit.get(context).listener.length; i++) {
        if (data['id'] == RoomCubit.get(context).listener[i]['_id'] ||
            data['id'] == RoomCubit.get(context).listener[i]['id']) {
          RoomCubit.get(context).listener[i]['askedToTalk'] =
              !RoomCubit.get(context).listener[i]['askedToTalk'];
          print(RoomCubit.get(context).listener);
          RoomCubit.get(context).changeState();

          break;
        }
      }

      RoomCubit.get(context).changeState();
      print(RoomCubit.get(context).askedToTalk);
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

  static userchangedToAudienc(BuildContext context) {
    socket?.on('userChangedToAudience', (data) {
      //  print(data);
      for (int i = 0; i < RoomCubit.get(context).listener.length; i++) {
        if (data['id'] == RoomCubit.get(context).listener[i]['_id']) {
          RoomCubit.get(context)
              .speakers
              .add(RoomCubit.get(context).listener[i]);
          RoomCubit.get(context).listener.removeAt(i);
          RoomCubit.get(context).changeState();

          break;
        }
      }
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
