import 'package:club_cast/presentation_layer/screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/public_rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'general_app_cubit_states.dart';

class GeneralAppCubit extends Cubit<GeneralAppStates> {
  GeneralAppCubit() : super(InitialAppState());
  static GeneralAppCubit get(context) => BlocProvider.of(context);

  //////////// variable ///////////////////

  int bottomNavIndex = 0;

  var roomNameController = TextEditingController();
  bool isPublicRoom = true;
  bool isRecordRoom = false;

  List<BottomNavigationBarItem> bottomNavBarItem = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.headphones),
      label: 'podCast',
    ),
  ];

  List<Widget> screen = [
    PublicRoomScreen(),
    const PodCastScreen(),
  ];

  static List<String> category = [
    'sport',
    'economy',
    'reading',
    'hunter',
  ];
  String selectedCategoryItem = category.first;
  //////////// Methods ///////////////////

  void changeBottomNAvIndex(int index) {
    bottomNavIndex = index;
    emit(ChangeBottomNavIndex());
  }
}
