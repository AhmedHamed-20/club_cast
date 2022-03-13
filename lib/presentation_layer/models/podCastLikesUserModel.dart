class GetPodCastUsersLikesModel {
  static Map<String, dynamic>? getAllPodCastLikes;
  static String? photoUrl;

  static String? userid;
  static String? name;

  static String getUserID(int index) {
    return userid =
        getAllPodCastLikes!['data'][index]['user']['_id'].toString();
  }

  static String getUserName(int index) {
    return name = getAllPodCastLikes!['data'][index]['user']['name'];
  }

  static String getPhotoUrltName(int index) {
    return photoUrl = getAllPodCastLikes!['data'][index]['user']['photo'];
  }
}
