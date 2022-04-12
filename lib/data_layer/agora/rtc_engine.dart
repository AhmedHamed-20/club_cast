import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart' as path;
import '../../presentation_layer/components/constant/constant.dart';

class AgoraRtc {
  static ClientRole? role;
  static RtcEngine? engine;
  static bool muted = false;
  static String? recordingPath;
  static File? recordingFile;
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
    required cubit,
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
    eventsAgora(context, cubit);
  }

  static Future toChangeRole(
      {required String tokenAgora, required ClientRole role}) async {
    engine?.renewToken(tokenAgora).then((value) async {
      await engine?.setClientRole(role);
    }).catchError((onError) {
      print('dddddddddddddddddddddddddddd' + onError);
    });
  }

  static void eventsAgora(BuildContext context, cubit) {
    print('events');
    engine?.setEventHandler(
      RtcEngineEventHandler(
        activeSpeaker: (uid) {
          print('klam');
        },
        audioVolumeIndication: (list, aa) {
          //    var myBloc = RoomCubit();
          print(list);
          if (isIamInRoomScreen) {
            list.forEach((elementAgora) {
              cubit.speakers.forEach(
                (elementUser) {
                  if (elementAgora.volume > 3) {
                    print('elementUser:' + elementUser['_id']);
                    print('activeUser:' + GetUserModel.getUserID());
                    if (elementAgora.uid == 0 &&
                        (elementUser['_id'] == GetUserModel.getUserID())) {
                      //    print('user' + ActiveRoomUserModel.getUserId());

                      elementUser['isTalking'] = true;
                      cubit.changeState();
                    } else if (elementAgora.uid == elementUser['uid']) {
                      elementUser['isTalking'] = true;
                      print('sec');
                      cubit.changeState();
                    } else {
                      elementUser['isTalking'] = false;
                      print('third');
                      cubit.changeState();
                    }
                  } else {
                    elementUser['isTalking'] = false;
                    cubit.changeState();
                    //   RoomCubit.get(context).changeState2();
                  }
                },
              );
            });
          }
        },
        userJoined: (uid, elapsed) {
          print('adel');
          print(uid);

          //  print(RoomCubit.get(context).listener);
        },
        userMuteAudio: (uid, muted) {
          print('mutedAgora');
          for (int i = 0; i < cubit.speakers.length; i++) {
            if (cubit.speakers[i]['uid'] == uid) {
              cubit.speakers[i]['isMuted'] = muted;
              break;
            }
          }
          cubit.changeState();
        },
        joinChannelSuccess: (channelName, uId, el) {
          print('weAreLive');
          print(uId);

          print(cubit.speakers);
        },
      ),
    );
  }

  static void onToggleMute(index, BuildContext context) {
    muted = !muted;

    engine?.muteLocalAudioStream(muted);
    RoomCubit.get(context).speakers[index]['isMuted'] = muted;

    RoomCubit.get(context).changeState();
    GeneralAppCubit.get(context).changeState();
  }

  static Future leave() async {
    engine?.leaveChannel();
    return await engine?.destroy();
  }

  static Future<List<Directory>?> getRecordeingPath() {
    return path.getExternalStorageDirectories(
        type: path.StorageDirectory.documents);
  }

  static Future<List<Directory>?> getDownload() {
    return path.getExternalCacheDirectories();
  }

  static recording(String roomName) async {
    final dirList = await getDownload();
    final path = dirList![0].path;
    final file = File('/storage/emulated/0/Download/$roomName');
    recordingFile = file;
    engine
        ?.startAudioRecordingWithConfig(AudioRecordingConfiguration(
      '${file.path}.AAC',
      recordingQuality: AudioRecordingQuality.Medium,
    ))
        .then((value) {
      print('recording');
      recordingPath = file.path;
      print(recordingPath);
    });
  }

  static stopRecording() {
    engine?.stopAudioRecording();
  }
}
