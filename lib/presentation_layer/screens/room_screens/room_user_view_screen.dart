import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:club_cast/data_layer/notification/local_notification.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelUser.dart';
import 'package:club_cast/presentation_layer/widgets/listenersWidget.dart';
import 'package:club_cast/presentation_layer/widgets/speakersWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../components/component/component.dart';
import '../../components/constant/constant.dart';
import '../../layout/layout_screen.dart';

class RoomUserViewScreen extends StatelessWidget {
  const RoomUserViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isIamInRoomScreen = true;
    // List speakers = ActiveRoomUserModel.getRoomsBrodCasters();
    // List Listener = ActiveRoomUserModel.getRoomsAudienc();
    var cubit = RoomCubit.get(context);
    return BlocConsumer<RoomCubit, RoomStates>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            isIamInRoomScreen = false;
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: MaterialButton(
                onPressed: () {
                  isIamInRoomScreen = false;
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                showRecordingGif
                    ? Image.asset('assets/images/recording.gif')
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      SocketFunc.isConnected = false;
                      SocketFunc.leaveRoom(context, RoomCubit.get(context),
                          GeneralAppCubit.get(context));
                      navigatePushANDRemoveRout(
                          context: context, navigateTo: LayoutScreen());
                      NotificationService.notification.cancelAll();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Leave',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              ActiveRoomUserModel.getRoomName().toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                'Speakers',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          speakersWiget(cubit: cubit, isAdmin: false),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Listeners',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                      listenersWiget(
                        cubit: cubit,
                        isAdmin: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    onPressed: () {
                      SocketFunc.iamSpeaker
                          ? SocketFunc.userWantToReturnAudience(
                              context, GeneralAppCubit.get(context))
                          : SocketFunc.askToTalk();
                      SocketFunc.iamSpeaker
                          ? const SizedBox()
                          : askedToTalk
                              ? showToast(
                                  message:
                                      'You asked to talk,wait until admin accept',
                                  toastState: ToastState.SUCCESS)
                              : showToast(
                                  message:
                                      'You canceled your permission to talk',
                                  toastState: ToastState.SUCCESS);
                      // print('ddd');
                    },
                    icon: Icon(
                      SocketFunc.iamSpeaker
                          ? MdiIcons.arrowDown
                          : MdiIcons.handBackLeft,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SocketFunc.iamSpeaker
                    ? CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          onPressed: () {
                            for (int i = 0; i < cubit.speakers.length; i++) {
                              if (ActiveRoomUserModel.getUserId() ==
                                  cubit.speakers[i]['_id']) {
                                AgoraRtc.onToggleMute(i, context);
                              }
                            }
                          },
                          icon: Icon(
                            AgoraRtc.muted ? Icons.mic_off : Icons.mic_none,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
