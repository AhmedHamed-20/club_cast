import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/get_all_podcst.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:flutter/material.dart';

Widget podACastItem(
  BuildContext context, {
  String? roomName,
  String? speaker,
  String? roomTime,
  int? index,
}) {
  ////////////////////////////////////////////////////
  String token = CachHelper.getData(key: 'token');
  String photoUrl =
      GetAllPodCastModel.getPodcastUserPublishInform(index!)[0]['photo'];
  ;
  String Username =
      GetAllPodCastModel.getPodcastUserPublishInform(index)[0]['name'];
  String podCastName = GetAllPodCastModel.getPodcastName(index);
  int likes = GetAllPodCastModel.getPodcastLikes(index);
  bool likeState = GetAllPodCastModel.getPodcastlikeState(index);
  String podCastId = GetAllPodCastModel.getPodcastID(index);
  double time = GetAllPodCastModel.getPodCastAudio(index)[0]['duration'];
  var cubit = GeneralAppCubit?.get(context);
  ////////////////////////////////////////////////////////
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.25,
    width: double.infinity,
    child: Card(
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
                        backgroundColor: Colors.white,
                        child: Text(
                          likes.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 15.0, bottom: 15),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            splashRadius: 25,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              cubit.addLike(podCastId: podCastId, token: token);
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
                Text(podCastName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(Username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1),
                Row(
                  children: [
                    Text(
                      time.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.16,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cloud_download_outlined,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline_outlined,
                        size: 35,
                      ),
                    )
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
