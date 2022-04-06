import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';

class AgoraRtc {
  static ClientRole? role;
  static RtcEngine? engine;
  static bool muted = false;

  static Future<void> initAgoraRtcEngine(String appID, ClientRole role) async {
    engine = await RtcEngine.create(appID);
    await engine?.disableVideo();
    await engine?.enableAudio();
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(role);
  }

  static Future<void> JoinChannel(
      String appId, ClientRole role, String channelName) async {
    await initAgoraRtcEngine(appId, role);

    // await _engine.enableWebSdkInteroperability(true);
    await engine?.joinChannel(null, channelName, null, 0);
  }

  static Future toChangeRole(
      {required String tokenAgora, required ClientRole role}) async {
    engine?.renewToken(tokenAgora).then((value) async {
      await engine?.setClientRole(role);
    }).catchError((onError) {
      print('dddddddddddddddddddddddddddd' + onError);
    });
  }

  static void eventsAgora() {
    engine?.setEventHandler(RtcEngineEventHandler(
      userJoined: (uid, elapsed) {},
    ));
  }

  static void onToggleMute() {
    muted = !muted;

    engine?.muteLocalAudioStream(muted);
  }
}
