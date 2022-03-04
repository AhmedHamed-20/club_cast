import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/general_app_cubit_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralAppcubit extends Cubit<GeneralAppStates> {
  GeneralAppcubit() : super(Appintistate());
  static GeneralAppcubit get(context) => BlocProvider.of(context);
}
