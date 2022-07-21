import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:flutter/material.dart';

Widget podACastItem(
  BuildContext context, {
  String? speaker,
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
  var hours = (time / (60 * 60)).floor();
  var minutes = ((time - hours * 60 * 60) / 60).floor();
  var second = ((time - hours * 60 * 60 - minutes * 60)).floor();
  String convertedTime =
      '${hours.toString()}:${minutes.toString()}:${second.toString()}';
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
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
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
