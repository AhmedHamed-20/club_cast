import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_screen.dart';
import 'package:club_cast/presentation_layer/widgets/multi_use_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../presentation_layer/components/constant/constant.dart';
import '../bloc/room_cubit/room_cubit.dart';
import '../notification/local_notification.dart';

class SocketFunc {
  static Socket? socket;
  static bool isAdminLeft = false;
  static bool isConnected = false;
  static bool iamSpeaker = false;
  static bool showReconnectButton = false;
  static void connectWithSocket(
      BuildContext context, roomCubit, generalAppCubit) {
    socket = io(
      'https://audiocomms-podcast-platform.herokuapp.com/',
      <String, dynamic>{
        'auth': {'token': '$token'},
        'transports': ['websocket'],
      },
    );

    socket?.connect();
    socket?.on(
        'error',
        (data) => {
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING),
            });
    socket?.on('connect', (_) {
      //  isConnected = true;
      if (isAdminLeft == false && showReconnectButton == true) {
        if (socket!.connected) {
          adminReturnBack(context, roomCubit, generalAppCubit);
          adminReturnSuccess(context, roomCubit, generalAppCubit);
          userJoined(context, ActiveRoomAdminModel.getRoomId(), roomCubit,
              generalAppCubit);
          userchangedToAudienc(context, roomCubit, generalAppCubit);
          listenOnUsersAskedForTalk(context, roomCubit, generalAppCubit);
          userLeft(ActiveRoomAdminModel.getRoomId(), context, roomCubit,
              generalAppCubit);
          userchangedToBrodCaster(context, roomCubit, generalAppCubit);
          adminLeft(context, roomCubit, generalAppCubit);
          generalAppCubit.getAllRoomsData(context);
        }
      }
      socket?.emit('msg', 'test');
    });
    socket?.on('event', (data) => print(data));
    socket?.on('reconnect', (data) {});
    socket?.on('reconnecting', (data) {});

    socket?.on(' reconnect_attempt', (data) {});

