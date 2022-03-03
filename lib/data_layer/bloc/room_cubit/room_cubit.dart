import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomCubit extends Cubit<RoomStates> {
  RoomCubit() : super(Appintistate());
  static RoomCubit get(context) => BlocProvider.of(context);
}
