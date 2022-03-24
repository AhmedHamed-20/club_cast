class GetExplorePodCastModel {
  static Map<String, dynamic>? getExplorePodCast;
  static List? audio;
  static List? creditBy;
  static int? likes;
  static String? id;
  static String? name;
  static String? category;
  static bool? isLiked;
  static int? podCastCount;
  static List getPodCastAudio(int index) {
    return audio = [getExplorePodCast?['data'][index]['audio']];
  }

  static int? getPodCastcount() {
    return podCastCount = getExplorePodCast?['docsCount'];
  }

  static int getPodcastLikes(int index) {
    return likes = getExplorePodCast?['data'][index]['likes'];
  }

  static String getPodcastID(int index) {
    return id = getExplorePodCast!['data'][index]['_id'].toString();
  }

  static String getPodcastName(int index) {
    return name = getExplorePodCast!['data'][index]['name'];
  }

  static String getPodcastGategory(int index) {
    return category = getExplorePodCast!['data'][index]['category'].toString();
  }

  static List getPodcastUserPublishInform(int index) {
    return creditBy = [getExplorePodCast?['data'][index]['createdBy']];
  }

  static bool getPodcastlikeState(int index) {
    return isLiked = getExplorePodCast?['data'][index]['isLiked'];
  }
}
