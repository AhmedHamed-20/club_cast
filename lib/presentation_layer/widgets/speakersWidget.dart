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
                showBottomSheet(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                          isAdmin
                              ? Card(
                                  elevation: 3,
                                  color: Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Make Him Listener',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage(cubit.speakers[index]['photo']),
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
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100),
        ),
      ),
    ],
  );
}
