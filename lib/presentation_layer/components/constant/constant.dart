import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

/////// end Points ////////////
var token;
String activeRoomName = '';
TextEditingController privateRoomController = TextEditingController();
bool currentUserRoleinRoom = false;
bool showRecordingGif = false;
bool pressedJoinRoom = false;
bool isPrivateRoom = false;
bool isIamInRoomScreen = true;

String? privateRoomId;
UserLoginModel? ahmedModel;
final androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "flutter_background example app",
  notificationText:
      "Background notification for keeping the example app running in the background",
  notificationImportance: AndroidNotificationImportance.Default,
  notificationIcon: AndroidResource(
      name: 'background_icon',
      defType:
          '@mipmap/ic_launcher'), // Default is ic_launcher from folder mipmap
);
const String baseUrl = "https://audiocomms-podcast-platform.herokuapp.com/api/";
const String login = "v1/users/login";
const String signup = "v1/users/signup";
const String forgotPassword = "v1/users/forgotPassword";
const String AllCategory = "v1/categories/";
const String profile = "v1/users/me";
const String updateProfile = "v1/users/updateMe";
const String update_Password = "v1/users/updateMyPassword";
const String GetAllPodcasts = baseUrl + 'v1/podcasts';
const String sendLike = baseUrl + 'v1/podcasts/likes/';
const String getPodcastLikesUsers = baseUrl + 'v1/podcasts/likes/';
const String userById = 'v1/users/';
const String getuserPodCast = baseUrl + 'v1/podcasts?createdBy=';
const String searchUser = 'v1/users/search?s=';
const String removePodCastById = baseUrl + 'v1/podcasts/';
const String getMyPodCasts = baseUrl + 'v1/podcasts/me';
const String getMyFollowingPodcasts = baseUrl + 'v1/podcasts/following/me';
const String myFollowers = 'v1/users/me/followers';
const String myFollowing = 'v1/users/me/following';

const String generateSignature = baseUrl + 'v1/podcasts/generateSignature';
const String createPodCast = baseUrl + 'v1/podcasts';

const String createEvent = "v1/events/me";
const String getMyFollowingEvent = "v1/events/?sort=date";
const String getMyEvent = "v1/events/me";
const String deleteEvent = "v1/events/";
const String updateEventData = "v1/events/";
const String getAllPodCastWithoutMe = baseUrl + 'v1/podcasts/notMe';
const String getAllRooms = baseUrl + 'v1/rooms';
const String getRoom = baseUrl + 'v1/rooms/';
const String searchAboutRoom = baseUrl + 'v1/rooms/search?s=';
const String updateAvatar = "v1/users/updateMyPhoto";
//////////////////modelData/////////////////
GlobalKey formKeyBottomSheat = GlobalKey<FormState>();
