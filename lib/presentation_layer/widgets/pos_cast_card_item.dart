import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:flutter/material.dart';

Widget podACastItem(
  BuildContext context, {
  String? roomName,
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
  String? podcastName,
  VoidCallback? ontapOnCircleAvater,
}) {
  ////////////////////////////////////////////////////
  String token = CachHelper.getData(key: 'token');
  String photoUrl = photourl!;

  double time = gettime!;
  String convertedTime =
      '${((time % (24 * 3600)) / 3600).round().toString()}:${((time % (24 * 3600 * 3600)) / 60).round().toString()}:${(time % 60).round().toString()}';
  var cubit = GeneralAppCubit?.get(context);
  ////////////////////////////////////////////////////////
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: Theme.of(context).backgroundColor,
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: ontapOnCircleAvater,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
            title: Text(podcastName!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.grey)),
                Text(
                  text == null ? convertedTime : text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    downloadButton!,
                    playingWidget!,
                  ],
                ),
              ],
            ),
            trailing: removePodCast!,
            horizontalTitleGap: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                podCastLikes!,
                likeWidget!,
              ],
            ),
          )
        ],
      ),
    ),
  );
}
