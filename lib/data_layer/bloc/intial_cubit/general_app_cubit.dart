import 'package:club_cast/presentation_layer/screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/public_rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'general_app_cubit_states.dart';

class GeneralAppCubit extends Cubit<GeneralAppStates> {
  GeneralAppCubit() : super(InitialAppState());
  static GeneralAppCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  List<BottomNavigationBarItem> bottomNavBarItem = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.add,
      ),
      label: 'add',
    ),
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.music),
      label: 'home',
    ),
  ];

  List<Widget> screen = [
    PublicRoomScreen(),
    PodCastScreen(),
    PodCastScreen(),
  ];

  void changeBottomNAvIndex(int index) {
    bottomNavIndex = index;
    emit(ChangeBottomNavIndex());
  }
}
