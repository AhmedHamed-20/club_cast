import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../presentation_layer/components/constant/constant.dart';

class AgoraRtc {
  ClientRole? role;
  RtcEngine? _engine;

  Future<void> initAgoraRtcEngine(String appID, ClientRole role) async {
    _engine = await RtcEngine.create(appID);
    await _engine?.disableVideo();
    await _engine?.enableAudio();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(role);
  }

  Future<void> JoinChannel(
      String appId, ClientRole role, String channelName) async {
    await initAgoraRtcEngine(appId, role);

    // await _engine.enableWebSdkInteroperability(true);
    await _engine?.joinChannel(null, channelName, null, 0);
  }
}
