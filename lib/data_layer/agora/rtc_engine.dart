import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';

class AgoraRtc {
  static ClientRole? role;
  static RtcEngine? engine;
  static bool muted = false;

  static Future<void> initAgoraRtcEngine(String appID, ClientRole role) async {
    print('initAgora role ${role}');
    engine = await RtcEngine.create('b29cc6ee03d642a6bf54c2f5906b9702');
    await engine?.disableVideo();
    await engine?.enableAudio();
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await engine?.setClientRole(role);
    engine?.enableAudioVolumeIndication(250, 3, true);
  }

  static Future<void> joinChannelagora({
    required ClientRole role,
    required String channelName,
    required String token,
    required BuildContext context,
    required uid,
  }) async {
    print('join');
    print(role);
    print(channelName);
    print(token);

    // await _engine.enableWebSdkInteroperability(true);
    await initAgoraRtcEngine('b29cc6ee03d642a6bf54c2f5906b9702', role);
    await engine?.joinChannel(token, channelName, null, uid).then((value) {
      print('successssssssssss');
    });
    eventsAgora(context);
  }

  static Future toChangeRole(
      {required String tokenAgora, required ClientRole role}) async {
    engine?.renewToken(tokenAgora).then((value) async {
      await engine?.setClientRole(role);
    }).catchError((onError) {
      print('dddddddddddddddddddddddddddd' + onError);
    });
  }

  static void eventsAgora(BuildContext context) {
    print('events');
    engine?.setEventHandler(
      RtcEngineEventHandler(activeSpeaker: (uid) {
        print('klam');

        // for (int i = 0; i < RoomCubit.get(context).speakers.length; i++) {
        //   if (RoomCubit.get(context).speakers[i]['uid'] == uid) {
        //     RoomCubit.get(context).speakers[i]['isTalking'] = true;
        //     RoomCubit.get(context).changeState();

        //     //  RoomCubit.get(context).speakers[i]['isTalking'] = false;

        //   }

        //   //  RoomCubit.get(context).speakers[i]['isTalking'] = false;
        //   //  RoomCubit.get(context).changeState();
        // }
      }, audioVolumeIndication: (list, aa) {
        list.forEach((elementAgora) {
          RoomCubit.get(context).speakers.forEach((elementUser) {
            if (elementAgora.uid == 0 &&
                (elementUser['_id'] == ActiveRoomUserModel.getUserId() ||
                    elementUser['_id'] == ActiveRoomAdminModel.getAdminId())) {
              print(elementAgora.uid);
              elementUser['isTalking'] = true;
              RoomCubit.get(context).changeState();
            } else if (elementAgora.uid == elementUser['uid']) {
              elementUser['isTalking'] = true;
              RoomCubit.get(context).changeState();
            } else {
              elementUser['isTalking'] = false;
              RoomCubit.get(context).changeState();
            }
          });
        });
      }, userJoined: (uid, elapsed) {
        print('adel');
        print(uid);

        print(RoomCubit.get(context).listener);
      }, userMuteAudio: (uid, muted) {
        print('mutedAgora');
        for (int i = 0; i < RoomCubit.get(context).speakers.length; i++) {
          if (RoomCubit.get(context).speakers[i]['uid'] == uid) {
            RoomCubit.get(context).speakers[i]['isMuted'] = muted;
            break;
          }
        }
        RoomCubit.get(context).changeState();
      }, joinChannelSuccess: (channelName, uId, el) {
        print('weAreLive');
        print(uId);

        print(RoomCubit.get(context).speakers);
      }, remoteAudioStateChanged: (uId, state, reason, el) {
        print('muted ${state}');
      }),
    );
  }

  static void onToggleMute(index, BuildContext context) {
    muted = !muted;

    engine?.muteLocalAudioStream(muted);
    RoomCubit.get(context).speakers[index]['isMuted'] = muted;
    RoomCubit.get(context).changeState();
  }

  static void leave() {
    engine?.leaveChannel();
    engine?.destroy();
  }
}
