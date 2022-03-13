import 'dart:io';

import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/public_rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'general_app_cubit_states.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class GeneralAppCubit extends Cubit<GeneralAppStates> {
  GeneralAppCubit() : super(InitialAppState());
  static GeneralAppCubit get(context) => BlocProvider.of(context);

  //////////// variable ///////////////////

  int bottomNavIndex = 0;

  var roomNameController = TextEditingController();
  bool isPublicRoom = true;
  bool isRecordRoom = false;
  bool isDark = false;
  bool isPlaying = false;
  bool pressedPause = false;
  bool isDownloading = false;
  int counter = 0;
  double? progress;
  String? currentOlayingDurathion;
  final assetsAudioPlayer = AssetsAudioPlayer();
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
  void toggleDark() {
    isDark = !isDark;
    emit(ChangeTheme());
  }

  void togglePlaying() {
    isPlaying = !isPlaying;
    emit(ChangePlayingState());
  }

  void changeBottomNAvIndex(int index) {
    bottomNavIndex = index;
    emit(ChangeBottomNavIndex());
  }

  void changeState() {
    emit(ChangePlayingState());
  }

  void playingPodcast(String url, String name, String iconurl) async {
    if (pressedPause) {
      assetsAudioPlayer.play();
      isPlaying = true;
      emit(ChangePlayingState());
    } else {
      try {
        await assetsAudioPlayer.open(
          Audio.network(url),
          showNotification: true,
        );
        assetsAudioPlayer.updateCurrentAudioNotification(
          metas: Metas(
            title: name,
            image: MetasImage.network(iconurl),
          ),
        );

        assetsAudioPlayer.currentPosition.listen((event) {
          print(event);
          currentOlayingDurathion = event.toString().substring(0, 7);
          if (event.inSeconds == 00.000000) {
            isPlaying = false;
            pressedPause = false;
            emit(ChangePlayingState());
          } else {
            isPlaying = true;
            emit(ChangePlayingState());
          }
        });

        //togglePlaying();
      } catch (t) {
        showToast(message: 'Error on Playing', toastState: ToastState.ERROR);
        emit(PlayingStateError());
        print(t);
        //mp3 unreachable
      }
    }
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

  void removeLike({required String podCastId, required String token}) {
    DioHelper.deleteData(
        url: sendLike + '/${podCastId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      getAllPodcast(token: token);
      emit(PodCastLikeDeleatedSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PodCastLikeDeleatedError());
    });
  }

  Future<List<Directory>?> getDownloadPath() {
    return path.getExternalStorageDirectories(
        type: path.StorageDirectory.documents);
  }

  Future downloadPodCast(String url, String fileName) async {
    final dirList = await getDownloadPath();
    final path = dirList![0].path;
    final file = File('$path/$fileName');

    await DioHelper.dio!.download(url, file.path,
        onReceiveProgress: (rec, total) {
      isDownloading = true;

      emit(FileDownloading());

      progress = ((rec / total) * 100);
      print(progress);
      counter++;
    }).then((value) {
      var fullPath = file.path;
      isDownloading = false;
      emit(FileDownloadSuccess());
      showToast(
          message: 'FileSaveSuccessTo ${fullPath}',
          toastState: ToastState.SUCCESS);
      print(fullPath);
    }).catchError(
      (onError) {
        print(onError);
        showToast(message: 'DownlaodError', toastState: ToastState.ERROR);
        emit(FileDownloadError());
      },
    );
  }
}
