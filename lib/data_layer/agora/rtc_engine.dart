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

  static Future<void> joinChannel(
      {required ClientRole role,
      required String channelName,
      required String token}) async {
    await initAgoraRtcEngine('6179379dd4f7462f893ab53fd084d11a', role);

    // await _engine.enableWebSdkInteroperability(true);
    await engine?.joinChannel(token, channelName, null, 0);
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
    engine?.setEventHandler(
      RtcEngineEventHandler(
          userJoined: (uid, elapsed) {},
          joinChannelSuccess: (channelName, uId, el) {
            print('weAreLive');
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
