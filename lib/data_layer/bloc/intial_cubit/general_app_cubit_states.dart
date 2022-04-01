import 'package:club_cast/presentation_layer/models/login_model.dart';

abstract class GeneralAppStates {}

class InitialAppState extends GeneralAppStates {}

class ChangeBottomNavIndex extends GeneralAppStates {}

class UserDataLoadingState extends GeneralAppStates {}

class UserDataSuccessState extends GeneralAppStates {
  // late final UserLoginModel? userModel;
  //
  // UserDataSuccessState(this.userModel);
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

class FollowUserLoadingState extends GeneralAppStates {}

class FollowUserSuccessState extends GeneralAppStates {}

class FollowUserErrorState extends GeneralAppStates {}

class UnFollowUserLoadingState extends GeneralAppStates {}

class UnFollowUserSuccessState extends GeneralAppStates {}

class UnFollowUserErrorState extends GeneralAppStates {}

class ChangeFollowingState extends GeneralAppStates {}

class GetAllCategoryLoadingState extends GeneralAppStates {}

class GetAllCategorySuccessState extends GeneralAppStates {}

class GetAllCategoryErrorState extends GeneralAppStates {}

class GetMyPodCastSuccessState extends GeneralAppStates {}

class GetMyPodCastErrorState extends GeneralAppStates {}

class SearchUserLoadingState extends GeneralAppStates {}

class SearchUserSuccessState extends GeneralAppStates {}

class SearchUserErrorState extends GeneralAppStates {}

class GetMyFollowersLoadingState extends GeneralAppStates {}

class GetMyFollowersSuccessState extends GeneralAppStates {}

class GetMyFollowersErrorState extends GeneralAppStates {}

class GetMyFollowingLoadingState extends GeneralAppStates {}

class GetMyFollowingUsersSuccessState extends GeneralAppStates {}

class GetMyFollowingErrorState extends GeneralAppStates {}

class UserFollowersLoadingState extends GeneralAppStates {}

class UserFollowersSuccessState extends GeneralAppStates {}

class UserFollowersErrorState extends GeneralAppStates {}

class UserFollowingLoadingState extends GeneralAppStates {}

class UserFollowingSuccessState extends GeneralAppStates {}

class UserFollowingErrorState extends GeneralAppStates {}

class GetMyFollowingSuccessState extends GeneralAppStates {}

class GetMyFollowinErrorState extends GeneralAppStates {}

class PodCastDeletedSuccess extends GeneralAppStates {}

class PodCastDeletedError extends GeneralAppStates {}

class FilePickedSuccess extends GeneralAppStates {}

class FilePickedError extends GeneralAppStates {}

class PreviewPlaying extends GeneralAppStates {}

class PreviewPlayingError extends GeneralAppStates {}

class PreviewStoped extends GeneralAppStates {}

class UserAvatarState extends GeneralAppStates {}

class PodcastUploadedLoading extends GeneralAppStates {}

class PodcastUploadedSuccess extends GeneralAppStates {}

class PodcastUploadedNow extends GeneralAppStates {}

class CreatePodcastInServer extends GeneralAppStates {}

class PodcastUploadedError extends GeneralAppStates {}

class UserUpdateAvatarLoadingState extends GeneralAppStates {}

class UserUpdateAvatarSuccessState extends GeneralAppStates {}

class UserUpdateAvatarErrorState extends GeneralAppStates {}

class LoadDataPaginattion extends GeneralAppStates {}

class DataPaginattiongetSuccess extends GeneralAppStates {}

class DataPaginattiongetError extends GeneralAppStates {}

class CreateEventLoadingState extends GeneralAppStates {}

class CreateEventSuccessState extends GeneralAppStates {}

class CreateEventErrorState extends GeneralAppStates {}

class GetMyFollowingEventsLoadingState extends GeneralAppStates {}

class GetMyFollowingEventsSuccessState extends GeneralAppStates {}

class GetMyFollowingEventsErrorState extends GeneralAppStates {}

class GetMyEventsLoadingState extends GeneralAppStates {}

class GetMyEventsSuccessState extends GeneralAppStates {}

class GetMyEventsErrorState extends GeneralAppStates {}

class DeleteEventLoadingState extends GeneralAppStates {}

class DeleteEventSuccessState extends GeneralAppStates {}

class DeleteEventErrorState extends GeneralAppStates {}

class UpdateEventLoadingState extends GeneralAppStates {}

class UpdateEventSuccessState extends GeneralAppStates {}

class UpdateEventErrorState extends GeneralAppStates {}
