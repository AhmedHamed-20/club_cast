import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import '../components/component/component.dart';
import '../screens/setup_avater_screen.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = GeneralAppCubit.get(context);
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Rooms',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 25),
              ),
              actions: [
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    logOut(context: context);
                  },
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    navigatePushANDRemoveRout(
                        context: context, navigateTo: SetUpAvatarScreen());
                  },
                  child: const CircleAvatar(
                    radius: 23,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavBarItem,
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).iconTheme.color,
              currentIndex: cubit.bottomNavIndex,
              onTap: (index) {
                cubit.changeBottomNAvIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modalBottomSheetItem(context);
              },
              elevation: 15,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            body: cubit.screen[cubit.bottomNavIndex],
          );
        });
  }

  modalBottomSheetItem(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => buildSheet(context),
    );
  }

  Widget buildSheet(BuildContext context) {
    var cubit = GeneralAppCubit.get(context);
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.88,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Create Your Room',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  defaultTextFormField(
                      controller: cubit.roomNameController,
                      labelText: 'Room Name',
                      keyboardType: TextInputType.text,
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      onChanged: (value) {},
                      onSubmit: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "You Must Enter Your Room Name!";
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          cubit.isPublicRoom
                              ? Text(
                                  'Public',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  'Private',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.53,
                          ),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            activeTrackColor:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            value: cubit.isPublicRoom,
                            onChanged: (value) {
                              setState(() => cubit.isPublicRoom = value);
                              print("PublicRoom:${cubit.isPublicRoom}");
                            },
                          ),
                        ],
                      ),
                      cubit.isPublicRoom
                          ? Text('Any one Can Enter The Room',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ))
                          : Text('Only people have link can enter',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Record and Save as PodCast',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.049,
                          ),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            activeTrackColor:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            value: cubit.isRecordRoom,
                            onChanged: (value) {
                              setState(() => cubit.isRecordRoom = value);
                              print("recordRoom:${cubit.isRecordRoom}");
                            },
                          ),
                        ],
                      ),
                      Text('The room will be saved in Your Profile as PodCast ',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  defaultButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print(cubit.roomNameController.text);
                      }
                    },
                    context: context,
                    text: 'Create',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
