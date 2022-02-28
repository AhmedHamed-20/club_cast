import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

class AgoraRtc {
  late final ClientRole role;
  late AgoraRtmClient _client;
  late AgoraRtmChannel _channel;
  late RtcEngine _engine;
}
