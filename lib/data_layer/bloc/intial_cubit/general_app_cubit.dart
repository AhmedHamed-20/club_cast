import 'dart:io';

import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/podcastLikesScreen.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/public_rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? activePodCastId;
  int counter = 0;
  double currentPostionDurationInsec = 0;
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

  void playingPodcast(String url, String name, String iconurl,
      String activePodCastIdnow) async {
    if (pressedPause && activePodCastId == activePodCastIdnow) {
      assetsAudioPlayer.play();
      activePodCastId = activePodCastIdnow;
      print('nowwwww' + activePodCastId!);
      isPlaying = true;
      pressedPause = false;
      emit(ChangePlayingState());
    } else {
      try {
        await assetsAudioPlayer.stop().then((value) async {
          await assetsAudioPlayer.open(
            Audio.network(url),
            showNotification: true,
            notificationSettings: NotificationSettings(
                stopEnabled: true,
                customPlayPauseAction: (_) {
                  pressedPause
                      ? assetsAudioPlayer.play().then((value) {
                          isPlaying = true;
                          pressedPause = false;
                          changeState();
                        })
                      : assetsAudioPlayer.pause().then((value) {
                          isPlaying = false;
                          pressedPause = true;
                          changeState();
                        });
                }),
          );
          assetsAudioPlayer.updateCurrentAudioNotification(
            metas: Metas(
              title: name,
              image: MetasImage.network(iconurl),
            ),
          );
          activePodCastId = activePodCastIdnow;
          print('nowwww' + activePodCastId!);
          assetsAudioPlayer.currentPosition.listen((event) {
            print(event);

            currentPostionDurationInsec = event.inSeconds.toDouble();
            currentOlayingDurathion = event.toString().substring(0, 7);
            //print(currentOlayingDurathion);
            if (event.inSeconds == 00.000000) {
              isPlaying = false;
              pressedPause = false;
              emit(ChangePlayingState());
            } else {
              isPlaying = true;
              emit(ChangePlayingState());
            }
          });
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

      progress = ((rec / total));
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

  void getPodCastLikes(
      {required String token,
      required String podCastId,
      required BuildContext context}) {
    DioHelper.getDate(
        url: getPodcastLikesUsers + podCastId,
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      GetPodCastUsersLikesModel.getAllPodCastLikes =
          Map<String, dynamic>.from(value.data);
      navigatePushTo(context: context, navigateTo: PodCastLikesScreen());
      //  print(GetPodCastUsersLikesModel.getPhotoUrltName(1));
    }).catchError((onError) {
      print(onError);
    });
  }

  bool isLoadProfile = false;
  void getUserData({
    required String token,
  }) {
    isLoadProfile = true;
    emit(UserDataLoadingState());
    DioHelper.getDate(
      url: profile,
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      GetUserModel.getUserModel = Map<String, dynamic>.from(value.data);
      print(GetUserModel.getUserName());
      isLoadProfile = false;
      emit(UserDataSuccessState());
    }).catchError((error) {
      print(error);
      emit(UserDataErrorState(error.toString()));
    });
  }

  void updateUserData({
    required String name1,
    required String email1,
    required String token,
  }) {
    emit(UpdateUserLoadingState());
    DioHelper.patchData(
      url: updateProfile,
      name: name1,
      email: email1,
      token: token,
    ).then((value) {
      print(value);
      GetUserModel.updateName(name1);
      GetUserModel.updateEmail(email1);
      emit(DataUpdatedSuccess());
      showToast(
        message: 'Update Success',
        toastState: ToastState.SUCCESS,
      );
    }).catchError((error) {
      print(error);
      if (error.response!.statusCode == 400) {
        showToast(
          message: "this user already exist",
          toastState: ToastState.ERROR,
        );
        emit(UpdateUserErrorState(error));
      }
    });
  }

  void updatePassword({
    required String password_Current,
    required String password_New,
    required String password_Confirm,
    required String token,
  }) {
    emit(UpdatePasswordLoadingState());
    DioHelper.patchPassword(
      url: update_Password,
      passwordCurrent: password_Current,
      passwordNew: password_New,
      passwordConfirm: password_Confirm,
      token: token,
    ).then((value) {
      String newToken = value.data['token'];
      CachHelper.setData(key: 'token', value: newToken);
      ahmedModel = UserLoginModel.fromJson(value.data);
      emit(UpdatePasswordSuccessState(ahmedModel!));
      showToast(
        message: 'Update Success',
        toastState: ToastState.SUCCESS,
      );
    }).catchError((error) {
      print(error.toString());
      if (error.response!.statusCode == 400) {
        if (password_New.length < 8) {
          showToast(
            message: "password must have more or equal than 8 characters!",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState(error));
        } else if (password_New != password_Confirm) {
          showToast(
            message: " Passwords are not the same!",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState(error));
        } else {
          showToast(
            message: "error,check your data",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState(error));
        }
      } else if (error.response!.statusCode == 401) {
        showToast(
          message: "This isn't current password",
          toastState: ToastState.ERROR,
        );
        emit(UpdatePasswordErrorState(error));
      }
    });
  }

  UserModelId? userId;
  bool isLoading = false;
  void getUserById({
    required String profileId,
    Map<String, dynamic>? save,
  }) {
    isLoading = true;
    emit(GetUserByIdLoadingState());
    DioHelper.getDate(
      url: userById + profileId,
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      // SaveDataModel.savaData=Map<String, dynamic>.from(value.data);
      userId = UserModelId.fromJson(value.data);

      emit(GetUserByIdSuccessState());
      isLoading = false;
    }).catchError((error) {
      print(error);
      emit(GetUserByIdErrorState());
    });
  }

  void followUser({
    required String userProfileId,
  }) {
    emit(FollowUserLoadingState());
    DioHelper.postData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      emit(FollowUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(FollowUserErrorState());
    });
  }

  void unFollowUser({
    required String userProfileId,
  }) {
    emit(UnFollowUserLoadingState());
    DioHelper.deleteData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      emit(UnFollowUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(UnFollowUserErrorState());
    });
  }

  bool isFollowing = false;
  void toggleFollowing() {
    isFollowing = !isFollowing;
    emit(ChangeFollowingState());
  }
}
