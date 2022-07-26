import 'dart:async';
import 'dart:io';

import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/category_model.dart';
import 'package:club_cast/presentation_layer/models/create_event_model.dart';
import 'package:club_cast/presentation_layer/models/explore_podcasts_model.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingEvents.dart';
import 'package:club_cast/presentation_layer/models/getMyPodCastModel.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/get_my_events.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:club_cast/presentation_layer/models/pod_cast_search_model.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/podcastLikesScreen.dart';
import 'package:club_cast/presentation_layer/screens/podcast_screens/podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/public_rooms_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

import '../../../presentation_layer/models/downloaded_podcasts_moder.dart';
import '../../../presentation_layer/models/followers_following_model.dart';
import '../../../presentation_layer/models/getAllRoomsModel.dart';
import '../../../presentation_layer/models/getMyFollowingPodcast.dart';
import '../../../presentation_layer/models/searchRoomsModel.dart';
import 'general_app_cubit_states.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class GeneralAppCubit extends Cubit<GeneralAppStates> {
  GeneralAppCubit() : super(InitialAppState());
  static GeneralAppCubit get(context) => BlocProvider.of(context);

  //////////// variable ///////////////////
  int bottomNavIndex = 0;
  bool loadRoom = false;
  var roomNameController = TextEditingController();
  bool isPublicRoom = true;
  bool isRecordRoom = false;
  bool previewIsplaying = false;
  File? podcastFile;
  bool isLocalPodcastval = false;
  bool isProfilePage = false;
  bool isLoadingprofile = false;
  int pagemyfollowingPodcast = 2;
  bool noDataMyfollowingPodcast = false;
  bool loadMyFollowinPodcast = false;
  int pageExplore = 2;
  bool noDataExplore = false;
  bool loadExplore = false;
  bool noDateRooms = false;
  bool loadRooms = false;
  bool keepScreenAwake = false;
  int pageRooms = 2;
  bool noDataEvent = false;
  bool loadEvent = false;

  int pageEvent = 2;
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
  bool isExplore = false;
  int counter = 0;
  double currentPostionDurationInsec = 0;
  double? progress;
  String? currentplayingDurathion;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool internetConnection = true;
  bool isSearchScreen = false;
  List<NavigationDestination> bottomNavBarItem = const [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'home',
    ),
    NavigationDestination(
      icon: Icon(Icons.add),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.headphones),
      label: 'podCast',
    ),
  ];

  List<Widget> screen = [
    const PublicRoomScreen(),
    Container(),
    PodCastScreen(),
  ];
  getDark(bool isDARK) {
    isDark = isDARK;
    emit(ChangeTheme());
  }

  static List<String> category = ['ai'];
  String selectedCategoryItem = category.first;
  //////////// Methods ///////////////////

  void toggleDark() {
    isDark = !isDark!;
    CachHelper.setData(key: 'isDark', value: isDark).then((value) {
      emit(ChangeTheme());
    });
  }

  void toggleScreenAwake(bool val) {
    Wakelock.toggle(enable: val);
    keepScreenAwake = val;
    emit(ChangeScreenAwakeState());
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
    emit(ChangeState());
  }

  void getAllCategory() {
    if (token == '') {
      return;
    }
    emit(GetAllCategoryLoadingState());
    DioHelper.getData(
      url: AllCategory,
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      category = ['ai'];
      CategoryModel.allCategory = Map<String, dynamic>.from(value.data);
      // odel.allCategory);
      for (int i = 1; i <= CategoryModel.allCategory!['results'] - 1; i++) {
        category.add(CategoryModel.allCategory!['data']['data'][i]['name']);
      }

      emit(GetAllCategorySuccessState());
    }).catchError((error) {
      emit(GetAllCategoryErrorState());
    });
  }

  void playingPodcast(
      String url,
      String name,
      String iconurl,
      String activePodCastIdnow,
      BuildContext context,
      bool isLocalPodcast) async {
    isLocalPodcastval = isLocalPodcast;

    if (pressedPause && activePodCastId == activePodCastIdnow) {
      assetsAudioPlayer.play();
      activePodCastId = activePodCastIdnow;

      activePodcastname = name;

      activepodcastPhotUrl = iconurl;

      isPlaying = true;
      pressedPause = false;
      emit(ChangePlayingState());
    } else {
      try {
        await assetsAudioPlayer.stop().then((value) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: Text(
                'Loading',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),
            ),
          );
          if (isLocalPodcastval) {
            await assetsAudioPlayer.open(
              Audio.file(url),
              showNotification: true,
              notificationSettings: NotificationSettings(
                  stopEnabled: true,
                  customNextIcon: AndroidResDrawable(name: 'ic_next_custom'),
                  customPreviousIcon:
                      AndroidResDrawable(name: 'ic_prev_custom'),
                  customNextAction: (assetaudio) {
                    assetaudio.seekBy(
                      const Duration(seconds: 10),
                    );
                  },
                  customPrevAction: (assetaudio) {
                    assetaudio.seekBy(
                      const Duration(seconds: -10),
                    );
                  },
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
          } else {
            await assetsAudioPlayer.open(
              Audio.network(url),
              showNotification: true,
              notificationSettings: NotificationSettings(
                  stopEnabled: true,
                  customNextIcon: AndroidResDrawable(name: 'ic_next_custom'),
                  customPreviousIcon:
                      AndroidResDrawable(name: 'ic_prev_custom'),
                  customNextAction: (assetaudio) {
                    assetaudio.seekBy(
                      const Duration(seconds: 10),
                    );
                  },
                  customPrevAction: (assetaudio) {
                    assetaudio.seekBy(
                      const Duration(seconds: -10),
                    );
                  },
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
          }
          activePodcastname = name;

          activepodcastPhotUrl = iconurl;
          assetsAudioPlayer.updateCurrentAudioNotification(
            metas: Metas(
              title: name,
              image: MetasImage.network(iconurl),
            ),
          );
          activePodCastId = activePodCastIdnow;

          assetsAudioPlayer.currentPosition.listen((event) {
            currentPostionDurationInsec = event.inSeconds.toDouble();
            currentplayingDurathion = event.toString().substring(0, 7);
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
      } catch (t) {
        showToast(message: 'Error on Playing', toastState: ToastState.ERROR);
        emit(PlayingStateError());
      }
    }
  }

  pageinathionExplore(
    String token,
  ) {
    loadExplore = true;
    emit(LoadDataPaginattion());
    DioHelper.getData(
        url: getAllPodCastWithoutMe + '?page=$pageExplore',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      // a['results']);

      //   a);
      if (value.data['results'] == 0) {
        pageExplore = pageExplore;
        noDataExplore = true;
        emit(DataPaginattiongetSuccess());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadExplore = false;
      } else {
        pageExplore++;

        GetExplorePodCastModel.getExplorePodCast?['data']
            .addAll(value.data['data']);

        loadExplore = false;
        emit(DataPaginattiongetSuccess());
      }
    }).onError((error, stackTrace) {
      loadExplore = false;
      emit(DataPaginattiongetError());
    });
  }

  pageinathionMyFollowingPodcast(
    String token,
  ) {
    loadMyFollowinPodcast = true;
    emit(LoadDataPaginattion());
    DioHelper.getData(
        url: getMyFollowingPodcasts + '?page=$pagemyfollowingPodcast',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      // a['results']);

      //   a);
      if (value.data['results'] == 0) {
        pagemyfollowingPodcast = pagemyfollowingPodcast;
        noDataMyfollowingPodcast = true;
        emit(DataPaginattiongetSuccess());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadMyFollowinPodcast = false;
      } else {
        pagemyfollowingPodcast++;

        GetMyFollowingPodCastsModel.getMyFollowingPodcasts?['data']
            .addAll(value.data['data']);

        loadMyFollowinPodcast = false;
        emit(DataPaginattiongetSuccess());
      }
    }).onError((error, stackTrace) {
      loadMyFollowinPodcast = false;
      emit(DataPaginattiongetError());
    });
  }

  void getAllPodcast({required String token}) {
    if (token == '') {
    } else {
      DioHelper.getData(
        url: GetAllPodcasts,
        token: {
          'Authorization': 'Bearer $token',
        },
      ).then(
        (value) {
          //  a);
          GetAllPodCastModel.getAllPodCast =
              Map<String, dynamic>.from(value.data);
          emit(PodCastDataGetSuccess());
          //  CastModel.getPodcastName(2));
        },
      ).catchError(
        (onError) {
          emit(PodCastDataGetError());
        },
      );
    }
  }

  bool loadingExplore = false;
  Future getExplorePodcast({required String token}) async {
    loadingExplore = true;

    if (token == '') {
    } else {
      return await DioHelper.getData(
        url: getAllPodCastWithoutMe,
        token: {
          'Authorization': 'Bearer $token',
        },
      ).then(
        (value) {
          //  a);
          GetExplorePodCastModel.getExplorePodCast =
              Map<String, dynamic>.from(value.data);
          loadingExplore = false;
          pageExplore = 2;
          noDataExplore = false;
          emit(PodCastDataGetSuccess());
          //  CastModel.getPodcastName(2));
        },
      ).catchError(
        (onError) {
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
        url: sendLike + podCastId,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      //   isProfilePage ? getUserPodcast(token, userId!) : const SizedBox();
      emit(PodCastLikeAddedSuccess());
    }).catchError((onError) {
      emit(PodCastLikeAddedError());
    });
  }

  Future removeLike(
      {required String podCastId,
      required String token,
      String? userId}) async {
    return await DioHelper.deleteData(
        url: sendLike + podCastId,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      //  isProfilePage ? getUserPodcast(token, userId!) : const SizedBox();
      emit(PodCastLikeDeleatedSuccess());
    }).catchError((onError) {
      emit(PodCastLikeDeleatedError());
    });
  }

  Future getMyPodCast(String token, context) async {
    return await DioHelper.getData(
        url: getMyPodCasts,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      GetMyPodCastModel.getMyPodCast = Map<String, dynamic>.from(value.data);

      isLoadProfile = false;
      pageMyPodcasts = 2;
      noDataMyPodcasts = false;
      emit(GetMyPodCastSuccessState());
    }).catchError((onError) {
      emit(GetMyPodCastErrorState());
    });
  }

  Future getMyFollowingPodcast(String token, context) async {
    if (token == '') {
      return 'dad';
    }
    return await DioHelper.getData(
            token: {'Authorization': 'Bearer $token'},
            url: getMyFollowingPodcasts)
        .then((value) {
      GetMyFollowingPodCastsModel.getMyFollowingPodcasts =
          Map<String, dynamic>.from(value.data);

      pagemyfollowingPodcast = 2;
      noDataMyfollowingPodcast = false;
      emit(GetMyFollowingSuccessState());
    }).onError((DioError error, s) {
      (DioError error, s) {
        if (error.response?.statusCode == 401) {
          navigatePushANDRemoveRout(
              context: context, navigateTo: LoginScreen());
          token = '';
          isPlaying = false;
          isPausedInHome = false;
          GeneralAppCubit.get(context).search = null;
          currentplayingDurathion = null;
          activePodCastId = null;
          currentPostionDurationInsec = 0;
          showToast(
              message: 'please login again', toastState: ToastState.ERROR);
        }
        emit(GetMyFollowinErrorState());
      };
    });
  }

  Future<int>? pickedPodCastLength;
  pickPocCastFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      podcastFile = File(result.files.single.path!);

      pickedPodCastLength = podcastFile!.length();

      emit(FilePickedSuccess());
    } else {
      emit(FilePickedError());
      // User canceled the picker
    }
  }

  playPreviewPodcast(String filePath) {
    assetsAudioPlayer.open(Audio.file(filePath)).then((value) {
      previewIsplaying = true;
      emit(PreviewPlaying());
    }).catchError((onError) {
      emit(PreviewPlayingError());
    });
  }

  pausePreview() {
    assetsAudioPlayer.pause().then((value) {
      previewIsplaying = false;
      emit(PreviewStoped());
    }).catchError((onError) {});
  }

  Future getUserPodcast(String token, String userId) async {
    return await DioHelper.getData(
        url: getuserPodCast + userId,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      GetAllPodCastModel.getAllPodCast = Map<String, dynamic>.from(value.data);
      pageUserPodcasts = 2;
      noDataUserPodcasts = false;
      isLoadingprofile = false;
      emit(PodCastDataGetSuccess());
    }).catchError((error) {
      emit(PodCastDataGetError());
    });
  }

  CancelToken cancelToken = CancelToken();
  bool isLoadPodCast = false;
  bool isUploading = false;
  double? uploadProgress;
  void uploadPodCast(String token, String podCastName, String category,
      String filePath, context) async {
    var size = podcastFile!.readAsBytesSync().lengthInBytes;

    if (size >= 100000000) {
      showToast(
          message: "You can't upload podcast more than 100 mb",
          toastState: ToastState.WARNING);
      return;
    }

    isLoadPodCast = true;
    emit(PodcastUploadedLoading());
    await DioHelper.dio!
        .get(
      generateSignature,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    )
        .then((value) async {
      //timestamp
      //signature
      //cloudName
      //apiKey

      String podcastname = filePath.split('/').last;
      var cloudname = value.data['cloudName'];
      var timestamp = value.data['timestamp'];
      var signature = value.data['signature'];
      var apiKey = value.data['apiKey'];

      DioHelper.dio!.post(
        'https://api.cloudinary.com/v1_1/${cloudname}/video/upload?api_key=${apiKey}&timestamp=${timestamp}&signature=${signature}',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            filePath,
            filename: podcastname,
            contentType: MediaType('audio', 'mp3'),
          ),
          'folder': 'podcasts',
          'resource_type': 'auto',
        }),
        cancelToken: cancelToken,
        onSendProgress: (whatsend, total) {
          isUploading = true;
          isLoadPodCast = false;
          emit(PodcastUploadedNow());
          uploadProgress = whatsend / total;
        },
      ).then((value) {
        isUploading = false;
        isLoadPodCast = true;
        emit(CreatePodcastInServer());
        DioHelper.dio!.post(createPodCast,
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
            data: {
              'name': podCastName,
              'category': category,
              'audio': {'public_id': value.data['public_id']}
            }).then((value) {
          getMyPodCast(token, context);
          isLoadPodCast = false;
          showToast(
              message: 'PodCast Uploaded Success',
              toastState: ToastState.SUCCESS);
          emit(PodcastUploadedSuccess());
        }).catchError((error) {
          isLoadPodCast = false;
          isUploading = false;
          showToast(
              message: 'PodCast Uploaded Error', toastState: ToastState.ERROR);
          emit(PodcastUploadedError());
        });
      }).catchError((onError) {
        cancelToken.isCancelled
            ? showToast(
                message: 'PodCast Canceled', toastState: ToastState.SUCCESS)
            : showToast(
                message: 'PodCast Uploaded Error',
                toastState: ToastState.ERROR);
        isLoadPodCast = false;
        isUploading = false;
        emit(PodcastUploadedError());
      });
    }).catchError((onError) {
      showToast(
          message: 'PodCast Uploaded Error', toastState: ToastState.ERROR);
      isLoadPodCast = false;
      isUploading = false;
      emit(PodcastUploadedError());
    });
  }

  Future removePodCast(String podCastId, String token, context) async {
    return await DioHelper.deleteData(
        url: removePodCastById + podCastId,
        token: {'Authorization': 'Bearer $token'}).then((value) {
      getMyPodCast(token, context);
      emit(PodCastDeletedSuccess());
    }).catchError((onError) {
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

      counter++;
    }).then((value) async {
      var fullPath = file.path;
      isDownloading = false;
      emit(FileDownloadSuccess());
      showToast(
          message: 'FileSaveSuccessTo' + fullPath,
          toastState: ToastState.SUCCESS);
      final dirList = await getDownloadPath();
      final path = dirList![0].path;
      final dir = Directory(path);
      final List<FileSystemEntity> entities = await dir.list().toList();
      final List files = entities.whereType<File>().toList();
      DownloadedPodCastModel.downloadedPodcastFiles = files;
      podCastSearch(token: token, value: fileName, isLocalPodcast: true);

      DownloadedPodCastModel.getPodCastNames();
      print(DownloadedPodCastModel.downloadedPodcastFiles);
      print(DownloadedPodCastModel.getPodcastInformation.length);
    }).catchError(
      (onError) {
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
        token: {'Authorization': 'Bearer $token'}).then((value) {
      GetPodCastUsersLikesModel.getAllPodCastLikes =
          Map<String, dynamic>.from(value.data);
      navigatePushTo(context: context, navigateTo: const PodCastLikesScreen());
      //  tUsersLikesModel.getPhotoUrltName(1));
    }).catchError((onError) {});
  }

  bool isLoadProfile = false;
  void getUserData({
    required String token,
  }) {
    if (token == '') {
      return;
    } else {
      isLoadProfile = true;
      emit(UserDataLoadingState());
      DioHelper.getData(
        url: profile,
        token: {
          'Authorization': 'Bearer $token',
        },
      ).then((value) {
        GetUserModel.getUserModel = Map<String, dynamic>.from(value.data);

        // isLoadProfile = false;
        emit(UserDataSuccessState());
      }).catchError((error) {
        emit(UserDataErrorState(error.toString()));
      });
    }
  }

  bool isUpdateUserData = false;
  void updateUserData({
    required String name1,
    required String email1,
    required String bio1,
    required String token,
  }) {
    emit(UpdateUserLoadingState());
    isUpdateUserData = true;
    DioHelper.patchData(
      url: updateProfile,
      name: name1,
      email: email1,
      bio: bio1,
      token: token,
    ).then((value) {
      GetUserModel.updateName(name1);
      GetUserModel.updateEmail(email1);
      GetUserModel.updateBio(bio1);
      isUpdateUserData = false;
      emit(DataUpdatedSuccess());
      showToast(
        message: 'Update Success',
        toastState: ToastState.SUCCESS,
      );
    }).onError((DioError error, stackTrace) {
      if (error.response!.statusCode == 400) {
        showToast(
          message: "this user already exist",
          toastState: ToastState.ERROR,
        );

        // del.getMessage());
        /////////////////');
        isUpdateUserData = false;
        emit(UpdateUserErrorState());
      } else {
        isUpdateUserData = false;
        emit(UpdateUserErrorState());
      }
    });
  }

  bool isUpdatePassword = false;
  bool isUpdatePasswordDone = false;
  Future updatePassword({
    required String password_Current,
    required String password_New,
    required String password_Confirm,
    required String token,
  }) async {
    emit(UpdatePasswordLoadingState());
    isUpdatePassword = true;
    return await DioHelper.patchPassword(
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
      isUpdatePassword = false;
      isUpdatePasswordDone = true;
      showToast(
        message: 'Update Success',
        toastState: ToastState.SUCCESS,
      );
    }).catchError((error) {
      if (error.response!.statusCode == 400) {
        if (password_New.length < 8) {
          showToast(
            message: "password must have more or equal than 8 characters!",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState());
          isUpdatePassword = false;
        } else if (password_New != password_Confirm) {
          showToast(
            message: " Passwords are not the same!",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState());
          isUpdatePassword = false;
        } else {
          showToast(
            message: "error,check your data",
            toastState: ToastState.ERROR,
          );
          emit(UpdatePasswordErrorState());
          isUpdatePassword = false;
        }
      } else if (error.response!.statusCode == 401) {
        showToast(
          message: "This isn't current password",
          toastState: ToastState.ERROR,
        );
        emit(UpdatePasswordErrorState());
        isUpdatePassword = false;
      }
    });
  }

  UserModelId? userId;

  Future getUserById({
    required String profileId,
    required String token,
  }) async {
    isLoadingprofile = true;
    emit(GetUserByIdLoadingState());
    return await DioHelper.getData(
      url: userById + profileId,
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      // SaveDataModel.savaData=Map<String, dynamic>.from(value.data);
      userId = UserModelId.fromJson(value.data);

      emit(GetUserByIdSuccessState());
    }).catchError((error) {
      emit(GetUserByIdErrorState());
    });
  }

  Future followUser(
      {required String userProfileId,
      required String token,
      required context}) async {
    emit(FollowUserLoadingState());
    return await DioHelper.postData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      getMyFollowingEvents(context);
      emit(FollowUserSuccessState());
    }).catchError((error) {
      emit(FollowUserErrorState());
    });
  }

  Future unFollowUser(
      {required String userProfileId,
      required String token,
      required context}) async {
    emit(UnFollowUserLoadingState());
    return await DioHelper.deleteData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer ${token}',
      },
    ).then((value) {
      getMyFollowingEvents(context);
      emit(UnFollowUserSuccessState());
    }).catchError((error) {
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
    // isSearch = true;
    emit(SearchUserLoadingState());
    DioHelper.getData(
      url: searchUser + value,
      token: {'Authorization': 'Bearer $token'},
    ).then((value) {
      isSearch = true;
      emit(SearchUserSuccessState());
      search = Map<String, dynamic>.from(value.data);
    }).catchError((onError) {
      emit(SearchUserErrorState());
    });
  }

  void podCastSearch(
      {required String token,
      required String value,
      required bool isLocalPodcast}) {
    print(isLocalPodcast);
    bool isLocalPodcastval = isLocalPodcast;
    if (isLocalPodcastval) {
      print('yes');

      DioHelper.getData(
        url: searchPodCast + value,
        token: {'Authorization': 'Bearer $token'},
      ).then((value) {
        DownloadedPodCastModel.getPodcastInformation
            .add(Map<String, dynamic>.from(value.data));
        emit(DownloadedPOdcastInformationGetsucces());
        print(DownloadedPodCastModel.getPodcastInformation);
      });
    } else if (isLoadPodCast == false) {
      print('no');
      isSearch = true;
      emit(PodCastSearchLoadingState());
      DioHelper.getData(
        url: searchPodCast + value,
        token: {'Authorization': 'Bearer $token'},
      ).then((value) {
        PodCastSearchModel.getMyPodCast = Map<String, dynamic>.from(value.data);
        isSearch = false;

        emit(PodCastSearchSuccessState());
      }).catchError((error) {
        emit(PodCastSearchErrorState());
      });
    }
  }

  bool followerLoad = false;
  void getMyFollowers({
    required String token,
  }) {
    emit(GetMyFollowersLoadingState());
    followerLoad = true;
    DioHelper.getData(url: myFollowers, token: {
      'Authorization': 'Bearer $token',
    }).then((value) {
      Followers.followersModel = Map<String, dynamic>.from(value.data);
      noDataFollowers = false;
      isPageUserFollowers = false;
      emit(GetMyFollowersSuccessState());
      followerLoad = false;
    }).catchError((onError) {
      emit(GetMyFollowersErrorState());
    });
  }

  bool followingLoad = false;
  void getMyFollowing({
    required String token,
  }) {
    emit(GetMyFollowingLoadingState());
    followingLoad = true;
    DioHelper.getData(url: myFollowing, token: {
      'Authorization': 'Bearer $token',
    }).then((value) {
      Following.followingModel = Map<String, dynamic>.from(value.data);
      noDataFollowing = false;
      isPageUserFollowing = false;
      emit(GetMyFollowingUsersSuccessState());
      followingLoad = false;
    }).catchError((onError) {
      emit(GetMyFollowingErrorState());
    });
  }

  void userFollowers({
    required String userProfileId,
    required String token,
  }) {
    emit(UserFollowersLoadingState());
    followerLoad = true;
    DioHelper.getData(
      url: 'v1/users/$userProfileId/followers',
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      Followers.followersModel = Map<String, dynamic>.from(value.data);
      isPageUserFollowers = true;
      noDataFollowers = false;
      emit(UserFollowersSuccessState());
      followerLoad = false;
    }).catchError((error) {
      emit(UserFollowersErrorState());
    });
  }

  void userFollowing({
    required String userProfileId,
    required String token,
  }) {
    emit(UserFollowingLoadingState());
    followingLoad = true;
    DioHelper.getData(
      url: 'v1/users/$userProfileId/following',
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      Following.followingModel = Map<String, dynamic>.from(value.data);
      isPageUserFollowing = true;
      pageFollowing = 2;
      noDataFollowing = false;
      emit(UserFollowingSuccessState());
      followingLoad = false;
    }).catchError((error) {
      emit(UserFollowingErrorState());
    });
  }

  File? profileAvatar;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      profileAvatar = File(image.path);

      emit(UserAvatarState());
    } on PlatformException catch (e) {}
  }

  bool isUploadPhoto = false;
  void setAvatar(BuildContext context) async {
    emit(UserUpdateAvatarLoadingState());
    isUploadPhoto = true;

    await DioHelper.uploadImage(
            url: updateAvatar,
            image: profileAvatar,
            token: CachHelper.getData(key: 'token'))
        .then((value) {
      showToast(
          message: 'update avatar is succeeded',
          toastState: ToastState.SUCCESS);
      isUploadPhoto = false;
      emit(UserUpdateAvatarSuccessState());
    }).catchError((error) {
      emit(UserUpdateAvatarErrorState());
      isUploadPhoto = false;
    });
  }

  ///////////////Events////////////////////

  Future<void> createMyEvent({
    required String eventName,
    required String eventDescription,
    required String eventDate,
  }) async {
    emit(CreateEventLoadingState());

    DioHelper.postData(url: createEvent, token: {
      'Authorization': 'Bearer $token',
    }, data: {
      "name": eventName,
      "description": eventDescription,
      "date": eventDate,
    }).then((value) {
      CreateEventModel.data = Map<String, dynamic>.from(value.data);

      getMyEvents();
      showToast(
          message: 'Your Event Created Successfully',
          toastState: ToastState.SUCCESS);
      emit(CreateEventSuccessState());
    }).onError((DioError error, stackTrace) {
      if (error.response!.statusCode == 400) {
        showToast(
          message: 'Duplicate,sorry change your event name :(',
          toastState: ToastState.WARNING,
        );
      }
      emit(CreateEventErrorState());
    });
  }

  void getMyFollowingEvents(context) {
    if (token == '') {
      return;
    }
    emit(GetMyFollowingEventsLoadingState());

    DioHelper.getData(
      url: getMyFollowingEvent,
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      GetMyFollowingEvents.data = Map<String, dynamic>.from(value.data);

      pageEvent = 2;
      noDataEvent = false;
      emit(GetMyFollowingEventsSuccessState());
    }).onError((DioError error, s) {
      if (error.response?.statusCode == 401) {
        navigatePushANDRemoveRout(context: context, navigateTo: LoginScreen());
        token = '';
        isPlaying = false;
        isPausedInHome = false;
        GeneralAppCubit.get(context).search = null;
        currentplayingDurathion = null;
        activePodCastId = null;
        currentPostionDurationInsec = 0;
        showToast(message: 'please login again', toastState: ToastState.ERROR);
      }

      emit(GetMyFollowingEventsErrorState());
    });
  }

  void getMyEvents() {
    if (token == '') {
      return;
    }
    emit(GetMyEventsLoadingState());

    DioHelper.getData(
      url: getMyEvent,
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      GetMyEvents.data = Map<String, dynamic>.from(value.data);

      emit(GetMyEventsSuccessState());
    }).catchError((error) {
      emit(GetMyEventsErrorState());
    });
  }

  void deleteEventById({
    required String eventId,
    required String eventName,
  }) {
    emit(DeleteEventLoadingState());

    DioHelper.deleteData(
      url: deleteEvent + eventId,
      token: {
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      showToast(
          message: 'Event $eventName deleted Successfully',
          toastState: ToastState.SUCCESS);
      getMyEvents();

      emit(DeleteEventSuccessState());
    }).onError((DioError error, f) {
      showToast(message: error.message, toastState: ToastState.SUCCESS);

      emit(DeleteEventErrorState());
    });
  }

  Future<void> updateEventById({
    required String eventId,
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String eventDescription,
  }) async {
    emit(UpdateEventLoadingState());
    String updatedEventDate = eventDate.replaceAll(RegExp(r'/'), '-');
    DateTime dateConverting = DateFormat.jm().parse(eventTime);
    String editTime = dateConverting.toString().split(' ')[1];
    String finalDate;
    try {
      DateTime dateTime =
          DateFormat.yMd('en_US').add_jm().parse(eventDate + " " + eventTime);
      finalDate = dateTime.toUtc().toString();
    } catch (e) {
      finalDate =
          DateTime.parse(updatedEventDate + " " + editTime).toUtc().toString();
    }
    DioHelper.patchEventData(
      url: updateEventData + eventId,
      data: {
        "name": eventName,
        "description": eventDescription,
        "date": finalDate,
      },
      token: token,
    ).then((value) {
      showToast(
          message: 'Event $eventName updated Successfully',
          toastState: ToastState.SUCCESS);

      GetMyEvents();

      emit(UpdateEventSuccessState());
    }).onError((DioError error, stackTrace) {
      showToast(
          message: error.response!.data.toString(),
          toastState: ToastState.ERROR);

      emit(UpdateEventErrorState());
    });
  }

  Future getAllRoomsData(context) async {
    if (token == '') {
      return;
    }

    return await DioHelper.getData(
      url: getAllRooms,
      token: {'Authorization': 'Bearer $token'},
    ).then(
      (value) {
        GetAllRoomsModel.getAllRooms = Map<String, dynamic>.from(value.data);
        pageRooms = 2;
        noDateRooms = false;
        emit(GetAllRoomDataGetSuccess());
      },
    ).onError(
      (DioError error, s) {
        if (error.response?.statusCode == 401) {
          showToast(
              message: 'please login again', toastState: ToastState.ERROR);
          navigatePushANDRemoveRout(
              context: context, navigateTo: LoginScreen());
          token = '';
          isPlaying = false;
          isPausedInHome = false;
          GeneralAppCubit.get(context).search = null;
          currentplayingDurathion = null;
          activePodCastId = null;
          currentPostionDurationInsec = 0;
        }
        emit(GetAllRoomDataGetError());
      },
    );
  }

  void micPerm() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();
  }

  bool isPageUserFollowers = false;
  bool noDataFollowers = false;
  bool loadFollowers = false;
  int pageFollowers = 2;
  void paginationFollowers(
    String token,
    String urlType,
  ) {
    loadFollowers = true;
    emit(PaginationFollowersLoadingState());
    DioHelper.getData(
        url: urlType + '?page=$pageFollowers',
        token: {'Authorization': 'Bearer ${token}'}).then((value) {
      if (value.data['results'] == 0) {
        pageFollowers = pageFollowers;
        noDataFollowers = true;
        emit(PaginationFollowersSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadFollowers = false;
      } else {
        pageFollowers++;
        Followers.followersModel?['data'].addAll(value.data['data']);

        loadFollowers = false;
        emit(PaginationFollowersSuccessState());
      }
    }).onError((error, stackTrace) {
      loadFollowers = false;
      emit(PaginationFollowersErrorState());
    });
  }

  bool isPageUserFollowing = false;
  bool noDataFollowing = false;
  bool loadFollowing = false;
  bool isLowResult = false;
  int pageFollowing = 2;
  void paginationFollowing(
    String token,
    String urlType,
  ) {
    loadFollowing = true;
    emit(PaginationFollowingLoadingState());
    DioHelper.getData(
        url: urlType + '?page=$pageFollowing',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      if (value.data['results'] == 0) {
        pageFollowing = pageFollowing;
        noDataFollowing = true;
        emit(PaginationFollowingSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadFollowing = false;
      } else {
        pageFollowing++;
        Following.followingModel?['data'].addAll(value.data['data']);
        loadFollowing = false;
        emit(PaginationFollowingSuccessState());
      }
    }).onError((error, stackTrace) {
      loadFollowing = false;
      emit(PaginationFollowingErrorState());
    });
  }

  Future searchRooms(String roomName, String token) {
    return DioHelper.getData(
      url: searchAboutRoom + roomName,
      token: {'Authorization': 'Bearer $token'},
    ).then((value) {
      if (value.data['data'].isNotEmpty) {
        SearchRoomsModel.searchRoomsModel =
            Map<String, dynamic>.from(value.data);
        emit(SearchRoomsSuccess());
      } else {
        return;
      }
    }).catchError(
      (onError) {
        emit(SearchRoomsError());
      },
    );
  }

  void paginationEvent(
    String token,
  ) {
    loadEvent = true;
    emit(PaginationFollowingLoadingState());
    DioHelper.getData(
        url: getMyFollowingEvent + '&page=$pageEvent',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      if (value.data['results'] == 0) {
        pageEvent = pageEvent;
        noDataEvent = true;
        emit(PaginationEventSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadEvent = false;
      } else {
        pageEvent++;

        GetMyFollowingEvents.data!['data'].addAll(value.data['data']);
        loadEvent = false;
        emit(PaginationEventSuccessState());
      }
    }).onError((error, stackTrace) {
      loadEvent = false;
      emit(PaginationEventErrorState());
    });
  }

  void paginationRooms(
    String token,
  ) {
    loadRooms = true;
    emit(PaginationFollowingLoadingState());
    DioHelper.getData(
        url: getAllRooms + '?page=$pageRooms',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      if (value.data['results'] == 0) {
        pageRooms = pageRooms;
        noDateRooms = true;
        emit(PaginationRoomsSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadRooms = false;
      } else {
        pageRooms++;
        GetAllRoomsModel.getAllRooms!
            .addAll(Map<String, dynamic>.from(value.data['data']));
        loadRooms = false;
        emit(PaginationRoomsSuccessState());
      }
    }).onError((error, stackTrace) {
      loadRooms = false;
      emit(PaginationRoomsErrorState());
    });
  }

  bool noDataMyPodcasts = false;
  bool loadMyPodcasts = false;
  int pageMyPodcasts = 2;
  void paginationMyPodcasts(
    String token,
  ) {
    loadMyPodcasts = true;
    emit(PaginationMyPodcastsLoadingState());
    DioHelper.getData(
        url: getMyPodCasts + '?page=$pageMyPodcasts',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      if (value.data['results'] == 0) {
        pageMyPodcasts = pageMyPodcasts;
        noDataMyPodcasts = true;
        emit(PaginationMyPodcastsSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadMyPodcasts = false;
      } else {
        pageMyPodcasts++;
        GetMyPodCastModel.getMyPodCast?['data'].addAll(value.data['data']);
        loadMyPodcasts = false;
        emit(PaginationMyPodcastsSuccessState());
      }
    }).onError((error, stackTrace) {
      loadMyPodcasts = false;
      emit(PaginationMyPodcastsErrorState());
    });
  }

  bool noDataUserPodcasts = false;
  bool loadUserPodcasts = false;
  int pageUserPodcasts = 2;
  void paginationUserPodcasts(
    String token,
    String userId,
  ) {
    loadUserPodcasts = true;
    emit(PaginationUserPodcastsLoadingState());
    DioHelper.getData(
        url: getuserPodCast + userId + '&page=$pageUserPodcasts',
        token: {'Authorization': 'Bearer $token'}).then((value) {
      if (value.data['results'] == 0) {
        pageUserPodcasts = pageUserPodcasts;
        noDataUserPodcasts = true;
        emit(PaginationUserPodcastsSuccessState());
        showToast(message: 'End Of Data(:', toastState: ToastState.SUCCESS);
        loadUserPodcasts = false;
      } else {
        pageUserPodcasts++;
        GetAllPodCastModel.getAllPodCast?['data'].addAll(value.data['data']);
        loadUserPodcasts = false;
        emit(PaginationUserPodcastsSuccessState());
      }
    }).onError((error, stackTrace) {
      loadUserPodcasts = false;
      emit(PaginationUserPodcastsErrorState());
    });
  }

  Future<List> getLocalDownloadedPodCast() async {
    final dirList = await getDownloadPath();
    final path = dirList![0].path;
    final dir = Directory(path);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final List files = entities.whereType<File>().toList();
    DownloadedPodCastModel.downloadedPodcastFiles = files;
    DownloadedPodCastModel.getPodCastNames();
    DownloadedPodCastModel.podcastNames.forEach((element) {
      print(element);
      podCastSearch(token: token, value: element, isLocalPodcast: true);
    });
    print(DownloadedPodCastModel.getPodcastInformation);

    return DownloadedPodCastModel.downloadedPodcastFiles;
  }
}
