import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:flutter/material.dart';

Widget podACastItem(BuildContext context,
    {String? roomName,
    String? speaker,
    String? roomTime,
    int? index,
    Widget? playingWidget,
    String? text,
    Widget? downloadButton,
    Widget? removePodCast,
    Widget? podCastLikes,
    Widget? likeWidget,
    double? gettime,
    String? photourl,
    String? userName,
    String? podcastName}) {
  ////////////////////////////////////////////////////
  String token = CachHelper.getData(key: 'token');
  String photoUrl = photourl!;

  double time = gettime!;
  String convertedTime =
      '${((time % (24 * 3600)) / 3600).round().toString()}:${((time % (24 * 3600 * 3600)) / 60).round().toString()}:${(time % 60).round().toString()}';
  var cubit = GeneralAppCubit?.get(context);
  ////////////////////////////////////////////////////////
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.25,
    width: double.infinity,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                Spacer(),
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    podCastLikes!,
                    likeWidget!,
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(podcastName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(userName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.32,
                    ),
                    removePodCast!,
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Text(
                        text == null ? convertedTime : text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    downloadButton!,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    playingWidget!,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
