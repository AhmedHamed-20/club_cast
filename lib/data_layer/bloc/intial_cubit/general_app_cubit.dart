import 'dart:io';

import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/category_model.dart';
import 'package:club_cast/presentation_layer/models/getMyPodCastModel.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/podcastLikesScreen.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/public_rooms_screen.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation_layer/models/followers_following_model.dart';
import '../../../presentation_layer/models/getMyFollowingPodcast.dart';
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
  bool previewIsplaying = false;
  File? podcastFile;
  bool isProfilePage = false;
  bool isLoadingprofile = false;
  // bool isDark = false;
  bool isPlaying = false;
  bool isMyfollowingScreen = false;
  bool isMyprofileScreen = false;
  bool pressedPause = false;
  bool isDownloading = false;
  bool isPausedInHome = false;
  bool? isDark = false;
  String? activePodcastname = '';
  String? activepodcastPhotUrl = '';
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
  getDark(bool isDARK) {
    print(isDARK);
    isDark = isDARK;
    emit(ChangeTheme());
  }

  static List<String> category = ['ai'];
  String selectedCategoryItem = category.first;
  //////////// Methods ///////////////////

  void toggleDark() {
    isDark = !isDark!;
    CachHelper.setData(key: 'isDark', value: isDark).then((value) {
      print(isDark);
      print('cachValue:${value}');
      emit(ChangeTheme());
    });
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

  void getAllCategory() {
    emit(GetAllCategoryLoadingState());
    DioHelper.getData(
      url: AllCategory,
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      CategoryModel.allCategory = Map<String, dynamic>.from(value.data);
      // print(CategoryModel.allCategory);
      for (int i = 1; i <= CategoryModel.allCategory!['results'] - 1; i++) {
        category.add(CategoryModel.allCategory!['data']['data'][i]['name']);
      }
      print(category);

      emit(GetAllCategorySuccessState());
    }).catchError((error) {
      print('error when getCategory :${error.toString()}');
      emit(GetAllCategoryErrorState());
    });
  }

  void playingPodcast(
    String url,
    String name,
    String iconurl,
    String activePodCastIdnow,
  ) async {
    if (pressedPause && activePodCastId == activePodCastIdnow) {
      assetsAudioPlayer.play();
      activePodCastId = activePodCastIdnow;
      activePodcastname = name;
      activepodcastPhotUrl = iconurl;
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

          activePodcastname = name;
          activepodcastPhotUrl = iconurl;
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
    if (token == '') {
    } else {
      DioHelper.getData(
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
  }

  Future addLike(
      {required String podCastId,
      required String token,
      String? userId}) async {
    return await DioHelper.postData(
        url: sendLike + '${podCastId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      //   isProfilePage ? getUserPodcast(token, userId!) : const SizedBox();
      emit(PodCastLikeAddedSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PodCastLikeAddedError());
    });
  }

  Future removeLike(
      {required String podCastId,
      required String token,
      String? userId}) async {
    return await DioHelper.deleteData(
        url: sendLike + '${podCastId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      //  isProfilePage ? getUserPodcast(token, userId!) : const SizedBox();
      emit(PodCastLikeDeleatedSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PodCastLikeDeleatedError());
    });
  }

  Future getMyPodCast(String token) async {
    return await DioHelper.getData(
        url: getMyPodCasts,
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      GetMyPodCastModel.getMyPodCast = Map<String, dynamic>.from(value.data);
      print(GetMyPodCastModel.getMyPodCast);
      isLoadProfile = false;
      emit(GetMyPodCastSuccessState());
    }).catchError((onError) {
      emit(GetMyPodCastErrorState());
      print(onError);
    });
  }

  Future getMyFollowingPodcast(String token) {
    return DioHelper.getData(
            token: {'Authorization': 'Bearer ${token}'},
            url: getMyFollowingPodcasts)
        .then((value) {
      GetMyFollowingPodCastsModel.getMyFollowingPodcasts =
          Map<String, dynamic>.from(value.data);
      print('data: ${GetMyFollowingPodCastsModel.getMyFollowingPodcasts}');
      emit(GetMyFollowingSuccessState());
    }).catchError((onError) {
      emit(GetMyFollowinErrorState());
      print(onError);
    });
  }

  pickPocCastFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      podcastFile = File(result.files.single.path!);
      print(podcastFile?.path);
      emit(FilePickedSuccess());
    } else {
      emit(FilePickedError());
      // User canceled the picker
    }
  }

  playPreviewPodcast() {
    assetsAudioPlayer.open(Audio.file(podcastFile!.path)).then((value) {
      previewIsplaying = true;
      emit(PreviewPlaying());
    }).catchError((onError) {
      emit(PreviewPlayingError());
      print(onError);
    });
  }

  pausePreview() {
    assetsAudioPlayer.pause().then((value) {
      previewIsplaying = false;
      emit(PreviewStoped());
    }).catchError((onError) {
      print(onError);
    });
  }

  Future getUserPodcast(String token, String userId) async {
    return await DioHelper.getData(
        url: getuserPodCast + '${userId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      GetAllPodCastModel.getAllPodCast = Map<String, dynamic>.from(value.data);
      isLoadingprofile = false;
      emit(PodCastDataGetSuccess());
    }).catchError((error) {
      emit(PodCastDataGetError());
      print(error);
    });
  }

  bool isLoadPodCast = false;
  bool isUploading = false;
  double? uploadProgress;
  void uploadPodCast(String token, String podCastName, String category) async {
    isLoadPodCast = true;
    emit(PodcastUploadedLoading());
    await DioHelper.dio!
        .get(generateSignature,
            options: Options(
              headers: {'Authorization': 'Bearer ${token}'},
            ))
        .then((value) async {
      //timestamp
      //signature
      //cloudName
      //apiKey

      String podcastname = podcastFile!.path.split('/').last;
      var cloudname = value.data['cloudName'];
      var timestamp = value.data['timestamp'];
      var signature = value.data['signature'];
      var apiKey = value.data['apiKey'];
      print(podcastFile!.path);
      DioHelper.dio!.post(
        'https://api.cloudinary.com/v1_1/${cloudname}/video/upload?api_key=${apiKey}&timestamp=${timestamp}&signature=${signature}',
        options: Options(
          headers: {'Authorization': 'Bearer ${token}'},
        ),
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            podcastFile!.path,
            filename: podcastname,
            contentType: MediaType('audio', 'mp3'),
          ),
          'folder': 'podcasts',
          'resource_type': 'auto',
        }),
        onSendProgress: (whatsend, total) {
          isUploading = true;
          isLoadPodCast = false;
          emit(PodcastUploadedNow());
          uploadProgress = whatsend / total;
        },
      ).then((value) {
        print(value);
        isUploading = false;
        isLoadPodCast = true;
        emit(CreatePodcastInServer());
        DioHelper.dio!.post(createPodCast,
            options: Options(
              headers: {'Authorization': 'Bearer ${token}'},
            ),
            data: {
              'name': podCastName,
              'category': category,
              'audio': {'public_id': value.data['public_id']}
            }).then((value) {
          print('yessss');
          getMyPodCast(token);
          isLoadPodCast = false;
          showToast(
              message: 'PodCast Uploaded Success',
              toastState: ToastState.SUCCESS);
          emit(PodcastUploadedSuccess());
          print(value);
        }).catchError((error) {
          isLoadPodCast = false;
          isUploading = false;
          showToast(
              message: 'PodCast Uploaded Error', toastState: ToastState.ERROR);
          emit(PodcastUploadedError());
          print(error.message);
        });
      }).catchError((onError) {
        showToast(
            message: 'PodCast Uploaded Error', toastState: ToastState.ERROR);
        isLoadPodCast = false;
        isUploading = false;
        emit(PodcastUploadedError());
        print(onError);
      });
    }).catchError((onError) {
      showToast(
          message: 'PodCast Uploaded Error', toastState: ToastState.ERROR);
      isLoadPodCast = false;
      isUploading = false;
      emit(PodcastUploadedError());
      print(onError);
    });
  }

  Future removePodCast(String podCastId, String token) async {
    return await DioHelper.deleteData(
        url: removePodCastById + '${podCastId}',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      getMyPodCast(token);
      emit(PodCastDeletedSuccess());
    }).catchError((onError) {
      print(onError);
      emit(PodCastDeletedError());
    });
  }

  Future<List<Directory>?> getDownloadPath() {
    return path.getExternalStorageDirectories(
        type: path.StorageDirectory.documents);
  }

  String? downloadedPodCastId;
  Future downloadPodCast(String url, String fileName, String podcastId) async {
    downloadedPodCastId = podcastId;
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
    DioHelper.getData(
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
    if (token == '') {
    } else {
      isLoadProfile = true;
      emit(UserDataLoadingState());
      DioHelper.getData(
        url: profile,
        token: {
          'Authorization': 'Bearer ${token}',
        },
      ).then((value) {
        GetUserModel.getUserModel = Map<String, dynamic>.from(value.data);
        print(GetUserModel.getUserName());
        // isLoadProfile = false;
        emit(UserDataSuccessState());
      }).catchError((error) {
        print(error);
        emit(UserDataErrorState(error.toString()));
      });
    }
  }

  bool isUpdateUserData = false;
  void updateUserData({
    required String name1,
    required String email1,
    required String token,
  }) {
    emit(UpdateUserLoadingState());
    isUpdateUserData = true;
    DioHelper.patchData(
      url: updateProfile,
      name: name1,
      email: email1,
      token: token,
    ).then((value) {
      print(value);
      GetUserModel.updateName(name1);
      GetUserModel.updateEmail(email1);
      isUpdateUserData = false;
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

  Future getUserById({
    required String profileId,
    Map<String, dynamic>? save,
  }) async {
    isLoadingprofile = true;
    emit(GetUserByIdLoadingState());
    return await DioHelper.getData(
      url: userById + profileId,
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      // SaveDataModel.savaData=Map<String, dynamic>.from(value.data);
      userId = UserModelId.fromJson(value.data);

      emit(GetUserByIdSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetUserByIdErrorState());
    });
  }

  Future followUser({
    required String userProfileId,
  }) async {
    emit(FollowUserLoadingState());
    return await DioHelper.postData(
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

  Future unFollowUser({
    required String userProfileId,
  }) async {
    emit(UnFollowUserLoadingState());
    return await DioHelper.deleteData(
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

  bool isSearch = false;
  Map<String, dynamic>? search;
  void userSearch({
    required String token,
    required String value,
  }) {
    isSearch = true;
    emit(SearchUserLoadingState());
    DioHelper.getData(
      url: searchUser + value,
      token: {'Authorization': 'Bearer $token'},
    ).then((value) {
      isSearch = false;
      emit(SearchUserSuccessState());
      search = Map<String, dynamic>.from(value.data);
    }).catchError((onError) {
      emit(SearchUserErrorState());
      print(onError);
    });
  }

  bool followerLoad = false;
  void getMyFollowers({
    required String token,
  }) {
    emit(GetMyFollowersLoadingState());
    followerLoad = true;
    DioHelper.getData(url: myFollowers, token: {
      'Authorization': 'Bearer ${token}',
    }).then((value) {
      Followers.followersModel = Map<String, dynamic>.from(value.data);
      emit(GetMyFollowersSuccessState());
      followerLoad = false;
    }).catchError((onError) {
      emit(GetMyFollowersErrorState());
      print(onError);
    });
  }

  bool followingLoad = false;
  void getMyFollowing({
    required String token,
  }) {
    emit(GetMyFollowingLoadingState());
    followingLoad = true;
    DioHelper.getData(url: myFollowing, token: {
      'Authorization': 'Bearer ${token}',
    }).then((value) {
      Following.followingModel = Map<String, dynamic>.from(value.data);
      emit(GetMyFollowingUsersSuccessState());
      followingLoad = false;
    }).catchError((onError) {
      emit(GetMyFollowingErrorState());
      print(onError);
    });
  }

  void userFollowers({
    required String userProfileId,
  }) {
    emit(UserFollowersLoadingState());
    followerLoad = true;
    DioHelper.getData(
      url: 'v1/users/$userProfileId/followers',
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      Followers.followersModel = Map<String, dynamic>.from(value.data);
      emit(UserFollowersSuccessState());
      followerLoad = false;
    }).catchError((error) {
      emit(UserFollowersErrorState());
      print(error);
    });
  }

  void userFollowing({
    required String userProfileId,
  }) {
    emit(UserFollowingLoadingState());
    followingLoad = true;
    DioHelper.getData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      Following.followingModel = Map<String, dynamic>.from(value.data);
      emit(UserFollowingSuccessState());
      followingLoad = false;
    }).catchError((error) {
      emit(UserFollowingErrorState());
      print(error);
    });
  }

  File? profileAvatar;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      profileAvatar = File(image.path);
      print(profileAvatar);

      emit(UserAvatarState());
    } on PlatformException catch (e) {
      print('error when pick image from galary:${e.toString()}');
    }
  }

  bool isUploadPhoto = false;
  void setAvatar(BuildContext context) async {
    emit(UserUpdateAvatarLoadingState());
    isUploadPhoto = true;

    print(CachHelper.getData(key: 'token'));
    print(profileAvatar!.path);
    await DioHelper.uploadImage(
            url: updateProfile,
            image: profileAvatar,
            token: CachHelper.getData(key: 'token'))
        .then((value) {
      print(value.data);
      showToast(
          message: 'update avatar is succeeded',
          toastState: ToastState.SUCCESS);
      isUploadPhoto = false;
      emit(UserUpdateAvatarSuccessState());
    }).catchError((error) {
      print("error when set user avatar :${error.toString()}");
      emit(UserUpdateAvatarErrorState());
    });
  }
}
