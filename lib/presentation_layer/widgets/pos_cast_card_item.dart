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
}) {
  ////////////////////////////////////////////////////
  String token = CachHelper.getData(key: 'token');
  String photoUrl =
      GetAllPodCastModel.getPodcastUserPublishInform(index!)[0]['photo'];

  String username =
      GetAllPodCastModel.getPodcastUserPublishInform(index)[0]['name'];
  String podCastName = GetAllPodCastModel.getPodcastName(index);
  int likes = GetAllPodCastModel.getPodcastLikes(index);
  bool likeState = GetAllPodCastModel.getPodcastlikeState(index);
  String podCastId = GetAllPodCastModel.getPodcastID(index);
  double time = GetAllPodCastModel.getPodCastAudio(index)[0]['duration'];
  String convertedTime =
      '${((time % (24 * 3600)) / 3600).round().toString()}:${((time % (24 * 3600 * 3600)) / 60).round().toString()}:${(time % 60).round().toString()}';
  var cubit = GeneralAppCubit?.get(context);
  String currentId = GetAllPodCastModel.getPodcastID(index);
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
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 15),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Theme.of(context).backgroundColor,
                        child: InkWell(
                          onTap: () {
                            cubit.getPodCastLikes(
                                context: context,
                                token: token,
                                podCastId: podCastId);
                          },
                          child: Text(
                            likes.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 15.0, bottom: 15),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).backgroundColor,
                        child: IconButton(
                            splashRadius: 25,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              likeState
                                  ? cubit.removeLike(
                                      podCastId: podCastId, token: token)
                                  : cubit.addLike(
                                      podCastId: podCastId, token: token);
                            },
                            icon: Icon(
                              likeState
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            )),
                      ),
                    ),
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
                        Text(podCastName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(username,
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
