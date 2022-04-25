class GetAllPodCastModel {
  static Map<String, dynamic>? getAllPodCast;
  static List? audio;
  static List? creditBy;
  static int? likes;
  static String? id;
  static String? name;
  static String? category;
  static bool? isLiked;
  static int? podCastCount;
  static List getPodCastAudio(int index) {
    return audio = [getAllPodCast?['data'][index]['audio']];
  }

  static int? getPodCastcount() {
    return podCastCount = getAllPodCast?['docsCount'];
  }

  static int getPodcastLikes(int index) {
    return likes = getAllPodCast?['data'][index]['likes'];
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
    creditBy = [getAllPodCast?['data'][index]['createdBy']];
    if (creditBy?[0]['photo'] == null) {
      creditBy?[0]['photo'] =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3-lQXGq-2WPJR5aE_l74q-mR61wDrZXUYhA&usqp=CAU';
    }

    return creditBy!;
  }

  static bool getPodcastlikeState(int index) {
    return isLiked = getAllPodCast?['data'][index]['isLiked'];
  }
}
