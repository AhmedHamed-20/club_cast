class GetMyPodCastModel {
  static Map<String, dynamic>? getMyPodCast;
  static List? audio;
  static List? creditBy;
  static int? likes;
  static String? id;
  static String? name;
  static String? category;
  static bool? isLiked;
  static int? podCastCount;
  static List getPodCastAudio(int index) {
    return audio = [getMyPodCast?['data'][index]['audio']];
  }

  static int getPodcastLikes(int index) {
    return likes = getMyPodCast?['data'][index]['likes'];
  }

  static int getPodCastcount() {
    return podCastCount = getMyPodCast?['docsCount'];
  }

  static String getPodcastID(int index) {
    return id = getMyPodCast!['data'][index]['_id'].toString();
  }

  static String getPodcastName(int index) {
    return name = getMyPodCast!['data'][index]['name'];
  }

  static String? getPodcastGategory(int index) {
    return category = getMyPodCast?['data'][index]['category'].toString();
  }

  static List getPodcastUserPublishInform(int index) {
    return creditBy = [getMyPodCast?['data'][index]['createdBy']];
  }

  static bool getPodcastlikeState(int index) {
    return isLiked = getMyPodCast?['data'][index]['isLiked'];
  }
}
