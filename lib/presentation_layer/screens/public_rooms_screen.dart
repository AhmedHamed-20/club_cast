import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/widgets/event_card_item.dart';
import 'package:club_cast/presentation_layer/widgets/public_room_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/getMyFollowingEvents.dart';

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
        return GetMyFollowingEvents.data != null
            ? SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 12.0),
                              child: Text(
                                'UPCOMING EVENTS ~~~~~~',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.31,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => eventCardItem(
                                  context: context,
                                  index: index,
                                  userWhoCreateEventId:
                                      GetMyFollowingEvents.userWhoCreateEvent(
                                          index)["_id"],
                                  userName:
                                      GetMyFollowingEvents.userWhoCreateEvent(
                                          index)["name"],
                                  userUrl:
                                      GetMyFollowingEvents.userWhoCreateEvent(
                                          index)['photo'],
                                  eventDescription:
                                      GetMyFollowingEvents.eventDescription(
                                          index),
                                  eventName:
                                      GetMyFollowingEvents.eventName(index),
                                  eventDate:
                                      GetMyFollowingEvents.eventDate(index),
                                ),
                                itemCount:
                                    GetMyFollowingEvents.allEvent().length,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 12.0),
                          child: Text(
                            'JOINING ROOM ~~~~~~',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 10, end: 10, top: 20),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => publicRoomItem(
                                context, speaker, audience, roomName, category),
                            itemCount: 10,
                          ),
                        ),
                      ],
                    )),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
      },
    );
  }
}
