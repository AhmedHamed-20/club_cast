import 'dart:math';

import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/notification/local_notification.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/getMyFollowingEvents.dart';
import 'package:club_cast/presentation_layer/widgets/event_card_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../components/constant/constant.dart';

class GetAllMyFollowingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = GeneralAppCubit?.get(context);
        refresh() {
          cubit.getMyFollowingEvents(context);
          return cubit.getAllRoomsData(context);
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title: Text(
              'My Following Events',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          body: GetMyFollowingEvents.data != null
              ? RefreshIndicator(
                  backgroundColor: Theme.of(context).backgroundColor,
                  color: Theme.of(context).primaryColor,
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => allFollowingEvent(
                              context: context,
                              eventName: GetMyFollowingEvents.eventName(index),
                              eventDescription:
                                  GetMyFollowingEvents.eventDescription(index),
                              eventDate: GetMyFollowingEvents.eventDate(index),
                              userUrl: GetMyFollowingEvents.userWhoCreateEvent(
                                  index)['photo'],
                              index: index,
                              userWhoCreateEventId:
                                  GetMyFollowingEvents.userWhoCreateEvent(
                                      index)["_id"],
                              userName: GetMyFollowingEvents.userWhoCreateEvent(
                                  index)["name"],
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            itemCount: GetMyFollowingEvents.allEvent().length,
                          ),
                          cubit.noDataEvent
                              ? const SizedBox()
                              : InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {
                                    cubit.paginationEvent(
                                      token,
                                    );
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        radius: 30,
                                        child: cubit.loadEvent
                                            ? CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : Icon(
                                                Icons.arrow_downward,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )),
        );
      },
    );
  }

  Widget allFollowingEvent({
    required BuildContext context,
    required String eventName,
    required String eventDescription,
    required String eventDate,
    required String userUrl,
    required int index,
    required String userWhoCreateEventId,
    required String userName,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(userUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002,
                        ),
                        Text(
                          'From $userName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          eventDescription,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          formatDateToPrinto(date: eventDate),
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        String eventDated = DateFormat("yyyy-MM-dd HH:mm:ss")
                            .format(DateTime.parse(eventDate));
                        Duration diffrence = DateTime.parse(eventDated)
                            .difference(DateTime.now());
                        NotificationService.scheduleNotification(
                          eventName + "from $userName started now .",
                          eventDescription,
                          'hhh',
                          eventTime: DateTime.now().add(diffrence),
                          index: Random().nextInt(200),
                        );

                        showToast(
                            message:
                                'we will notify you at the time of this event',
                            toastState: ToastState.SUCCESS);
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
