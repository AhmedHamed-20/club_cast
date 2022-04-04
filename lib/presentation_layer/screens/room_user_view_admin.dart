import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_states.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/models/activeRoomModelAdmin.dart';
import 'package:club_cast/presentation_layer/widgets/model_sheet_room_contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/component/component.dart';
import '../layout/layout_screen.dart';
import '../widgets/listenersWidget.dart';
import '../widgets/speakersWidget.dart';

class RoomAdminViewScreen extends StatelessWidget {
  const RoomAdminViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = RoomCubit.get(context);
    // cubit.speakers = ActiveRoomAdminModel.getRoomsBrodCasters();
    // cubit.listener = ActiveRoomAdminModel.getRoomsAudienc();
    return BlocConsumer<RoomCubit, RoomStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: MaterialButton(
              onPressed: () {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    SocketFunc.leaveRoom(context);
                    navigatePushANDRemoveRout(
                        context: context, navigateTo: LayoutScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Leave',
                        style: TextStyle(
                          color: Colors.white,
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Center(
                            child: Text(
                              'Speakers',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        speakersWiget(
                          cubit: cubit,
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
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                    listenersWiget(
                      cubit: cubit,
                    )
                  ],
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
