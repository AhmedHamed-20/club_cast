import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/getAllRoomsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agora/rtc_engine.dart';

class RoomCubit extends Cubit<RoomStates> {
  RoomCubit() : super(Appintistate());
  static RoomCubit get(context) => BlocProvider.of(context);
//////var/////////////////////////
  bool muted = false;
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
}
