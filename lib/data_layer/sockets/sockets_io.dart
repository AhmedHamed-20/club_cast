import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';

class SocketFunc {
  static Socket? socket;
  static bool isAdminLeft = false;
  static void connectWithSocket() {
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
            });
    socket?.on('connect', (_) {
      print('connect');
      socket?.emit('msg', 'test');
    });
    socket?.on('event', (data) => print(data));
    socket?.on('disconnect', (_) => print('disconnect'));
    socket?.on('fromServer', (_) => print(_));
  }

  static createRoom(
    Map<String, dynamic> roomData,
  ) {
    print('createRoom');
    socket?.emit('createRoom', roomData);
    socket?.on(
        'createRoomSuccess',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static joinRoom(String roomName) {
    socket?.emit('joinRoom', roomName);
    socket?.on(
        'joinRoomSuccess',
        (data) => {
              print(data),
            });
    socket?.on(
        'errorMessage',
        (data) => {
              print(data),
            });
  }

  static isAdminLeftSocket() {
    socket?.on(
        'adminLeft',
        (data) => {
              isAdminLeft = true,
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
