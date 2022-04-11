import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_screen.dart';
import 'package:flutter/widgets.dart';
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
  static void connectWithSocket(BuildContext context) {
    print(token);

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
              print(data),
              showToast(
                  message: data.toString(), toastState: ToastState.WARNING),
            });
    socket?.on('connect', (_) {
      print('connect');
      isConnected = true;
      if (isAdminLeft == false && showReconnectButton == true) {
        if (socket!.connected) {
          adminReturnBack(context);
          adminReturnSuccess(context, RoomCubit.get(context));
          userJoined(context, ActiveRoomAdminModel.getRoomId());
          userchangedToAudienc(
              context, RoomCubit.get(context), GeneralAppCubit.get(context));
          listenOnUsersAskedForTalk(context);
          userLeft(ActiveRoomAdminModel.getRoomId(), context);
          userchangedToBrodCaster(context, '');
          adminLeft(context);
          GeneralAppCubit.get(context).getAllRoomsData();
        }
      }
      socket?.emit('msg', 'test');
    });
    socket?.on('event', (data) => print(data));
    socket?.on('reconnect', (data) {
      print('reconnect');
    });
    socket?.on('reconnecting', (data) {
      print('reconnecting');
    });

    socket?.on(' reconnect_attempt', (data) {
      print(' reconnect_attempt');
    });

    socket?.on('disconnect', (data) {
      print('disconnect');
      print(data);
      if (isAdminLeft == false && currentUserRoleinRoom == true) {
        showToast(
            message:
                "No internet found,if you still offline for 1 min the room will be closed",
            toastState: ToastState.ERROR);
        showReconnectButton = true;
        socket?.disconnect();
        AgoraRtc.stopRecording();
        AgoraRtc.leave();

        RoomCubit.get(context).changeState();
        return;
      }
      var myCubit = RoomCubit();
      myCubit.listener = [];
      myCubit.speakers = [];
      ActiveRoomAdminModel.activeRoomAdminData = {};
      ActiveRoomAdminModel.activeRoomData = {};
      activeRoomName = '';

      ActiveRoomUserModel.activeRoomUserData = {};
      ActiveRoomUserModel.activeRoomData = {};
      if (isConnected &&
          (pressedJoinRoom == false && currentUserRoleinRoom == false)) {
        print(isConnected);
        print(pressedJoinRoom);
        print('role${currentUserRoleinRoom}');
        showToast(message: "No internet found", toastState: ToastState.ERROR);
        navigatePushANDRemoveRout(context: context, navigateTo: LayoutScreen());
        socket?.disconnect();
        activeRoomName = '';
        currentUserRoleinRoom = false;
        AgoraRtc.leave();
        isConnected = false;
      }
      currentUserRoleinRoom = false;
      var generalCubit = GeneralAppCubit();
      generalCubit.getAllRoomsData();
    });
    socket?.on('fromServer', (_) => print(_));
  }

  static createRoom(
      Map<String, dynamic> roomData, context, cubit, generalAppCubit) {
    print('createRoom');
    socket?.emit('createRoom', roomData);
    socket?.on(
        'createRoomSuccess',
        (data) => {
              GeneralAppCubit.get(context).isRecordRoom
                  ? AgoraRtc.recording(data[0]['roomName'])
                  : const SizedBox(),
              isConnected = true,
              isAdminLeft = false,
              iamSpeaker = true,
              // print(data),
              GeneralAppCubit.get(context).getAllRoomsData(),
              ActiveRoomAdminModel.activeRoomAdminData = data[0],
              ActiveRoomAdminModel.activeRoomData = data[1],
              currentUserRoleinRoom = true,
              ActiveRoomAdminModel.adminToken = data[2],
              RoomCubit.get(context).speakers = [data[0]],
              RoomCubit?.get(context).speakers.forEach((e) {
                e['isMuted'] = false;
                e['isTalking'] = false;
              }),
              activeRoomName = ActiveRoomAdminModel.getRoomName(),
              print('name' +
                  GeneralAppCubit.get(context).roomNameController.text),
              AgoraRtc.joinChannelagora(
                channelName:
                    GeneralAppCubit.get(context).roomNameController.text,
                role: ClientRole.Broadcaster,
                token: data[2],
                context: context,
                uid: data[0]['uid'],
                cubit: cubit,
              ),
              print('toekn' + data[2]),
              AgoraRtc.eventsAgora(context, cubit),
              print(GeneralAppCubit.get(context).roomNameController.text),
              print('audienceList:${ActiveRoomAdminModel.getRoomsAudienc()}'),
              print(
                  'BrodacsterList:${ActiveRoomAdminModel.getRoomsBrodCasters()}'),
              print(data),
              Navigator.pop(context),
              navigatePushTo(
                context: context,
                navigateTo: RoomAdminViewScreen(),
              ),
              GeneralAppCubit.get(context).roomNameController.clear(),

              GeneralAppCubit.get(context).selectedCategoryItem = 'ai',
              GeneralAppCubit.get(context).isPublicRoom = true,
              GeneralAppCubit.get(context).isRecordRoom = false,
              userJoined(context, ActiveRoomAdminModel.getRoomId()),

              userchangedToAudienc(context, cubit, generalAppCubit),
              listenOnUsersAskedForTalk(context),
              userLeft(ActiveRoomAdminModel.getRoomId(), context),
              adminLeft(context),
              userchangedToBrodCaster(context, cubit),
              adminReturnSuccess(context, cubit),
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
    RoomCubit.get(context).speakers = [];
    RoomCubit.get(context).listener = [];
    if (currentUserRoleinRoom == false) {
      AgoraRtc.leave();
    }

    AgoraRtc.muted = false;
    activeRoomName = '';
    iamSpeaker = false;
    socket?.disconnect();
    isConnected = false;

    socket?.onDisconnect((data) => {
          print(data),
        });
  }

  static joinRoom(
      String roomName, BuildContext context, cubit, generalAppCubit) {
    print('here');

    socket?.emit('joinRoom', roomName);
    socket?.on(
        'joinRoomSuccess',
        (data) => {
              if (currentUserRoleinRoom)
                {
                  isAdminLeft = true,
                }
              else
                {
                  isAdminLeft = false,
                },
              pressedJoinRoom = false,
              currentUserRoleinRoom = false,

              cubit.speakers.add(data[1]['admin']),

              cubit.speakers.addAll(data[1]['brodcasters']),
              cubit.speakers.forEach((e) {
                e['isMuted'] = false;
                e['isTalking'] = false;
              }),
              cubit.listener.addAll(data[1]['audience']),
              cubit.listener.forEach(
                (e) {
                  if (e['askedToTalk'] != true) {
                    e['askedToTalk'] = false;
                    e['isSpeaker'] = false;
                    e['isMuted'] = false;
                    e['isTalking'] = false;
                  }
                },
              ),
              // print(data),
              ActiveRoomUserModel.activeRoomUserData = data[0],
              ActiveRoomUserModel.activeRoomData = data[1],

              ActiveRoomUserModel.userToken = data[2],
              //  print('userPhoto:' + ActiveRoomUserModel.getUserPhoto()),
              activeRoomName = ActiveRoomUserModel.getRoomName().toString(),
              print(RoomCubit.get(context).listener),

              //print(RoomCubit.get(context).speakers),
              // print(RoomCubit.get(context).listener),

              AgoraRtc.joinChannelagora(
                channelName: ActiveRoomUserModel.getRoomName().toString(),
                role: ClientRole.Audience,
                token: data[2],
                context: context,
                uid: data[0]['uid'],
                cubit: cubit,
              ),
              AgoraRtc.eventsAgora(context, cubit),
              navigatePushTo(
                context: context,
                navigateTo: RoomUserViewScreen(),
              ),
              NotificationService.showNotification(
                'Active room',
                activeRoomName,
                'sadsad',
              ),
              isAdminLeftSocket(),
              userJoined(context, ActiveRoomUserModel.getRoomId()),
              userLeft(ActiveRoomUserModel.getRoomId(), context),
              listenOnUsersAskedForTalk(context),
              userchangedToBrodCaster(context, cubit),
              userchangedToAudienc(context, cubit, generalAppCubit),
              brodcasterToken(),
              audienceToken(),
              adminLeft(context),
              isConnected = true,
              generalAppCubit.changeState(),
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
                  e['isTalking'] = false;
                  e['isMuted'] = false;
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
              showToast(
                  message:
                      'Admin has no internet the room will be closed after 1 min if admin not reconnected',
                  toastState: ToastState.WARNING),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static adminReturnBack(BuildContext context) {
    print('sending');
    socket?.emit('adminReJoinRoom');
    socket?.on('errorMessage', (data) {
      activeRoomName = '';
      RoomCubit.get(context).speakers = [];
      RoomCubit.get(context).listener = [];
      isAdminLeft = true;
      isConnected = false;
      currentUserRoleinRoom = true;
      navigatePushANDRemoveRout(context: context, navigateTo: LayoutScreen());
      print('error');
      print(data);
    });
  }

  static adminReturnSuccess(BuildContext context, cubit) {
    socket?.on('adminReJoinedRoomSuccess', (data) {
      print(data);
      AgoraRtc.joinChannelagora(
        channelName: data[0]['roomName'],
        context: context,
        role: ClientRole.Broadcaster,
        token: data[2],
        uid: data[0]['uid'],
        cubit: cubit,
      );
      print('reconnect');
      print(data);
      AgoraRtc.recording(ActiveRoomAdminModel.getRoomName() + '2');
      ActiveRoomAdminModel.activeRoomAdminData = data[0];
      ActiveRoomAdminModel.activeRoomData = data[1];
      RoomCubit.get(context).speakers = [];
      RoomCubit.get(context).listener = [];

      RoomCubit.get(context).speakers = [data[0]];
      RoomCubit.get(context).speakers.addAll(data[1]['brodcasters']);
      RoomCubit.get(context).listener.addAll(data[1]['audience']);
      RoomCubit?.get(context).speakers.forEach((e) {
        e['isMuted'] = false;
        e['isTalking'] = false;
      });
      RoomCubit?.get(context).listener.forEach(
        (e) {
          e['askedToTalk'] = false;
          e['isSpeaker'] = false;
          e['isMuted'] = false;
          e['isTalking'] = false;
        },
      );
      showReconnectButton = false;
      print(RoomCubit?.get(context).listener);
      RoomCubit.get(context).changeState();
    });
  }

  static adminLeft(BuildContext context) {
    socket?.on('roomEnded', (data) {
      print('roomEnded');
      activeRoomName = '';
      RoomCubit.get(context).listener = [];
      RoomCubit.get(context).speakers = [];
      isConnected = false;

      iamSpeaker = false;
      isAdminLeft = true;
      print('adminleft');
      AgoraRtc.leave().then((value) {
        leaveRoom(context);
      });
      navigatePushANDRemoveRout(context: context, navigateTo: LayoutScreen());
      showToast(message: 'Admin left the room', toastState: ToastState.WARNING);
      if (isAdminLeft == false) {
        RoomCubit.get(context).listener = [];
        RoomCubit.get(context).speakers = [];
        isConnected = false;

        isAdminLeft = true;
        AgoraRtc.leave().then((val) {
          leaveRoom(context);
        });

        navigatePushANDRemoveRout(context: context, navigateTo: LayoutScreen());
        showToast(message: 'Room time ended', toastState: ToastState.WARNING);
      }
    });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static adminEndTheRoom() {
    print('letfTheRoom');
    socket?.emit(
      'endRoom',
    );

    isAdminLeft = true;
    socket?.on(
        'errorMessage',
        (data) => {
              print('error'),
              print(data),
            });
  }

  static userLeft(String roomId, BuildContext context) {
    socket?.on('userLeft', (data) {
      print('userLeft');
      bool isFound = false;
      for (int i = 0; i < RoomCubit.get(context).listener.length; i++) {
        //    print(data['id']);
        if (data['_id'] == RoomCubit.get(context).listener[i]['_id']) {
          RoomCubit.get(context).listener.removeAt(i);
          print(RoomCubit.get(context).listener);
          RoomCubit.get(context).changeState();
          isFound = true;
          break;
        }
      }
      if (isFound == false) {
        for (int i = 0; i < RoomCubit.get(context).speakers.length; i++) {
          if (data['_id'] == RoomCubit.get(context).speakers[i]['_id']) {
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
      var cubit = RoomCubit.get(context);
      //   RoomCubit.get(context).askedToTalk.add(data),
      for (int i = 0; i < cubit.listener.length; i++) {
        if (data['_id'] == cubit.listener[i]['_id']) {
          RoomCubit.get(context).listener[i]['askedToTalk'] =
              !RoomCubit.get(context).listener[i]['askedToTalk'];
          print(RoomCubit.get(context).listener);

          RoomCubit.get(context).changeState();

          break;
        }
      }
      GeneralAppCubit.get(context).changeState();
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
    print(userMap);
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
              //  print('brodToken' + data),
              AgoraRtc.toChangeRole(
                  tokenAgora: data, role: ClientRole.Broadcaster),
            });

    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userchangedToBrodCaster(BuildContext context, cubit) {
    socket?.on('userChangedToBrodcaster', (data) {
      for (int i = 0; i < cubit.listener.length; i++) {
        if (data['_id'] == cubit.listener[i]['_id']) {
          cubit.speakers.add(cubit.listener[i]);
          cubit.listener.removeAt(i);
          cubit.speakers[cubit.speakers.length - 1]['isSpeaker'] = true;

          cubit.speakers[cubit.speakers.length - 1]['_id'] ==
                  GetUserModel.getUserID()
              ? iamSpeaker = true
              : const SizedBox();
          print(cubit.speakers);

          cubit.changeState();

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

  static userWantToReturnAudience(context) {
    socket?.emit('weHaveToGoBack');
    GeneralAppCubit.get(context).changeState();
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
              AgoraRtc.toChangeRole(
                  tokenAgora: data, role: ClientRole.Audience),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static userchangedToAudienc(BuildContext context, cubit, generalCubit) {
    socket?.on('userChangedToAudience', (data) {
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