    socket?.on('disconnect', (data) {
      if (isAdminLeft == false && currentUserRoleinRoom == true) {
        showToast(
            message:
                "No internet found,if you still offline for 1 min the room will be closed",
            toastState: ToastState.ERROR);
        showReconnectButton = true;
        socket?.disconnect();
        AgoraRtc.stopRecording();
        AgoraRtc.leave();
        NotificationService.notification.cancelAll();
        RoomCubit.get(context).changeState();
        return;
      }

      roomCubit.listener = [];
      roomCubit.speakers = [];
      NotificationService.notification.cancelAll();
      ActiveRoomAdminModel.activeRoomAdminData = {};
      ActiveRoomAdminModel.activeRoomData = {};
      activeRoomName = '';

      ActiveRoomUserModel.activeRoomUserData = {};
      ActiveRoomUserModel.activeRoomData = {};
      if (isConnected &&
          (pressedJoinRoom == false && currentUserRoleinRoom == false)) {
        showToast(message: "No internet found", toastState: ToastState.ERROR);

        socket?.disconnect();
        activeRoomName = '';
        currentUserRoleinRoom = false;
        AgoraRtc.leave();
        isConnected = false;

        generalAppCubit.changeState();
      }
      currentUserRoleinRoom = false;

      generalAppCubit.getAllRoomsData(context);
    });
    socket?.on('fromServer', (_) => print(_));
  }

  static createRoom(
      Map<String, dynamic> roomData, context, cubit, generalAppCubit) {
    socket?.emit('createRoom', roomData);
    socket?.on('createRoomSuccess', (data) async {
      generalAppCubit.loadRoom = false;
      bool run = await FlutterBackground.enableBackgroundExecution();
      showRecordingGif = GeneralAppCubit.get(context).isRecordRoom;
      GeneralAppCubit.get(context).isRecordRoom
          ? AgoraRtc.recording(data[0]['roomName'])
          : const SizedBox();
      isConnected = true;
      isAdminLeft = false;
      iamSpeaker = true;
      // print(data);
      GeneralAppCubit.get(context).getAllRoomsData(context);
      ActiveRoomAdminModel.activeRoomAdminData = data[0];
      ActiveRoomAdminModel.activeRoomData = data[1];
      currentUserRoleinRoom = true;
      generalAppCubit.assetsAudioPlayer
          .open(Audio('assets/audio/userEnter.wav'));
      ActiveRoomAdminModel.adminToken = data[2];
      RoomCubit.get(context).speakers = [data[0]];
      RoomCubit?.get(context).speakers.forEach((e) {
        e['isMuted'] = false;
        e['isTalking'] = false;
      });
      activeRoomName = ActiveRoomAdminModel.getRoomName();

      AgoraRtc.joinChannelagora(
        appId: data[1]['APP_ID'],
        channelName: GeneralAppCubit.get(context).roomNameController.text,
        role: ClientRole.Broadcaster,
        token: data[2],
        context: context,
        uid: data[0]['uid'],
        cubit: cubit,
      );

      AgoraRtc.eventsAgora(context, cubit);

      Navigator.pop(context);
      navigatePushTo(
        context: context,
        navigateTo: const RoomAdminViewScreen(),
      );
      GeneralAppCubit.get(context).roomNameController.clear();
      NotificationService.showNotification(
          'Active room', activeRoomName, 'asd');

      userJoined(
          context, ActiveRoomAdminModel.getRoomId(), cubit, generalAppCubit);

      userchangedToAudienc(context, cubit, generalAppCubit);
      listenOnUsersAskedForTalk(context, cubit, generalAppCubit);
      userLeft(
          ActiveRoomAdminModel.getRoomId(), context, cubit, generalAppCubit);
      adminLeft(context, cubit, generalAppCubit);
      userchangedToBrodCaster(context, cubit, generalAppCubit);
      adminReturnSuccess(context, cubit, generalAppCubit);
      GeneralAppCubit.get(context).selectedCategoryItem = 'ai';
      // GeneralAppCubit.get(context).isPublicRoom = true;
      GeneralAppCubit.get(context).isRecordRoom = false;
    });
    socket?.on(
        'errorMessage',
        (data) => {
              generalAppCubit.loadRoom = false,
              generalAppCubit.changeState(),
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING)
            });
  }

  static leaveRoom(BuildContext context, roomCubit, generalAppCubit) {
    roomCubit.speakers = [];
    roomCubit.listener = [];
    if (currentUserRoleinRoom == false) {
      AgoraRtc.leave();
    }

    AgoraRtc.muted = false;
    activeRoomName = '';
    iamSpeaker = false;
    socket?.disconnect();
    isConnected = false;

    socket?.onDisconnect((data) => {});
  }

  static joinRoom(
      String roomName, BuildContext context, cubit, generalAppCubit) {
    socket?.emit('joinRoom', roomName);
    socket?.on('joinRoomSuccess', (data) async {
      if (isPrivateRoom == true) {
        Navigator.of(context).pop();
      }
      ;
      if (currentUserRoleinRoom) {
        isAdminLeft = true;
      } else {
        isAdminLeft = false;
      }
      pressedJoinRoom = false;
      currentUserRoleinRoom = false;
      bool run = await FlutterBackground.enableBackgroundExecution();
      cubit.speakers.add(data[1]['admin']);

      cubit.speakers.addAll(data[1]['brodcasters']);
      cubit.speakers.forEach((e) {
        e['isMuted'] = false;
        e['isTalking'] = false;
      });
      cubit.listener.addAll(data[1]['audience']);
      cubit.listener.forEach(
        (e) {
          if (e['askedToTalk'] != true) {
            e['askedToTalk'] = false;
            e['isSpeaker'] = false;
            e['isMuted'] = false;
            e['isTalking'] = false;
          }
        },
      );
      // print(data),
      ActiveRoomUserModel.activeRoomUserData = data[0];
      ActiveRoomUserModel.activeRoomData = data[1];

      ActiveRoomUserModel.userToken = data[2];
      //  print('userPhoto:' + ActiveRoomUserModel.getUserPhoto()),
      activeRoomName = ActiveRoomUserModel.getRoomName().toString();

      //print(RoomCubit.get(context).speakers),
      // print(RoomCubit.get(context).listener),
      generalAppCubit.assetsAudioPlayer
          .open(Audio('assets/audio/userEnter.wav'));
      AgoraRtc.joinChannelagora(
        appId: data[1]['APP_ID'],
        channelName: data[0]['roomName'],
        role: ClientRole.Audience,
        token: data[2],
        context: context,
        uid: data[0]['uid'],
        cubit: cubit,
      );
      AgoraRtc.eventsAgora(context, cubit);
      privateRoomController.clear();
      navigatePushTo(
        context: context,
        navigateTo: const RoomUserViewScreen(),
      );
      NotificationService.showNotification(
        'Active room',
        activeRoomName,
        'sadsad',
      );
      isAdminLeftSocket(generalAppCubit);
      userJoined(
          context,
          generalAppCubit.isPublicRoom
              ? ActiveRoomUserModel.getRoomId()
              : privateRoomController.text,
          cubit,
          generalAppCubit);
      userLeft(
          generalAppCubit.isPublicRoom
              ? ActiveRoomUserModel.getRoomId()
              : privateRoomController.text,
          context,
          cubit,
          generalAppCubit);
      listenOnUsersAskedForTalk(context, cubit, generalAppCubit);
      userchangedToBrodCaster(context, cubit, generalAppCubit);
      userchangedToAudienc(context, cubit, generalAppCubit);
      brodcasterToken();
      audienceToken();
      adminLeft(context, cubit, generalAppCubit);
      isConnected = true;
      generalAppCubit.changeState();
      isPrivateRoom = false;
      showRecordingGif = data[1]['isRecording'];
      if (data[1]['isRecording'] == true) {
        showDialog(
            context: context,
            builder: (context) {
              return multiAlerDialog(
                context: context,
                title: 'Info',
                content: Text(
                  'the host is recording this room',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: Center(
                  child: MaterialButton(
                    child: Text(
                      'ok',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            });
      }
    });
    socket?.on(
        'errorMessage',
        (data) => {
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING)
            });
  }

  static userJoined(
      BuildContext context, String roomId, roomCubit, generalAppCubit) {
    socket?.on(
        'userJoined',
        (data) => {
              generalAppCubit.assetsAudioPlayer
                  .open(Audio('assets/audio/userEnter.wav')),
              // print(data),
              //   ActiveRoomAdminModel.audienc?.add(data),
              roomCubit.listener.add(data),
              roomCubit.listener.forEach(
                (e) {
                  if (e['askedToTalk'] == false || e['askedToTalk'] == true) {
                  } else {
                    e['askedToTalk'] = false;
                    e['isTalking'] = false;
                    e['isMuted'] = false;
                  }
                },
              ),

              roomCubit.changeState(),
            });
  }

  static isAdminLeftSocket(generalAppCubit) {
    /////lw le net 2t3
    socket?.on(
        'adminLeft',
        (data) => {
              generalAppCubit.assetsAudioPlayer
                  .open(Audio('assets/audio/adminLeft.wav')),
              showToast(
                  message:
                      'Admin has no internet the room will be closed after 1 min if admin not reconnected',
                  toastState: ToastState.WARNING),
            });
    socket?.on('errorMessage', (data) => {});
  }

  static adminReturnBack(BuildContext context, roomCubit, generalAppCubit) {
    socket?.emit('adminReJoinRoom');
    socket?.on('errorMessage', (data) {
      activeRoomName = '';
      roomCubit.speakers = [];
      roomCubit.listener = [];
      isAdminLeft = true;
      isConnected = false;
      currentUserRoleinRoom = false;
      showToast(message: data, toastState: ToastState.ERROR);
    });
  }

  static adminReturnSuccess(BuildContext context, cubit, generalAppCubit) {
    socket?.on('adminReJoinedRoomSuccess', (data) {
      AgoraRtc.joinChannelagora(
        appId: data[1]['APP_ID'],
        channelName: data[0]['roomName'],
        context: context,
        role: ClientRole.Broadcaster,
        token: data[2],
        uid: data[0]['uid'],
        cubit: cubit,
      );

      AgoraRtc.recording(ActiveRoomAdminModel.getRoomName() + '2');
      NotificationService.showNotification(
          'Active room', data[0]['roomName'], 'asda');
      ActiveRoomAdminModel.activeRoomAdminData = data[0];
      ActiveRoomAdminModel.activeRoomData = data[1];
      cubit.speakers = [];
      cubit.listener = [];

      cubit.speakers = [data[0]];
      cubit.speakers.addAll(data[1]['brodcasters']);
      cubit.listener.addAll(data[1]['audience']);
      cubit.speakers.forEach((e) {
        e['isMuted'] = false;
        e['isTalking'] = false;
      });
      cubit.listener.forEach(
        (e) {
          e['askedToTalk'] = false;
          e['isSpeaker'] = false;
          e['isMuted'] = false;
          e['isTalking'] = false;
        },
      );
      showReconnectButton = false;

      cubit.changeState();
    });
  }

  static adminLeft(BuildContext context, roomCubit, generalAppCubit) {
    socket?.on('roomEnded', (data) {
      activeRoomName = '';
      roomCubit.listener = [];
      roomCubit.speakers = [];
      isConnected = false;

      iamSpeaker = false;
      isAdminLeft = true;

      AgoraRtc.leave().then((value) {
        leaveRoom(context, roomCubit, generalAppCubit);
      });
      generalAppCubit.assetsAudioPlayer
          .open(Audio('assets/audio/adminLeft.wav'));
      generalAppCubit.getAllRoomsData(context);
      showToast(message: 'Admin left the room', toastState: ToastState.WARNING);
      if (isAdminLeft == false) {
        roomCubit.listener = [];
        roomCubit.speakers = [];
        isConnected = false;

        isAdminLeft = true;
        AgoraRtc.leave().then((val) {
          leaveRoom(context, roomCubit, generalAppCubit);
        });

        navigatePushANDRemoveRout(context: context, navigateTo: LayoutScreen());
        showToast(message: 'Room time ended', toastState: ToastState.WARNING);
      }
    });
    socket?.on('errorMessage', (data) => {});
  }

  static adminEndTheRoom() {
    socket?.emit(
      'endRoom',
    );

    isAdminLeft = true;
    socket?.on('errorMessage', (data) => {});
  }

  static userLeft(
      String roomId, BuildContext context, roomCubit, generalAppCubit) {
    socket?.on('userLeft', (data) {
      generalAppCubit.assetsAudioPlayer
          .open(Audio('assets/audio/userLeft.wav'));

      bool isFound = false;
      for (int i = 0; i < roomCubit.listener.length; i++) {
        //    print(data['id']);
        if (data['_id'] == roomCubit.listener[i]['_id']) {
          roomCubit.listener.removeAt(i);

          roomCubit.changeState();
          isFound = true;
          break;
        }
      }
      if (isFound == false) {
        for (int i = 0; i < roomCubit.speakers.length; i++) {
          if (data['_id'] == roomCubit.speakers[i]['_id']) {
            roomCubit.speakers.removeAt(i);

            roomCubit.changeState();
            isFound = true;
            break;
          }
        }
      }
    });
    socket?.on('errorMessage', (data) => {});
  }

  static askToTalk() {
    socket?.emit(
      'askForPerms',
    );
    socket?.on('errorMessage', (data) {});
  }

  static listenOnUsersAskedForTalk(
      BuildContext context, roomCubit, generalAppCubit) {
    socket?.on('userAskedForPerms', (data) {
      //   RoomCubit.get(context).askedToTalk.add(data),
      for (int i = 0; i < roomCubit.listener.length; i++) {
        if (data['_id'] == roomCubit.listener[i]['_id']) {
          roomCubit.listener[i]['askedToTalk'] =
              !roomCubit.listener[i]['askedToTalk'];

          roomCubit.changeState();

          break;
        }
      }
      generalAppCubit.changeState();
      roomCubit.changeState();
    });
    socket?.on('errorMessage', (data) => {});
  }

  static adminGivePermissionForUserToTalk(Map<String, dynamic> userMap) {
    socket?.emit('givePermsTo', userMap);
    socket?.on('errorMessage', (data) => {});
  }

  static brodcasterToken() {
    socket?.on(
        'brodcasterToken',
        (data) => {
              //  print('brodToken' + data),
              AgoraRtc.toChangeRole(
                  tokenAgora: data, role: ClientRole.Broadcaster),
            });

    socket?.on('errorMessage', (data) => {});
  }

  static userchangedToBrodCaster(BuildContext context, cubit, generalAppCubit) {
    socket?.on('userChangedToBrodcaster', (data) {
      for (int i = 0; i < cubit.listener.length; i++) {
        generalAppCubit.assetsAudioPlayer
            .open(Audio('assets/audio/userBecomeSpeaker.wav'));
        if (data['_id'] == cubit.listener[i]['_id']) {
          cubit.speakers.add(cubit.listener[i]);
          cubit.listener.removeAt(i);
          cubit.speakers[cubit.speakers.length - 1]['isSpeaker'] = true;

          cubit.speakers[cubit.speakers.length - 1]['_id'] ==
                  GetUserModel.getUserID()
              ? iamSpeaker = true
              : const SizedBox();

          generalAppCubit.changeState();
          cubit.changeState();

          break;
        }
      }
    });
    socket?.on('errorMessage', (data) => {});
  }

  static userWantToReturnAudience(context, generalAppCubit) {
    socket?.emit('weHaveToGoBack');
    generalAppCubit.changeState();
    socket?.on('errorMessage', (data) => {});
  }

  static audienceToken() {
    socket?.on(
        'audienceToken',
        (data) => {
              AgoraRtc.toChangeRole(
                  tokenAgora: data, role: ClientRole.Audience),
            });
    socket?.on('errorMessage', (data) => {});
  }

  static userchangedToAudienc(BuildContext context, cubit, generalCubit) {
    socket?.on('userChangedToAudience', (data) {
      generalCubit.assetsAudioPlayer
          .open(Audio('assets/audio/userBecomeAudienc.wav'));
      for (int i = 0; i < cubit.speakers.length; i++) {
        if (data['_id'] == cubit.speakers[i]['_id']) {
          cubit.listener.add(cubit.speakers[i]);
          cubit.speakers.removeAt(i);
          cubit.listener[cubit.listener.length - 1]['askedToTalk'] = false;
          cubit.listener[cubit.listener.length - 1]['isSpeaker'] = false;
          cubit.listener[cubit.listener.length - 1]['_id'] ==
                  GetUserModel.getUserID()
              ? iamSpeaker = false
              : const SizedBox();
          generalCubit.changeState();
          cubit.changeState();

          break;
        }
      }
    });
    socket?.on('errorMessage', (data) => {});
  }

  static adminReturnUserBackToAudienc(Map<String, dynamic> user) {
    socket?.emit('takeAwayPermsFrom', user);
    socket?.on('errorMessage', (data) => {});
  }
}
