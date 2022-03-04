import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicRoomScreen extends StatelessWidget {
  const PublicRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => PublicRoomItem(context),
            itemCount: 10,
          ),
        );
      },
    );
  }
}

Widget PublicRoomItem(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.28,
    width: double.infinity,
    child: Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HunterRoom',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    ),
  );
}
