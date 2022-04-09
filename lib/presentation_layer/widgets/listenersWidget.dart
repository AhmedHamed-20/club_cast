import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/constant/constant.dart';
import '../screens/profile_detailes_screen.dart';
import 'model_sheet_room_contant.dart';

Widget listenersWiget({
  required cubit,
  required bool isAdmin,
}) {
  return Row(
    children: [
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cubit.listener.length,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                print(GetUserModel.getUserID());
                print(RoomCubit.get(context).listener[index]['_id']);
                GetUserModel.getUserID() !=
                        RoomCubit.get(context).listener[index]['_id']
                    ? showModalBottomSheet(
                        backgroundColor: Theme.of(context).backgroundColor,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        context: context,
                        builder: (context) {
                          return WidgetFunc.bottomSheetContant(
                            context,
                            cubit.listener[index]['name'],
                            cubit.listener[index]['photo'],
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isAdmin
                                    ? Card(
                                        elevation: 3,
                                        color: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          onPressed: () {
                                            RoomCubit.get(context)
                                                        .listener[index]
                                                    ['askedToTalk']
                                                ? SocketFunc
                                                    .adminGivePermissionForUserToTalk(
                                                        RoomCubit.get(context)
                                                            .listener[index])
                                                : showToast(
                                                    message: "User didn't ask",
                                                    toastState:
                                                        ToastState.WARNING);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Make Him Speaker',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                Card(
                                  elevation: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onPressed: () {
                                      GeneralAppCubit.get(context).getUserById(
                                          profileId: cubit.listener[index]
                                              ['_id']);

                                      GeneralAppCubit.get(context)
                                          .getUserPodcast(token,
                                              cubit.listener[index]['_id'])
                                          .then((value) {
                                        navigatePushTo(
                                            context: context,
                                            navigateTo: ProfileDetailsScreen(
                                                cubit.listener[index]['_id']));
                                      });
                                    },
                                    child: Text(
                                      'View profile',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            cubit.listener[index]['photo'],
                          ),
                        ),
                        RoomCubit.get(context).listener[index]['askedToTalk'] &&
                                isAdmin
                            ? Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 15,
                                  child: Center(
                                    child: Icon(
                                      MdiIcons.handBackLeft,
                                      color: Theme.of(context).primaryColor,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      cubit.listener[index]['name'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
          ),
        ),
      ),
    ],
  );
}
