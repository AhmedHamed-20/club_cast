import 'package:flutter/material.dart';

class GetMyFollowingPodCastsModel {
  static Map<String, dynamic>? getMyFollowingPodcasts;
  static List? audio;
  static List? creditBy;
  static int? likes;
  static String? id;
  static String? name;
  static String? category;
  static bool? isLiked;
  static List getPodCastAudio(int index) {
    return audio = [getMyFollowingPodcasts!['data'][index]['audio']];
  }

  static int getPodcastLikes(int index) {
    return likes = getMyFollowingPodcasts!['data'][index]['likes'];
  }

  static String getPodcastID(int index) {
    return id = getMyFollowingPodcasts!['data'][index]['_id'].toString();
  }

  static String getPodcastName(int index) {
    return name = getMyFollowingPodcasts!['data'][index]['name'];
  }

  static String getPodcastGategory(int index) {
    return category =
        getMyFollowingPodcasts!['data'][index]['category'].toString();
  }

  static List getPodcastUserPublishInform(int index) {
    creditBy = [getMyFollowingPodcasts?['data'][index]['createdBy']];
    if (creditBy?[0]['photo'] == null) {
      print('here');
      creditBy?[0]['photo'] =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3-lQXGq-2WPJR5aE_l74q-mR61wDrZXUYhA&usqp=CAU';
    }

    return creditBy!;
  }

  static bool getPodcastlikeState(int index) {
    return isLiked = getMyFollowingPodcasts!['data'][index]['isLiked'];
  }
}
