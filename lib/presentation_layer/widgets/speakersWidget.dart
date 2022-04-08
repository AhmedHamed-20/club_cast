import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:club_cast/presentation_layer/widgets/model_sheet_room_contant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../data_layer/bloc/room_cubit/room_cubit.dart';
import '../models/user_model.dart';

Widget speakersWiget({
  required cubit,
  required bool isAdmin,
}) {
  return Row(
    children: [
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cubit.speakers.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                GetUserModel.getUserID() !=
                        RoomCubit.get(context).speakers[index]['_id']
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
                            cubit.speakers[index]['name'],
                            cubit.speakers[index]['photo'],
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
                                            SocketFunc
                                                .adminReturnUserBackToAudienc(
                                                    RoomCubit.get(context)
                                                        .speakers[index]);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Make Him Listener',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        // Expanded(
                        //   flex: 5,
                        //   child: CircleAvatar(
                        //     radius: 35,
                        //     backgroundImage:
                        //         NetworkImage(cubit.speakers[index]['photo']),
                        //   ),
                        // ),

                        Expanded(
                          flex: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: MediaQuery.of(context).size.width * 0.18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                width: cubit.speakers == []
                                    ? 0
                                    : cubit.speakers[index]?['isTalking']
                                        ? 3.0
                                        : 0,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  cubit.speakers[index]['photo'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cubit.speakers[index]['name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cubit.speakers == []
                      ? const SizedBox()
                      : cubit.speakers[index]?['isMuted']
                          ? Positioned(
                              top: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 15,
                                child: const Icon(
                                  Icons.mic_off,
                                  size: 19,
                                ),
                              ),
                            )
                          : const SizedBox(),
                ],
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100),
        ),
      ),
    ],
  );
}
