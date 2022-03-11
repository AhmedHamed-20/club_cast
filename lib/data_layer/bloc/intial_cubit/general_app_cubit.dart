import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
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

  GetAllPodCastModel? podcastModel;
  void getAllPodcast({required String token}) {
    print(token);
    DioHelper.getDate(
      url: GetAllPodcasts,
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then(
      (value) {
        //  print(value.data);
        GetAllPodCastModel.getAllPodCast =
            Map<String, dynamic>.from(value.data);
        emit(PodCastDataGetSuccess());
        //  print(GetAllPodCastModel.getPodcastName(2));
      },
    ).catchError(
      (onError) {
        print(onError);
        emit(PodCastDataGetError());
      },
    );
  }

  void addLike({required String podCastId, required String token}) {
    DioHelper.postData(
        url: sendLike + '/${podCastId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      getAllPodcast(token: token);
      emit(PodCastLikeAddedSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PodCastLikeAddedError());
    });
  }
}
