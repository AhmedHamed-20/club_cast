class GetUserModel {
  static Map<String, dynamic>? getUserModel;
  static String? photoUrl;
  static String? userid;
  static String? name;
  static String? email;
  static int? followers;
  static int? following;
  static String? photo;
  static String? bio;



  static String getUserID() {
    return userid = getUserModel!['data']['data']['_id'];
  }

  static String getUserName() {
    return name = getUserModel?['data']['data']['name'];
  }


  static String getUserEmail() {
    return email = getUserModel!['data']['data']['email'];
  }

  static int getUserFollowers() {
    return followers = getUserModel!['data']['data']['followers'];
  }

  static int getUserFollowing() {
    return following = getUserModel?['data']['data']['following'];
  }

  static String? getUserPhoto() {
    return photo = getUserModel?['data']['data']['photo'];
  }
  static String? getUserBio() {
    return bio = getUserModel!['data']['data']['bio'];
  }

  static void updateName(String name) {
    getUserModel!['data']['data']['name'] = name;
  }

  static void updateEmail(String email) {
    getUserModel!['data']['data']['email'] = email;
  }
  static void updateBio(String bio) {
    getUserModel!['data']['data']['bio'] = bio;
  }
}
