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
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 4,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(userUrl),
                  ),
                  const Spacer(),
                  GetUserModel.getUserID() != userWhoCreateEventId
                      ? const SizedBox()
                      : (EventScreen.eventIndex != index
                          ? defaultTextButton(
                              onPressed: () {
                                appearEventDataToUpdate(
                                    context: context, index: index);
                              },
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : (EventScreen.isUpdate
                              ? defaultTextButton(
                                  onPressed: () {
                                    EventScreen.isUpdate = false;
                                    EventScreen.clearCrime(context: context);
                                  },
                                  child: const Text(
                                    'Cancel\nUpdate',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : defaultTextButton(
                                  onPressed: () {
                                    appearEventDataToUpdate(
                                        context: context, index: index);
                                  },
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )))
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'from ' + userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    (MediaQuery.of(context).size.width.toInt() <= 360 &&
                            MediaQuery.of(context).size.height.toInt() <= 678)
                        ? MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 0.8,
                            ),
                            child: Expanded(
                              child: Text(
                                eventDescription,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              eventDescription,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                    Text(
                      //DateFormat.yMMMd().format(DateTime.parse(eventDate))
                      formatDateToPrinto(date: eventDate),

                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              GetUserModel?.getUserID() != userWhoCreateEventId
                  ? const SizedBox()
                  : IconButton(
                      splashRadius: 25,
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
        ),
      ),
    ),
  );
}

void appearEventDataToUpdate({
  required BuildContext context,
  required int index,
}) {
  EventScreen.eventIndex = index;

  var cubit = GeneralAppCubit.get(context);
  EventScreen.isUpdate = true;
  EventScreen.eventNameController.text = GetMyEvents.eventName(index);
  EventScreen.dateController.text = GetMyEvents.eventDate(index).split(" ")[0];
  EventScreen.timeController.text =
      DateFormat("h:mm a").format(DateTime.parse(GetMyEvents.eventDate(index)));

  // print(DateFormat("h:mm a")
  //     .format(DateTime.parse(GetMyEvents.eventDate(index))));
  EventScreen.eventDescriptionController.text =
      GetMyEvents.eventDescription(index);
  cubit.changeState();
  // print(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
  //     .parse("2022-03-29T21:20:21.000Z"));
}

///////////////////////////////////////

String formatDateToPrinto({
  required String date,
}) {
  return DateFormat("h:mm a").format(DateTime.parse(date)) +
      "\n" +
      DateFormat.yMMMMEEEEd().format(DateTime.parse(date));
}
