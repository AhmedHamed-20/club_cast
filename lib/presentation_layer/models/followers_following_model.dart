class Followers {
  static Map<String, dynamic>? followersModel;
  static String? photo;
  static String? userid;
  static String? name;

  static String getUserID(int index) {
    return userid =
        followersModel!['data'][index]['follower']['_id'].toString();
  }

  static String getUserName(int index) {
    return name = followersModel!['data'][index]['follower']['name'];
  }

  static String getUserPhoto(int index) {
    return photo = followersModel!['data'][index]['follower']['photo'];
  }
}

class Following {
  static Map<String, dynamic>? followingModel;
  static String? photo;
  static String? userid;
  static String? name;

  static String getUserID(int index) {
    return userid =
        followingModel!['data'][index]['following']['_id'].toString();
  }

  static String getUserName(int index) {
    return name = followingModel!['data'][index]['following']['name'];
  }

  static String getUserPhoto(int index) {
    photo = followingModel!['data'][index]['following']['photo'];
    if (photo == null) {
      photo =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3-lQXGq-2WPJR5aE_l74q-mR61wDrZXUYhA&usqp=CAU';
    }

    return photo!;
  }
}
