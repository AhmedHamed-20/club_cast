import 'package:club_cast/data_layer/bloc/room_cubit/room_cubit.dart';
import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                    ? showBottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  elevation: 3,
                                  color: Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Follow',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                                isAdmin
                                    ? Card(
                                        elevation: 3,
                                        color:
                                            Theme.of(context).backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: MaterialButton(
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
