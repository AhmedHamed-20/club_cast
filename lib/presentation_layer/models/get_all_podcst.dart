class GetAllPodCastModel {
  static Map<String, dynamic>? getAllPodCast;
  static List? audio;
  static List? creditBy;
  static int? likes;
  static String? id;
  static String? name;
  static String? category;
  static bool? isLiked;
  static List getPodCastAudio(int index) {
    return audio = [getAllPodCast!['data'][index]['audio']];
  }

  static int getPodcastLikes(int index) {
    return likes = getAllPodCast!['data'][index]['likes'];
  }

  static String getPodcastID(int index) {
    return id = getAllPodCast!['data'][index]['_id'].toString();
  }

  static String getPodcastName(int index) {
    return name = getAllPodCast!['data'][index]['name'];
  }

  static String getPodcastGategory(int index) {
    return category = getAllPodCast!['data'][index]['category'].toString();
  }

  static List getPodcastUserPublishInform(int index) {
    return creditBy = [getAllPodCast!['data'][index]['createdBy']];
  }

  static bool getPodcastlikeState(int index) {
    return isLiked = getAllPodCast!['data'][index]['isLiked'];
  }
}
