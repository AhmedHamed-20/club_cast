import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/widgets/pos_cast_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';

class PodCastScreen extends StatelessWidget {
  const PodCastScreen({Key? key}) : super(key: key);

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
            itemBuilder: (context, index) => podACastItem(context),
            itemCount: 10,
          ),
        );
      },
    );
  }
}
