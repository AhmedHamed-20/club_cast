import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/getAllRoomsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agora/rtc_engine.dart';

class RoomCubit extends Cubit<RoomStates> {
  RoomCubit() : super(Appintistate());
  static RoomCubit get(context) => BlocProvider.of(context);
//////var/////////////////////////
  static bool muted = false;
  List speakers = [];
  List listener = [];
  List askedToTalk = [];

/////////Func/////////////////////

  void onToggleMute() {
    muted = !muted;
    emit(ToggleMute());

    AgoraRtc.engine?.muteLocalAudioStream(muted);
  }

  Future getAllRoomsData() {
    return DioHelper.getData(
      url: getAllRooms,
      token: {'Authorization': 'Bearer $token'},
    ).then(
      (value) {
        GetAllRoomsModel.getAllRooms = Map<String, dynamic>.from(value.data);
        emit(GetAllRoomDataGetSuccess());
      },
    ).catchError(
      (onError) {
        emit(GetAllRoomDataGetError());
      },
    );
  }

  Future getRoomData(String token, String roomId) {
    return DioHelper.getData(
        url: getRoom + roomId,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      // speakers = [value.data['data']['admin']];

      // speakers.addAll(value.data['data']['brodcasters']);
      // speakers.forEach((e) {
      //   e['isMuted'] = false;
      //   e['isTalking'] = false;
      // });
      // listener.addAll([value.data['data']['audience']]);
      // listener.forEach((e) {
      //   e['askedToTalk'] = false;
      //   e['isSpeaker'] = false;
      //   e['isMuted'] = false;
      //   e['isTalking'] = false;
      // });
      activeRoomName = value.data['data']['name'];
      emit(GetRoomDataGetSuccess());
    }).catchError((onError) {
      emit(GetRoomDataGetError());
    });
  }

  changeState() {
    emit(GetRoomDataGetSuccess());
  }

  changeState2() {
    emit(GetRoomDataGetError());
  }
}
