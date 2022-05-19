class PodCastSearchModel {
  static Map<String, dynamic> getMyPodCast = {};

  static Map<String, dynamic> getPodCastAudio(int index) {
    return getMyPodCast['data'][index]['audio'];
  }

  static int getPodcastLikes(int index) {
    return getMyPodCast['data'][index]['likes'];
  }

  static String getPodcastID(int index) {
    return getMyPodCast['data'][index]['_id'].toString();
  }

  static String getPodcastName(int index) {
    return getMyPodCast['data'][index]['name'];
  }

  static String? getPodcastCategory(int index) {
    return getMyPodCast['data'][index]['category'].toString();
  }

  static Map<String, dynamic> getPodcastUserPublishInform(int index) {
    return getMyPodCast['data'][index]['createdBy'];
  }
}
