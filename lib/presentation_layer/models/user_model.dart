class GetUserModel {
  static Map<String, dynamic>? getUserModel;
  static String? photoUrl;
  static String? userid;
  static String? name;
  static String? email;


  static String getUserID()
  {
    return userid =
        getUserModel!['data']['data']['_id'];
  }

  static String getUserName()
  {
    return name = getUserModel!['data']['data']['name'];
  }
  static String getUserEmail()
  {
    return name = getUserModel!['data']['data']['email'];
  }

  static String getPhotoUrlName()
  {
    return photoUrl = getUserModel!['data']['data']['photo'];
  }
  static void updateName(String name)
  {
    getUserModel!['data']['data']['name']=name;
  }
  static void updateEmail(String email)
  {
    getUserModel!['data']['data']['email']=email;
  }
}
