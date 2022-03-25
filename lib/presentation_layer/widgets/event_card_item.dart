import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_my_events.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/event_screen/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget eventCardItem({
  required BuildContext context,
  required String eventName,
  required String eventDescription,
  required String eventDate,
  required String userUrl,
  required int index,
  required String userWhoCreateEventId,
  required String userName,
}) {
  var cubit = GeneralAppCubit.get(context);
  EventScreen.eventIndex = index;
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        elevation: 4,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(userUrl),
                ),
                title: Row(
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 10),
                        child: Text(
                          eventName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    GetUserModel.getUserID() != userWhoCreateEventId
                        ? SizedBox()
                        : IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              cubit.deleteEventById(
                                eventId: GetMyEvents.eventId(index),
                                eventName: GetMyEvents.eventName(index),
                              );
                              cubit.getMyEvents();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.redAccent,
                            ),
                          ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('from ${userName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey, fontSize: 13)),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Text(
                        eventDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
                horizontalTitleGap: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 37.0),
                    child: GetUserModel.getUserID() != userWhoCreateEventId
                        ? const SizedBox()
                        : defaultTextButton(
                            onPressed: () {
                              updateEventData(context: context, index: index);
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                  ),
                  Text(
                    DateFormat.yMMMd().format(DateTime.parse(eventDate)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

void updateEventData({
  required BuildContext context,
  required int index,
}) {
  var cubit = GeneralAppCubit.get(context);
  EventScreen.isUpdate = true;
  EventScreen.eventNameController.text = GetMyEvents.eventName(index);
  EventScreen.eventDescriptionController.text =
      GetMyEvents.eventDescription(index);
  cubit.changeState();
}
