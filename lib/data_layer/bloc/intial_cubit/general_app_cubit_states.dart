import 'package:club_cast/presentation_layer/models/login_model.dart';

abstract class GeneralAppStates {}

class InitialAppState extends GeneralAppStates {}

class ChangeBottomNavIndex extends GeneralAppStates {}

class UserDataLoadingState extends GeneralAppStates {}

class UserDataSuccessState extends GeneralAppStates {
  late final UserLoginModel? userModel;

  UserDataSuccessState(this.userModel);
}

class UserDataErrorState extends GeneralAppStates {
  final String error;
  UserDataErrorState(this.error);
}

class UpdateUserLoadingState extends GeneralAppStates {}

class UpdateUserSuccessState extends GeneralAppStates {
  late final UserLoginModel? userModel;

  UpdateUserSuccessState(this.userModel);
}

class UpdateUserErrorState extends GeneralAppStates {
  final String error;
  UpdateUserErrorState(this.error);
}

class UpdatePasswordLoadingState extends GeneralAppStates {}

class UpdatePasswordSuccessState extends GeneralAppStates {
  late final UserLoginModel? userModel;

  UpdatePasswordSuccessState(this.userModel);
}

class UpdatePasswordErrorState extends GeneralAppStates {
  final String error;
  UpdatePasswordErrorState(this.error);
}

class ChangePasswordSuffixState extends GeneralAppStates {}

class PodCastDataGetSuccess extends GeneralAppStates {}

class PodCastDataGetError extends GeneralAppStates {}

class PodCastLikeAddedSuccess extends GeneralAppStates {}

class PodCastLikeAddedError extends GeneralAppStates {}

class PodCastLikeDeleatedSuccess extends GeneralAppStates {}

class PodCastLikeDeleatedError extends GeneralAppStates {}

class ChangeTheme extends GeneralAppStates {}

class ChangePlayingState extends GeneralAppStates {}

class PlayingStateError extends GeneralAppStates {}

class FileDownloadSuccess extends GeneralAppStates {}

class FileDownloadError extends GeneralAppStates {}

class FileDownloading extends GeneralAppStates {}

class DataUpdatedSuccess extends GeneralAppStates {}

class GetUserByIdLoadingState extends GeneralAppStates {}

class GetUserByIdSuccessState extends GeneralAppStates {}

class GetUserByIdErrorState extends GeneralAppStates {}

class GetAllCategoryLoadingState extends GeneralAppStates {}

class GetAllCategorySuccessState extends GeneralAppStates {}

class GetAllCategoryErrorState extends GeneralAppStates {}
