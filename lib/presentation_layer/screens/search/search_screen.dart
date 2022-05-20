import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingPodcast.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/pod_cast_search_model.dart';
import 'package:club_cast/presentation_layer/models/searchRoomsModel.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/other_users_screens/profile_detailes_screen.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_screens/room_user_view_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/profile_detailes_screens/user_profile_screen.dart';
import 'package:club_cast/presentation_layer/widgets/playingCardWidget.dart';
import 'package:club_cast/presentation_layer/widgets/pod_cast_card_item.dart';
import 'package:club_cast/presentation_layer/widgets/public_room_card_item.dart';
import 'package:club_cast/presentation_layer/widgets/search_widget_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import '../../../data_layer/bloc/room_cubit/room_cubit.dart';
import '../../../data_layer/notification/local_notification.dart';
import '../../../data_layer/sockets/sockets_io.dart';
import '../../components/constant/constant.dart';

import '../podcast_screens/explore_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();

  String token = CachHelper.getData(key: 'token');
  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);
    cubit.isSearchScreen = true;

    searchController.addListener(() {
      Future.delayed(const Duration(seconds: 1), () {
        cubit.userSearch(token: token, value: searchController.text);
        cubit.searchRooms(searchController.text, token);
        cubit.podCastSearch(token: token, value: searchController.text);
      });
    });
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            cubit.isProfilePage = false;
            cubit.isSearchScreen = false;
            PodCastSearchModel.getMyPodCast = {};
            Navigator.of(context).pop();
            return false;
          },
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    cubit.isProfilePage = false;
                    cubit.isSearchScreen = false;
                    PodCastSearchModel.getMyPodCast = {};

                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                actions: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                      ),
                      child: defaultTextFormField(
                        context: context,
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: "Search",
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        onChanged: (value) {
                          // cubit.userSearch(
                          //   token: token,
                          //   value: value,
                          // );
                        },
                        onSubmit: (value) {
                          cubit.isSearch = false;
                          cubit.changeState();
                        },
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  labelColor: Theme.of(context).textTheme.bodyText1?.color,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(
                      text: 'users',
                    ),
                    Tab(
                      text: 'rooms',
                    ),
                    Tab(
                      text: 'podCasts',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: searchWidgetCard(
                      context,
                      cubit,
                      Column(
                        children: [
                          cubit.search == null
                              ? Center(
                                  child: Text(
                                    'Waiting to search',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cubit.search!['data'].length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        cubit.getUserPodcast(
                                            token,
                                            cubit.search!['data'][index]
                                                ['_id']);

                                        cubit.getUserById(
                                            profileId: cubit.search!['data']
                                                    [index]['_id']
                                                .toString(),
                                            token: token);

                                        if (cubit.search!['data'][index]['_id']
                                                .toString() ==
                                            GetUserModel.getUserID()) {
                                          cubit.getMyPodCast(token, context);
                                          navigatePushTo(
                                              context: context,
                                              navigateTo:
                                                  const UserProfileScreen());
                                        } else {
                                          navigatePushTo(
                                              context: context,
                                              navigateTo: ProfileDetailsScreen(
                                                  cubit.search!['data'][index]
                                                      ['_id']));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              cubit.search!['data'][index]
                                                          ['photo'] ==
                                                      null
                                                  ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3-lQXGq-2WPJR5aE_l74q-mR61wDrZXUYhA&usqp=CAU'
                                                  : cubit.search!['data'][index]
                                                      ['photo'],
                                            ),
                                          ),
                                          title: Text(
                                            cubit.search!['data'][index]
                                                ['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultButton(
                            onPressed: () {
                              cubit.getExplorePodcast(token: token);
                              navigatePushTo(
                                context: context,
                                navigateTo: const ExploreScreen(),
                              );
                            },
                            context: context,
                            text: 'Explore',
                            width: 150,
                            radius: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: searchWidgetCard(
                      context,
                      cubit,
                      Column(
                        children: [
                          SearchRoomsModel.searchRoomsModel?['data'] == null
                              ? Center(
                                  child: Text(
                                    'Waiting to search',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                )
                              : publicRoomItem(
                                  context: context,
                                  speaker:
                                      SearchRoomsModel.getRoomsBrodcaster() ??
                                          [],
                                  audience:
                                      SearchRoomsModel.getRoomsAudienc() ?? [],
                                  roomName: SearchRoomsModel.getRoomName(),
                                  category: SearchRoomsModel.getRoomsGategory(),
                                  click: () {
                                    if (cubit.isPlaying) {
                                      showToast(
                                          message:
                                              "you can't enter room if you playing a podcast,leave first(:",
                                          toastState: ToastState.WARNING);
                                    } else {
                                      pressedJoinRoom = true;
                                      cubit.micPerm();
                                      if ((SocketFunc.isConnected &&
                                              currentUserRoleinRoom) &&
                                          SearchRoomsModel.getRoomName() ==
                                              activeRoomName) {
                                        navigatePushTo(
                                            context: context,
                                            navigateTo:
                                                const RoomAdminViewScreen());
                                      } else if (SocketFunc.isConnected &&
                                          SearchRoomsModel.getRoomName() ==
                                              activeRoomName) {
                                        navigatePushTo(
                                            context: context,
                                            navigateTo:
                                                const RoomUserViewScreen());
                                      } else if (SocketFunc.isConnected) {
                                        if (currentUserRoleinRoom) {
                                          showToast(
                                              message:
                                                  "You can't join room if you are admin of a room,leave first ):",
                                              toastState: ToastState.ERROR);
                                        } else {
                                          NotificationService.notification
                                              .cancelAll();
                                          SocketFunc.leaveRoom(
                                              context,
                                              RoomCubit.get(context),
                                              GeneralAppCubit.get(context));
                                          SocketFunc.connectWithSocket(
                                              context,
                                              RoomCubit.get(context),
                                              GeneralAppCubit.get(context));
                                          SocketFunc.joinRoom(
                                              SearchRoomsModel.getRoomName(),
                                              context,
                                              RoomCubit.get(context),
                                              cubit);
                                        }
                                      } else {
                                        SocketFunc.connectWithSocket(
                                            context,
                                            RoomCubit.get(context),
                                            GeneralAppCubit.get(context));
                                        SocketFunc.joinRoom(
                                            SearchRoomsModel.getRoomName(),
                                            context,
                                            RoomCubit.get(context),
                                            cubit);
                                      }
                                    }
                                  },
                                  adminData: SearchRoomsModel
                                      .getRoomsUserPublishInform())
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: searchWidgetCard(
                      context,
                      cubit,
                      Column(
                        children: [
                          PodCastSearchModel.getMyPodCast['data'] == null
                              ? Center(
                                  child: Text(
                                    'Waiting to search',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => podACastItem(
                                    context,
                                    index: index,
                                    downloadButton:
                                        PlayingCardWidget.downloadingWidget(
                                      cubit.activePodCastId.toString(),
                                      index,
                                      PodCastSearchModel.getPodcastID(index),
                                      cubit,
                                      context,
                                      PodCastSearchModel.getPodCastAudio(
                                          index)['url'],
                                      PodCastSearchModel.getPodcastName(index),
                                    ),
                                    likeWidget: PlayingCardWidget.likeState(
                                      context,
                                      PodCastSearchModel.podcastLikeState(
                                          index),
                                      PodCastSearchModel.getPodcastID(index),
                                      token,
                                      '',
                                      searchName: searchController.text,
                                    ),
                                    podCastLikes:
                                        PlayingCardWidget.podCastLikes(
                                            context,
                                            cubit,
                                            token,
                                            index,
                                            PodCastSearchModel.getPodcastID(
                                                index),
                                            PodCastSearchModel.getPodcastLikes(
                                                    index)
                                                .toString()), //todo
                                    removePodCast: const SizedBox(),
                                    playingWidget:
                                        PlayingCardWidget.playingButton(
                                            index,
                                            cubit,
                                            PodCastSearchModel.getPodCastAudio(
                                                index)['url'],
                                            cubit.activePodCastId.toString(),
                                            PodCastSearchModel.getPodcastID(
                                                index),
                                            PodCastSearchModel.getPodcastName(
                                                index),
                                            PodCastSearchModel
                                                .getPodcastUserPublishInform(
                                                    index)['photo'],
                                            context),
                                    gettime: PodCastSearchModel.getPodCastAudio(
                                        index)['duration'],
                                    photourl: PodCastSearchModel
                                        .getPodcastUserPublishInform(
                                            index)['photo'],
                                    ontapOnCircleAvater: () {
                                      cubit.getUserById(
                                          profileId: PodCastSearchModel
                                              .getPodcastUserPublishInform(
                                                  index)['_id'],
                                          token: token);
                                      cubit.getUserPodcast(
                                          token,
                                          PodCastSearchModel
                                              .getPodcastUserPublishInform(
                                                  index)['_id']);
                                      navigatePushTo(
                                          context: context,
                                          navigateTo: ProfileDetailsScreen(
                                              PodCastSearchModel
                                                  .getPodcastUserPublishInform(
                                                      index)['_id']));
                                    },
                                    podcastName:
                                        PodCastSearchModel.getPodcastName(
                                            index),
                                    userName: PodCastSearchModel
                                        .getPodcastUserPublishInform(
                                            index)['name'],
                                    text: cubit.isPlaying &&
                                            PodCastSearchModel.getPodcastID(
                                                    index) ==
                                                cubit.activePodCastId
                                        ? cubit.currentOlayingDurathion
                                        : cubit.pressedPause &&
                                                PodCastSearchModel.getPodcastID(
                                                        index) ==
                                                    cubit.activePodCastId
                                            ? cubit.currentOlayingDurathion
                                            : null,
                                  ),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(
                                    height: 10,
                                  ),
                                  itemCount: PodCastSearchModel
                                      .getMyPodCast['data'].length,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
