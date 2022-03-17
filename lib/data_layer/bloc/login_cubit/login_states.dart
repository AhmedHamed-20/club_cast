import 'package:club_cast/presentation_layer/models/login_model.dart';

abstract class LoginStates {}

class InitialLoginStates extends LoginStates {}

class ChangeLoginEyeSecureState extends LoginStates {}

class ChangeSignUpEyeSecureState extends LoginStates {}

class UserLoginLoadingState extends LoginStates {}

class UserLoginSuccessState extends LoginStates {
  final UserLoginModel userLoginModel;
  UserLoginSuccessState(this.userLoginModel);
}

class UserLoginErrorState extends LoginStates {}

class UserSignUpLoadingState extends LoginStates {}

class UserSignUpSuccessState extends LoginStates {
  final UserLoginModel userSignUpModel;
  UserSignUpSuccessState(this.userSignUpModel);
}

class UserSignUpErrorState extends LoginStates {}

class UserForgetPasswordLoadingState extends LoginStates {}

class UserForgetPasswordSuccessState extends LoginStates {}

class UserForgetPasswordErrorState extends LoginStates {}

class UserSetAvatarState extends LoginStates {}

class UserSetAvatarLoadingState extends LoginStates {}

class UserSetAvatarSuccessState extends LoginStates {}

class UserSetAvatarErrorState extends LoginStates {}

class UserDataLoadingState extends LoginStates {}

class UserDataSuccessState extends LoginStates {}

class UserDataErrorState extends LoginStates {}

class PodCastDataGetSuccess extends LoginStates {}

class PodCastDataGetError extends LoginStates {}
