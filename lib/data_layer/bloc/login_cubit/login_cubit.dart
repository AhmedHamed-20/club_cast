import 'dart:io';

import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/register_screen/setup_avater_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../presentation_layer/components/component/component.dart';
import '../../../presentation_layer/models/getMyFollowingPodcast.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginStates());
  static LoginCubit get(context) => BlocProvider.of(context);
  ////////////variable//////////////

  bool loginObSecure = true;
  bool signUpObSecure = true;
  bool isLoadProfile = false;
  Widget suffix = const Icon(
    Icons.visibility_off,
  );
  Widget signUpSuffix = const Icon(
    Icons.visibility_off,
  );
  ////////////Methods///////////////

  void loginVisibleEyeOrNot() {
    loginObSecure = !loginObSecure;
    suffix = loginObSecure
        ? const Icon(
            Icons.visibility,
          )
        : const Icon(
            Icons.visibility_off,
          );
    emit(ChangeLoginEyeSecureState());
  }

  void signUpVisibleEyeOrNot() {
    signUpObSecure = !signUpObSecure;
    signUpSuffix = signUpObSecure
        ? const Icon(
            Icons.visibility_off,
          )
        : const Icon(
            Icons.visibility,
          );
    emit(ChangeSignUpEyeSecureState());
  }

  //////////////////////////////////

  File? profileAvatar;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      profileAvatar = File(image.path);

      emit(UserSetAvatarState());
    } on PlatformException catch (e) {}
  }

  Future setAvatar(BuildContext context) async {
    emit(UserSetAvatarLoadingState());

    return await DioHelper.uploadImage(
            url: updateAvatar,
            image: profileAvatar,
            token: CachHelper.getData(key: 'token'))
        .then((value) {
      getUserData(token: token).then((value) {
        getMyFollowingPodcast(token).then((value) {
          navigatePushANDRemoveRout(
              context: context, navigateTo: LayoutScreen());
          showToast(
              message: 'update avatar is succeeded',
              toastState: ToastState.SUCCESS);
          emit(UserSetAvatarSuccessState());
          profileAvatar = null;
        });
      });
    }).catchError((error) {
      emit(UserSetAvatarErrorState());
    });
  }

  UserLoginModel? userLoginModel;

  void userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(UserLoginLoadingState());

    DioHelper.postData(url: login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      userLoginModel = UserLoginModel.fromJson(value.data);
      token = UserLoginModel.token;
      getUserData(token: token).then(
        (value) {
          GeneralAppCubit.get(context).getMyEvents();
          GeneralAppCubit.get(context).getMyFollowingEvents(context);
          GeneralAppCubit.get(context).getAllRoomsData(context);
          GeneralAppCubit.get(context).getAllCategory();
          getMyFollowingPodcast(token).then((value) {
            navigatePushANDRemoveRout(
                context: context, navigateTo: LayoutScreen());
            emit(UserLoginSuccessState(userLoginModel!));
          });
        },
      );
    }).onError((DioError error, stackTrace) {
      if (error.response?.statusCode == 401) {
        showToast(
          message: 'Incorrect Email or Password!',
          toastState: ToastState.ERROR,
        );
        emit(UserLoginErrorState());
      } else {
        emit(UserLoginErrorState());
      }
    });
  }

  Future getUserData({
    required String token,
  }) async {
    if (token == '') {
    } else {
      isLoadProfile = true;
      emit(UserDataLoadingState());
      return await DioHelper.getData(
        url: profile,
        token: {
          'Authorization': 'Bearer $token',
        },
      ).then((value) {
        GetUserModel.getUserModel = Map<String, dynamic>.from(value.data);

        isLoadProfile = false;
        emit(UserDataSuccessState());
      }).catchError((error) {
        emit(UserDataErrorState());
      });
    }
  }

  Future getMyFollowingPodcast(String token) {
    return DioHelper.getData(
            token: {'Authorization': 'Bearer $token'},
            url: getMyFollowingPodcasts)
        .then((value) {
      GetMyFollowingPodCastsModel.getMyFollowingPodcasts =
          Map<String, dynamic>.from(value.data);

      emit(PodCastDataGetSuccess());
    }).catchError((onError) {
      emit(PodCastDataGetError());
    });
  }

  UserLoginModel? userSignUpModel;
  void userSignUp({
    required BuildContext context,
    required String? name,
    required String? email,
    required String? password,
    required String? passwordConfirm,
  }) {
    emit(UserSignUpLoadingState());
    DioHelper.postData(
      url: signup,
      data: {
        "name": name,
        "email": email,
        "country": "egypt",
        "language": "arabic",
        "userType": "podcaster",
        "password": password,
        "passwordConfirm": passwordConfirm,
      },
    ).then((value) {
      userLoginModel = UserLoginModel.fromJson(value.data);
      token = UserLoginModel.token;
      CachHelper.setData(key: 'token', value: UserLoginModel.token)
          .then((value) {
        getUserData(token: token).then((value) {
          GeneralAppCubit.get(context).getMyEvents();
          GeneralAppCubit.get(context).getAllRoomsData(context);
          GeneralAppCubit.get(context).getAllCategory();
          getMyFollowingPodcast(token).then((value) {
            GeneralAppCubit.get(context).getMyFollowingEvents(context);
            navigatePushANDRemoveRout(
                context: context, navigateTo: SetUpAvatarScreen());
          });
        });
        emit(UserSignUpSuccessState(userLoginModel!));
      }).catchError((error) {});
    }).onError((DioError error, f) {
      if (error.response!.statusCode == 400) {
        if (password!.length < 8) {
          showToast(
            message: "password must have at least 8 symbols!",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        } else if (password != passwordConfirm) {
          showToast(
            message: " Passwords are not the same!",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        } else if (email!.length < 10) {
          showToast(
            message: "Invalid email must have more or equal than 10 characters",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        } else if (name!.length < 3) {
          showToast(
            message: "user name must have more or equal than 3 characters",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        }
      } else {
        emit(UserSignUpErrorState());
      }
    });
  }

  void forgetPassword({
    required String email,
  }) {
    emit(UserForgetPasswordLoadingState());
    DioHelper.postData(url: forgotPassword, data: {
      "email": email,
    }).then((value) {
      showToast(message: 'check your gmail', toastState: ToastState.SUCCESS);

      emit(UserForgetPasswordSuccessState());
    }).onError((DioError error, stackTrace) {
      if (error.response!.statusCode == 404) {
        showToast(
            message: 'There is no user with email address.',
            toastState: ToastState.ERROR);
        emit(UserForgetPasswordErrorState());
      }
    });
  }
}
