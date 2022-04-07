import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';

class AgoraRtc {
  static ClientRole? role;
  static RtcEngine? engine;
  static bool muted = false;

  static Future<void> initAgoraRtcEngine(String appID, ClientRole role) async {
    print('initAgora role ${role}');
    engine = await RtcEngine.create('448e147938e04c23a2b56677daa303c8');
    await engine?.disableVideo();
    await engine?.enableAudio();
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await engine?.setClientRole(role);
  }

  static Future<void> joinChannelagora(
      {required ClientRole role,
      required String channelName,
      required String token,
      required BuildContext context}) async {
    print('join');
    print(role);
    print(channelName);
    print(token);

    // await _engine.enableWebSdkInteroperability(true);
    await initAgoraRtcEngine('b29cc6ee03d642a6bf54c2f5906b9702', role);
    await engine?.joinChannel(token, channelName, null, 0).then((value) {
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
      RtcEngineEventHandler(
          userJoined: (uid, elapsed) {
            print('adel');
            print(uid);
            RoomCubit.get(context)
                    .listener[RoomCubit.get(context).listener.length - 1]
                ['agoraId'] = uid;
            print(RoomCubit.get(context).listener);
          },
          joinChannelSuccess: (channelName, uId, el) {
            print('weAreLive');
            print(uId);
            RoomCubit.get(context).speakers[0]['agoraId'] = uId;
            print(RoomCubit.get(context).speakers);
          },
          remoteAudioStateChanged: (uId, state, reason, el) {}),
    );
  }

  static void onToggleMute() {
    muted = !muted;
    engine?.muteLocalAudioStream(muted);
  }

  static void leave() {
    engine?.leaveChannel();
    engine?.destroy();
  }
}
