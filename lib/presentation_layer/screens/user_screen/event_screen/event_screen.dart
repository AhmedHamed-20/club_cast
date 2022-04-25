import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_my_events.dart';
import 'package:club_cast/presentation_layer/widgets/event_card_item.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatelessWidget {
  static var eventNameController = TextEditingController();
  static var eventDescriptionController = TextEditingController();
  static var dateController = TextEditingController();
  static var timeController = TextEditingController();
  // static String? showUserDateFormat;
  static bool isUpdate = false;
  static int eventIndex = 0;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);

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
            'My Events',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<GeneralAppCubit, GeneralAppStates>(
            listener: (BuildContext context, state) {},
            builder: (BuildContext context, Object? state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    GetMyEvents.allEvent().isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.32,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      eventCardItem(
                                    context: context,
                                    index: index,
                                    userWhoCreateEventId:
                                        GetMyEvents.userWhoCreateEvent(
                                            index)["_id"],
                                    userName: GetMyEvents.userWhoCreateEvent(
                                        index)["name"],
                                    userUrl: GetMyEvents.userWhoCreateEvent(
                                        index)['photo'],
                                    eventName: GetMyEvents.eventName(index),
                                    eventDescription:
                                        GetMyEvents.eventDescription(index),
                                    eventDate: GetMyEvents.eventDate(index),
                                  ),
                                  itemCount: GetMyEvents.allEvent().length,
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.18,
                          ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          defaultTextFormField(
                            context: context,
                            controller: eventNameController,
                            labelText: 'Event Name',
                            keyboardType: TextInputType.text,
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "You Must Enter Your Event Name!";
                              }
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    datePicker(context: context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: Text(
                                    dateController.text != ''
                                        ? dateController.text
                                        : 'Select date',
                                    style:
                                        Theme.of(context).textTheme.bodyText1!,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    timePicker(context: context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: Text(
                                    timeController.text != ''
                                        ? timeController.text
                                        : 'Select time',
                                    style:
                                        Theme.of(context).textTheme.bodyText1!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          defaultTextFormField(
                            context: context,
                            controller: eventDescriptionController,
                            labelText: 'Event description',
                            keyboardType: TextInputType.text,
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            maxLine: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "You Must Enter Your Event description!";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    isUpdate
                        ? ConditionalBuilder(
                            condition: state is! GetMyEventsLoadingState &&
                                state is! GetMyEventsErrorState,
                            builder: (BuildContext context) {
                              return defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (eventNameController.text.length < 5) {
                                      showToast(
                                        message: 'EventName is So Short',
                                        toastState: ToastState.ERROR,
                                      );
                                    } else {
                                      cubit
                                          .updateEventById(
                                        eventId:
                                            GetMyEvents.eventId(eventIndex),
                                        eventName: eventNameController.text,
                                        eventDate: dateController.text,
                                        eventTime: timeController.text,
                                        eventDescription:
                                            eventDescriptionController.text,
                                      )
                                          .then((value) {
                                        clearCrime(context: context);
                                        isUpdate = false;
                                      });
                                      cubit.getMyEvents();
                                    }
                                  }
                                },
                                context: context,
                                height: 45,
                                width: 280,
                                text: 'Update',
                                radius: 8,
                              );
                            },
                            fallback: (BuildContext context) => Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            )),
                          )
                        : ConditionalBuilder(
                            condition: state is! GetMyEventsLoadingState &&
                                state is! GetMyEventsErrorState,
                            builder: (BuildContext context) {
                              return defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (eventNameController.text.length < 5) {
                                      showToast(
                                        message: 'EventName is So Short',
                                        toastState: ToastState.ERROR,
                                      );
                                    } else {
                                      if (dateController.text != '' &&
                                          timeController.text != '') {
                                        cubit
                                            .createMyEvent(
                                          eventName: eventNameController.text,
                                          eventDescription:
                                              eventDescriptionController.text,
                                          eventDate: dateController.text +
                                              "," +
                                              timeController.text,
                                        )
                                            .then((value) {
                                          clearCrime(context: context);
                                        });
                                        cubit.getMyEvents();
                                      } else {
                                        showToast(
                                          message:
                                              'You Must Specific date and time',
                                          toastState: ToastState.ERROR,
                                        );
                                      }
                                    }
                                  }
                                  // print(DateFormat.Hm().format(DateTime.parse(
                                  //     GetMyEvents.eventDate(eventIndex)
                                  //         .split(',')[1])));
                                  // print(GetMyEvents.eventDate(eventIndex));
                                  //
                                  // // print(DateFormat.Hm()
                                  // //     .format(DateTime.parse("21:20:21.000")));
                                  // print(dateController.text);
                                },
                                context: context,
                                height: 45,
                                width: 280,
                                text: 'Create',
                                radius: 8,
                              );
                            },
                            fallback: (BuildContext context) => Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            )),
                          ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  void timePicker({
    required BuildContext context,
  }) {
    var cubit = GeneralAppCubit.get(context);

    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      timeController.text = value!.format(context).toString();
      cubit.changeState();
    }).catchError((error) {});
  }

  void datePicker({
    required BuildContext context,
  }) {
    var cubit = GeneralAppCubit.get(context);

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 13)),
      //DateTime.parse('2050-09-20'),
    ).then((value) {
      //print(value);

      // showUserDateFormate = DateFormat.yMMMd().format(value!);
      dateController.text = DateFormat("MM/dd/yyyy").format(value!);
      cubit.changeState();
    }).catchError((error) {});
  }

  static void clearCrime({
    required BuildContext context,
  }) {
    var cubit = GeneralAppCubit.get(context);
    eventNameController.clear();
    eventDescriptionController.clear();
    dateController.clear();
    timeController.clear();
    cubit.changeState();
  }
}
