import 'package:club_cast/data_layer/agora/rtc_engine.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:club_cast/data_layer/notification/local_notification.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/widgets/alertDialog.dart';
import 'package:club_cast/presentation_layer/widgets/multi_use_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/component/component.dart';
import '../../components/constant/constant.dart';
import '../../layout/layout_screen.dart';
import '../../widgets/listenersWidget.dart';
import '../../widgets/speakersWidget.dart';

class RoomAdminViewScreen extends StatelessWidget {
  const RoomAdminViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = RoomCubit.get(context);
    isIamInRoomScreen = true;
    // cubit.speakers = ActiveRoomAdminModel.getRoomsBrodCasters();
    // cubit.listener = ActiveRoomAdminModel.getRoomsAudienc();

    return BlocConsumer<RoomCubit, RoomStates>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            isIamInRoomScreen = false;
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
            floatingActionButton: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor,
              child: Center(
                child: SocketFunc.showReconnectButton
                    ? IconButton(
                        onPressed: () {
                          SocketFunc.connectWithSocket(
                              context,
                              RoomCubit.get(context),
                              GeneralAppCubit.get(context));
                          // SocketFunc.adminReturnBack();
                        },
                        icon: const Icon(Icons.refresh),
                      )
                    : IconButton(
                        icon: Icon(
                          cubit.speakers[0]['isMuted']
                              ? Icons.mic_off
                              : Icons.mic_none,
                          color: Theme.of(context).backgroundColor,
                        ),
                        onPressed: () {
                          AgoraRtc.onToggleMute(0, context);
                        },
                      ),
              ),
            ),
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
              title: GeneralAppCubit.get(context).isPublicRoom
                  ? const SizedBox()
                  : SelectableText(
                      ActiveRoomAdminModel.getRoomId(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 13),
                    ),
              actions: [
                showRecordingGif
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => multiAlerDialog(
                                    context: context,
                                    actions: Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'ok',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ),
                                    title: 'Info',
                                    content: Text(
                                      'The Room will record and save in (storage/android/data/com.example.club cast/files/documents/$activeRoomName.aac )',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ));
                        },
                        child: Image.asset('assets/images/recording.gif'))
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return alertDialog(
                                context: context,
                                title: 'Are you sure',
                                content: Text(
                                  'if leave the room will be removed',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                yesFunction: () {
                                  SocketFunc.adminEndTheRoom();
                                  GeneralAppCubit.get(context).isRecordRoom
                                      ? AgoraRtc.stopRecording()
                                      : const SizedBox();
                                  navigatePushANDRemoveRout(
                                      context: context,
                                      navigateTo: LayoutScreen());
                                  NotificationService.notification.cancelAll();
                                },
                                noFunction: () {
                                  Navigator.of(context).pop();
                                });
                          });
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
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
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
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              ActiveRoomAdminModel.getRoomName(),
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
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
                          speakersWiget(
                            cubit: cubit,
                            isAdmin: true,
                          ),
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
                        isAdmin: true,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
