import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/widgets/public_room_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicRoomScreen extends StatelessWidget {
  PublicRoomScreen({Key? key}) : super(key: key);

  List<int> speaker = [1, 2, 3];
  List<int> audience = [1, 2, 3, 4, 5, 7];
  String roomName = 'HunterRoom';
  String category = 'Education';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, end: 10, top: 20),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                publicRoomItem(context, speaker, audience, roomName, category),
            itemCount: 10,
          ),
        );
      },
    );
  }
}
