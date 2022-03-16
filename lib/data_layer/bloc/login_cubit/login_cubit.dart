import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/setup_avater_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../presentation_layer/components/component/component.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginStates());
  static LoginCubit get(context) => BlocProvider.of(context);
  ////////////variable//////////////
  // / var token = CachHelper.getData(key: 'token');
  bool obSecure = true;
  Widget suffix = const Icon(
    Icons.visibility_off,
  );
  ////////////Methods///////////////

  //////////////////
  File? profileAvatar;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      profileAvatar = File(image.path);
      print(profileAvatar);

      emit(UserSetAvatarState());
    } on PlatformException catch (e) {
      print('error when pick image from galary:${e.toString()}');
    }
  }

  void setAvatar() async {
    emit(UserSetAvatarLoadingState());
    print('======================');

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
      emit(UserSetAvatarSuccessState());
    }).catchError((error) {
      print("error when set user avatar :${error.toString()}");
      emit(UserSetAvatarErrorState());
    });
  }

  void visibleEyeOrNot() {
    obSecure = !obSecure;
    suffix = obSecure
        ? const Icon(
            Icons.visibility_off,
          )
        : const Icon(
            Icons.visibility,
          );
    emit(ChangeEyeSecureState());
  }

  UserLoginModel? userLoginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());

    DioHelper.postData(url: login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      userLoginModel = UserLoginModel.fromJson(value.data);
      emit(UserLoginSuccessState(userLoginModel!));
    }).onError((DioError error, stackTrace) {
      if (error.response!.statusCode == 401) {
        showToast(
          message: 'Incorrect Email or Password!',
          toastState: ToastState.ERROR,
        );
        emit(UserLoginErrorState());
      } else {
        print("error when user login : ${error.toString()}");
        emit(UserLoginErrorState());
      }
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
      print(value.data);

      userLoginModel = UserLoginModel.fromJson(value.data);

      CachHelper.setData(key: 'token', value: userLoginModel!.token)
          .then((value) {
        navigatePushANDRemoveRout(
            context: context, navigateTo: SetUpAvatarScreen());
      }).catchError((error) {
        print('error when save token:${error.toString()}');
      });
      emit(UserSignUpSuccessState(userLoginModel!));
    }).catchError((DioError error) {
      if (error.response!.statusCode == 400) {
        if (password!.length < 8) {
          showToast(
            message: "password must have more or equal than 8 characters!",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        } else if (password != passwordConfirm) {
          showToast(
            message: " Passwords are not the same!",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        } else {
          showToast(
            message: "this user already exist",
            toastState: ToastState.ERROR,
          );
          emit(UserSignUpErrorState());
        }
      } else {
        print('error when user sign up :${error.toString()}');
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
